from typing import Dict

import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.recipe import Recipe


class Drink(DBObject):
    name = me.StringField(required=True, unique=True)
    degree = me.IntField(required=True)
    image = me.StringField()
    recipe = me.ReferenceField(Recipe, required=False)
    description = me.StringField(required=False)

    def __init__(self, name: str, degree: int, image: str = None, description: str = '', recipe: Recipe = None, *args, **values):
        super().__init__(*args, **values)
        self.name = name
        self.degree = degree
        self.image = image
        self.recipe = recipe
        self.description = description

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['name'] = self.name
        data['degree'] = self.degree
        data['image'] = self.image
        data['recipe'] = self.recipe.to_dict()
        data['drink_description'] = self.description
        return data
