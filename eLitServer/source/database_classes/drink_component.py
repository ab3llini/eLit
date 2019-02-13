from typing import Dict

import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.ingredient import Ingredient
from database_classes.unit import *
from database_classes.drink_object import DrinkObject


class DrinkComponent(DrinkObject):
    qty = me.IntField()
    unit = me.StringField(required=True, unique=False, choices=UNITS)
    ingredient = me.ReferenceField(Ingredient, required=True)

    def __init__(self, ingredient: Ingredient, qty: int = None, unit: str = None, *args, **values):
        super().__init__(*args, **values)
        self.ingredient = ingredient
        self.qty = qty
        self.unit = unit

    def save(self, force_insert=False, validate=True, clean=True, write_concern=None, cascade=None, cascade_kwargs=None,
             _refs=None, save_condition=None, signal_kwargs=None, **kwargs):
        self.ingredient.save()
        return super().save(force_insert, validate, clean, write_concern, cascade, cascade_kwargs, _refs,
                            save_condition, signal_kwargs, **kwargs)

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['qty'] = self.qty
        data['unit'] = self.unit
        data['ingredient'] = self.ingredient.to_dict()
        return data

