from typing import Union

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(
    prefix="/items",
    tags=["items"],
    # dependencies = [Depends(get_token_header)]
    responses={404: {"description": "Not found"}},
)


class Item(BaseModel):
    name: str
    price: float
    is_offer: Union[bool, None] = None


@router.get("/")
def read_root():
    return {"ITEMS": "HELLO WORLD"}


@router.get("/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@router.put("/{item_id}")
def update_item(item_id: int, item: Item):
    return {"item_name": item.name, "item_id": item_id}
