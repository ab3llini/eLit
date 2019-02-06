import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.drink import Drink
from database_classes.user import User
from typing import List, Dict
import datetime


class Review(DBObject):
    title: me.StringField()
    text: me.StringField()
    rating: me.FloatField(required=True)
    for_drink: me.ReferenceField(Drink, required=True)
    written_by: me.ReferenceField(User, required=True)
    timestamp: me.DateTimeField(default=datetime.datetime.utcnow)

    def __init__(self, title: str = "", text: str = "", rating: float = 0.0, for_drink: Drink = None,
                 written_by: User = None, timestamp=None, *args, **values):
        super().__init__(*args, **values)
        self.title = title
        self.text = text
        self.rating = rating
        self.for_drink = for_drink
        self.written_by = written_by
        self.timestamp = timestamp or datetime.datetime.utcnow

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['title'] = self.title
        data['text'] = self.text
        data['rating'] = str(self.rating)
        data['for_drink_name'] = self.for_drink.name
        data['written_by'] = self.written_by.name + ' ' + self.written_by.family_name
        data['timestamp'] = self.timestamp

        return data
