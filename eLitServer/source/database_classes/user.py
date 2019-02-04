from typing import Dict

import mongoengine as me
from database_classes.db_object import DBObject
import datetime


class User(DBObject):
    email = me.StringField(required=True, unique=True)
    name = me.StringField()
    family_name = me.StringField()
    image_url = me.StringField()
    user_id = me.StringField(required=True, unique=True)
    sign_in_date = me.DateTimeField(default=datetime.datetime.utcnow)

    def __init__(self, email: str = None, name: str = None, family_name: str = None, image_url: str = None,
                 user_id: str = None, sign_in_date = None, data_dict: Dict = None, *args, **values):
        if data_dict is None:
            self.email = email
            self.name = name
            self.family_name = family_name
            self.image_url = image_url
            self.user_id = user_id
            self.sign_in_date = sign_in_date or datetime.datetime.utcnow()

        else:
            self.email = data_dict['email']
            self.name = data_dict['name']
            self.family_name = data_dict['family_name']
            self.image_url = data_dict['image_url']
            self.user_id = data_dict['user_id']
            self.sign_in_date = datetime.datetime.utcnow()

        super().__init__(*args, **values)


