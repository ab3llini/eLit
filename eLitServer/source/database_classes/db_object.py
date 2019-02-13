import mongoengine as me
from hashlib import md5
from pickle import dumps
from typing import Dict


class DBObject(me.Document):
    fingerprint = me.StringField(required=True, unique=True)
    meta = {
        'allow_inheritance': True,
        'abstract': True
    }

    def __init__(self, *args, **values):
        super().__init__(*args, **values)

    def save(self, force_insert=False, validate=True, clean=True, write_concern=None, cascade=None, cascade_kwargs=None,
             _refs=None, save_condition=None, signal_kwargs=None, **kwargs):

        self.fingerprint = md5(dumps(self.to_dict())).hexdigest()
        return super().save(force_insert, validate, clean, write_concern, cascade, cascade_kwargs, _refs,
                            save_condition, signal_kwargs, **kwargs)

    def to_dict(self) -> Dict:
        data = {
            'id': str(self.id),
            'fingerprint': self.fingerprint,
            'cls': self.__class__.__name__
        }
        return data
