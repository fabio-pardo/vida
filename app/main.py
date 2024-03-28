from fastapi import FastAPI

from app.routers import meals

app = FastAPI()

app.include_router(meals.router)
