from typing import Dict

import mongoengine as me
from database_classes.db_object import DBObject


class Ingredient(DBObject):
    name = me.StringField(required=True, unique=True)
    grade = me.IntField()
    ingredient_description = me.StringField()

    def __init__(self, name: str, grade: int = 0, ingredient_description: str = '', *args, **values):
        super().__init__(*args, **values)
        self.name = name
        self.grade = grade
        self.ingredient_description = ingredient_description

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['name'] = self.name
        data['grade'] = self.grade
        data['ingredient_description'] = self.ingredient_description
        return data
