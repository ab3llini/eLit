from typing import Dict
from database_classes import *
import time
import random
import pymongo.errors as mongoerr


def connect():
    me.connect('eLit', host='localhost', port=4321)


# Utilities functions for handle the requests
def on_fetch_all_request(data: Dict) -> Dict:
    connect()
    drinks = Drink.objects
    payload = {
        'request': 'fetch_all',
        'status_code': 200,
        'data': [x.to_dict() for x in drinks]
    }
    return payload


def on_update_request(data: Dict) -> Dict:
    connect()
    obj = [*Drink.objects(me.Q(id__in=list(data.keys())) & me.Q(fingerprint__not__in=list(data.values()))),
           *DrinkComponent.objects(me.Q(id__in=list(data.keys())) & me.Q(fingerprint__not__in=list(data.values()))),
           *Ingredient.objects(me.Q(id__in=list(data.keys())) & me.Q(fingerprint__not__in=list(data.values()))),
           *Recipe.objects(me.Q(id__in=list(data.keys())) & me.Q(fingerprint__not__in=list(data.values()))),
           *RecipeStep.objects(me.Q(id__in=list(data.keys())) & me.Q(fingerprint__not__in=list(data.values())))]
    payload = {
        'request': 'fetch_all',
        'status_code': 200,
        'data': [x.to_dict() for x in obj]
    }
    return payload


def on_user_sign_in_request(data: Dict) -> Dict:
    connect()
    user_data = data
    try:
        user = User.objects(user_id=user_data['user_id'])
        if user is None:
            user = User(data_dict=user_data)
            user.save()
        else:
            user.save()
        return {
            'request': 'user_sign_in',
            'status_code': 200
        }
    except mongoerr.ServerSelectionTimeoutError as error:
        return {
            'request': 'user_sign_in',
            'status_code': 500
        }


def on_fetch_reviews_request(data: Dict) -> Dict:
    drink_id = data['drink_id']
    next_index = data['from_index']

    reviews = [x + next_index for x in range(10)]

    data_list = []
    for x in reviews:
        last = next_index + x >= 39
        eval = random.random() * 5
        data_list.append({
            'title': str(x),
            'stars': str(eval),
            'is_last': str(last).lower()
        })

    payload = {
        'request': 'fetch_reviews',
        'data': data_list,
        'status_code': 200
    }
    return payload

if __name__ == '__main__':
    pass
