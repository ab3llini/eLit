from database_classes.db_object import DBObject


class DrinkObject(DBObject):
    meta = {
        'allow_inheritance': True,
        'abstract': True
    }
