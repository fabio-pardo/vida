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
    """Returns the current week number"""
    return datetime.datetime.now().isocalendar()[1]


def get_meals_this_week(week_number: int = get_current_week()) -> "list[dict]":
    """Returns a list of meals for the given week number"""
    return mock_meals if week_number % 2 == 0 else []


@router.get("/")
def read_root():
    return get_meals_this_week()


@router.get("/meal/{meal_id}")
def read_meal(meal_id: int):
    return (
        mock_meals[meal_id - 1]
        if meal_id - 1 < len(mock_meals)
        else {"message": "Meal not found"}
    )


@router.get("/week/{week_number}")
def read_week_meals(week_number: int):
    return get_meals_this_week(week_number)


@router.get("/next_week")
def read_next_meals():
    next_week_number = get_current_week() + 1
    return get_meals_this_week(next_week_number)


@router.get("/previous_week")
def read_previous_meals():
    previous_week_number = get_current_week() - 1
    return get_meals_this_week(previous_week_number)
