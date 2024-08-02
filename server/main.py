import os
import requests
from fastapi import FastAPI, HTTPException, Depends, APIRouter
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, String, Integer, ForeignKey
from sqlalchemy.orm import sessionmaker, relationship, Session
from passlib.context import CryptContext
from sqlalchemy.ext.declarative import declarative_base
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = FastAPI()

# SQLAlchemy setup
SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./test.db")
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Database Models
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    history = relationship("History", back_populates="owner")

class History(Base):
    __tablename__ = "history"
    id = Column(Integer, primary_key=True, index=True)
    text = Column(String)
    response = Column(String)
    type = Column(String)
    owner_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="history")

# Create the database tables
Base.metadata.create_all(bind=engine)

# Pydantic models
class AIRequest(BaseModel):
    text: str
    type: str
    id: int

class HistoryEntry(BaseModel):
    text: str
    response: str
    type: str
    id: int

class UserCreate(BaseModel):
    username: str
    password: str

class UserLogin(BaseModel):
    username: str
    password: str

class UserResponse(BaseModel):
    username: str

# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Create API router
router = APIRouter()
API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent"

def process_text_with_gemini(prompt: str, request_type: str) -> str:
    headers = {
        "Content-Type": "application/json",
    }
    
    # Prepare the payload based on the request type
    if request_type == "summarize":
        content = [
            {"role": "user", "parts": [{"text": f"Summarize the following text: '{prompt}' within 15-20 bullet points covering all the content. Make it concise and accurate"}]}
        ]
    elif request_type == "notes":
        content = [
            {"role": "user", "parts": [{"text": f"Create concise notes from the following text: '{prompt}'. Divide the content into headings and subheadings, use short concise bullet points for each topic"}]}
        ]
    elif request_type == "questions":
        content = [
            {"role": "user", "parts": [{"text": f"Generate questions from the following text: '{prompt}'"}]}
        ]
    elif request_type == "extra_info":
        content = [
            {"role": "user", "parts": [{"text": f"Provide additional resources related to: '{prompt}' - 3-4 Books, 2 articles, 2-3 videos, 1-2 research papers, and their links"}]}
        ]
    elif request_type == "explain_like_im_five":
        content = [
            {"role": "user", "parts": [{"text": f"Explain '{prompt}' in a simple way suitable for a 5-year-old"}]}
        ]
    elif request_type == "chat_with_me":
        content = [
            {"role": "user", "parts": [{"text": f"Lets talk, '{prompt}'"}]}
        ]
    else:
        raise HTTPException(status_code=400, detail="Invalid 'type' specified.")
    
    payload = {
        "contents": content
    }
    
    response = requests.post(
        f"{GEMINI_API_URL}?key={API_KEY}",
        json=payload,
        headers=headers
    )
    
    # Debugging: Print status code, response text, and response JSON
    print("Status Code:", response.status_code)
    print("Response Text:", response.text)
    
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)
    
    response_data = response.json()
    
    # Debugging: Print JSON response
    print("Response JSON:", response_data)
    
    # Extract the text from the response data
    try:
        # Navigate through the response structure to get the text part
        result_text = response_data['candidates'][0]['content']['parts'][0]['text']
    except (IndexError, KeyError) as e:
        raise HTTPException(status_code=500, detail=f"Error processing response: {e}")
    
    return result_text


@router.post("/")
async def process_text(request_data: AIRequest, db: Session = Depends(get_db)):
    try:
        response_text = process_text_with_gemini(request_data.text, request_data.type)
        
        history_entry = History(
            text=request_data.text,
            response=response_text,
            type=request_data.type,
            owner_id=request_data.id
        )
        db.add(history_entry)
        db.commit()
        
        return {"result": response_text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

app.include_router(router, prefix="/process")

@app.get("/history")
def get_history(db: Session = Depends(get_db)):
    history_entries = db.query(History).all()
    return history_entries

@app.get("/users")
def get_users(db: Session = Depends(get_db)):
    users = db.query(User).all()
    return users

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

# Signup endpoint
@app.post("/signup/", response_model=UserResponse)
def signup(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.username == user.username).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    new_user = User(username=user.username, hashed_password=get_password_hash(user.password))
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return {"username": new_user.username}

# Login endpoint
@app.post("/login/", response_model=UserResponse)
def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.username == user.username).first()
    if not db_user or not verify_password(user.password, db_user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    return {"username": db_user.username}
