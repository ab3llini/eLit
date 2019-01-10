from pymongo import MongoClient
import mongoengine as me
from database_classes import *


class DBManager:
    def __init__(self, host: str, port: int):
        self.__host = host
        self.__port = port
        print('connecting...')
        self.__client = MongoClient(host=self.__host, port=self.__port)
        print('connected')
        self.__db = self.__client['eLit']
        print(self.__db.last_status())


if __name__ == '__main__':
    # dbm = DBManager('192.168.178.37', 27017)
    me.connect('eLit', host='192.168.178.37', port=27017)
    # _ = Test(title='Luca').save()
    # _ = Test(title='Piero').save()

    for d in DBObject.objects:
        print(type(d))
