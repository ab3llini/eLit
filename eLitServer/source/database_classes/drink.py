from typing import Dict

import mongoengine as me
from database_classes import *
from database_classes.drink_object import DrinkObject
from database_classes.recipe import Recipe
from database_classes.drink_category import DrinkCategory


class Drink(DrinkObject):
    name = me.StringField(required=True, unique=True)
    degree = me.IntField(required=True)
    image = me.StringField()
    recipe = me.ReferenceField(Recipe, required=True)
    description = me.StringField()
    category = me.ReferenceField(DrinkCategory, required=True)

    def __init__(self, name: str, degree: int, image: str = None, description: str = '',
                 recipe: Recipe = None, category: DrinkCategory = None, *args, **values):
        super().__init__(*args, **values)
        self.name = name
        self.degree = degree
        self.image = image
        self.recipe = recipe
        self.description = description
        self.category = category

    def save(self, force_insert=False, validate=True, clean=True, write_concern=None, cascade=None, cascade_kwargs=None,
             _refs=None, save_condition=None, signal_kwargs=None, **kwargs):
        self.recipe.save()
        self.category.save()
        return super().save(force_insert, validate, clean, write_concern, cascade, cascade_kwargs, _refs,
                            save_condition, signal_kwargs, **kwargs)

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['name'] = self.name
        data['degree'] = self.degree
        data['image'] = self.image
        data['recipe'] = self.recipe.to_dict()
        data['category'] = self.category.to_dict()
        data['drink_description'] = self.description
        return data
