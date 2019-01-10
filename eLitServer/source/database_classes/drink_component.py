import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.ingredient import Ingredient
from database_classes.unit import *


class DrinkComponent(DBObject):
    qty = me.IntField()
    unit = me.StringField(required=True, unique=True, choices=UNITS)
    ingredient = me.ReferenceField(Ingredient, required=True)

    def __init__(self, ingredient_name: str, qty: int = None, unit: str = None, *args, **values):
        super().__init__(*args, **values)
        ingredient = Ingredient.objects(name=ingredient_name)
        self.ingredient = ingredient
        self.qty = qty
        self.unit = unit
