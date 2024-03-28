import datetime

from fastapi.routing import APIRouter

router = APIRouter(
    prefix="/meals",
    tags=["meals"],
    # dependencies = [Depends(get_token_header)]
    responses={404: {"description": "Not found"}},
)

# This is just a mock data
mock_meals = [
    {"id": 1, "name": "Pizza"},
    {"id": 2, "name": "Pasta"},
    {"id": 3, "name": "Salad"},
    {"id": 4, "name": "Soup"},
    {"id": 5, "name": "Bread"},
]


def get_current_week() -> int:
    return datetime.datetime.now().isocalendar()[1]


def get_meals_this_week(week_number: int = get_current_week()) -> "list[dict]":
    return mock_meals if week_number % 2 == 0 else []


@router.get("/")
def read_root():
    return get_meals_this_week()
