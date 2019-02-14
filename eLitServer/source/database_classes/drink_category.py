from typing import Dict

import mongoengine as me
from database_classes import *
from database_classes.drink_object import DrinkObject


class DrinkCategory(DrinkObject):
    name = me.StringField(required=True, unique=True)
    image = me.StringField()

    def __init__(self, name: str, image: str = None, *args, **values):
        super().__init__(*args, **values)
        self.name = name
        self.image = image

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['name'] = self.name
        data['image'] = self.image
        return data
