from typing import Dict

import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.drink_object import DrinkObject


class Ingredient(DrinkObject):
    name = me.StringField(required=True, unique=True)
    grade = me.FloatField()
    image = me.StringField()
    ingredient_description = me.StringField()

    def __init__(self, name: str, grade: float = 0, image: str = '', ingredient_description: str = '', *args, **values):
        super().__init__(*args, **values)
        self.name = name
        self.grade = grade
        self.ingredient_description = ingredient_description
        self.image = image

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['name'] = self.name
        data['grade'] = self.grade
        data['ingredient_description'] = self.ingredient_description
        data['image'] = self.image
        return data
