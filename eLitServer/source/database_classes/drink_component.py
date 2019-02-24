from typing import Dict

import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.ingredient import Ingredient
from database_classes.unit import *
from database_classes.drink_object import DrinkObject


class DrinkComponent(DrinkObject):
    qty = me.FloatField(default=0.0)
    unit = me.StringField(required=True, unique=False)
    ingredient = me.ReferenceField(Ingredient, required=True, reverse_delete_rule=me.NULLIFY)

    def __init__(self, ingredient: Ingredient, qty: float = 0.0, unit: str = None, *args, **values):
        super().__init__(*args, **values)
        self.ingredient = ingredient
        self.qty = qty
        self.unit = unit

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['qty'] = str(self.qty)
        data['unit'] = self.unit
        data['ingredient'] = self.ingredient.to_dict()
        return data

