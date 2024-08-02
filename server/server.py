import random
import os
from fastapi import FastAPI, HTTPException, Depends, APIRouter
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, String, Integer, ForeignKey
from sqlalchemy.orm import sessionmaker, relationship
from passlib.context import CryptContext
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import openai
from sqlalchemy.orm import Session
from PIL import Image
import pytesseract
app = FastAPI()

# SQLAlchemy setup
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
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

# ocr_script.py




# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# OpenAI router
router = APIRouter()
openai.api_key = os.getenv("OPENAI")


@router.post("/")
def process_text(request_data: AIRequest, db: Session = Depends(get_db)):
    try:
        response = None
        if request_data.type == "summarize":
            response = openai.completions.create(
                model="text-davinci-002",
                prompt=f"Summarize the following text: '{request_data.text}' within 15-20 bullet points covering all the content. Make it concise and accurate",
                max_tokens=150
            )
        elif request_data.type == "notes":
            response = openai.completions.create(
                model="text-davinci-002",
                prompt=f"Create concise notes from the following text: '{request_data.text}'. Divide the content into headings and subheadings, use short concise bullet points for each topic",
                max_tokens=200
            )
        elif request_data.type == "questions":
            response = openai.completions.create(
                model="text-davinci-002",
                prompt=f"Generate questions from the following text: '{request_data.text}'",
                max_tokens=200
            )
        elif request_data.type == "extra_info":
            response = openai.completions.create(
                model="text-davinci-002",
                prompt=f"Provide additional resources related to: '{request_data.text}' - 3-4 Books, 2 articles, 2-3 videos, 1-2 research papers, and their links",
                max_tokens=300
            )
        elif request_data.type == "explain_like_im_five":
            response = openai.completions.create(
                model="text-davinci-002",
                prompt=f"Explain '{request_data.text}' in a simple way suitable for a 5-year-old",
                max_tokens=250
            )
        elif request_data.type == "chat_with_me":
            response = openai.completions.create(
                model="text-davinci-002",
                prompt=f"Lets talk, '{request_data.text}'",
                max_tokens=250
            )
        else:
            raise HTTPException(status_code=400, detail="Invalid 'type' specified.")

        history_entry = History(text=request_data.text, response=response.choices[0].text, type=request_data.type,
                                id=request_data.id)
        db.add(history_entry)
        db.commit()

        return {"result": response.choices[0].text}
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