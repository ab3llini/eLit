import mongoengine as me


class DBObject(me.Document):

    meta = {'allow_inheritance': True}

    def __init__(self, *args, **values):
        super().__init__(*args, **values)
