from fastapi import FastAPI

from app.routers import items, meals

app = FastAPI()

app.include_router(items.router)
app.include_router(meals.router)
