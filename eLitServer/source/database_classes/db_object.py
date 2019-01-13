import mongoengine as me
from hashlib import md5
from pickle import dumps


class DBObject(me.Document):
    fingerprint = me.StringField(required=True)
    meta = {'allow_inheritance': True}

    def __init__(self, *args, **values):
        super().__init__(*args, **values)
        self.fingerprint = md5(dumps(self)).hexdigest()
