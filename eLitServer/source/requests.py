from typing import Dict
from database_classes import *
import time
import random
import pymongo.errors as mongoerr
import numpy as np


def connect():
    me.connect('eLit', host='localhost', port=27017)


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
        users = User.objects(user_id=user_data['user_id'])
        if users is None or len(users) == 0:
            user = User(data_dict=user_data)
            user.save()
        else:
            for user in users:
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


def on_insert_ingredient_request(data: Dict) -> Dict:
    connect()
    name = data['name']
    grade = data['grade']
    image = data['image']
    description = data['ingredient_description']
    payload = {'request': 'insert_ingredient'}
    try:
        Ingredient(name=name, grade=int(grade), image=image, ingredient_description=description).save()
        payload['status_code'] = 200
        return payload
    except mongoerr.ServerSelectionTimeoutError:
        payload['status_code'] = 500
        return payload


def on_fetch_ingredients_request(data: Dict) -> Dict:
    connect()
    print('Fetching ingredients..')
    payload = {'request': 'fetch_ingredients'}
    try:
        ingredients = Ingredient.objects()
        if len(ingredients) > 0:
            ingredients[0].save()
        data_dict = [ingredient.to_dict() for ingredient in ingredients]
        payload['data'] = data_dict
        payload['status_code'] = 200
        return payload
    except mongoerr.ServerSelectionTimeoutError:
        payload['status_code'] = 500
        return payload


def on_rating_request(data: Dict) -> Dict:
    payload = {
        'request': 'rating',
        'status_code': 200
    }
    if False:
        connect()
        drink_id = data['drink_id']
        reviews = Review.objects(for_drink__id=drink_id)
        ratings = [x.rating for x in reviews]
        rating = np.mean(ratings) if len(ratings) > 0 else 0
        payload['data'] = {'rating': str(rating)}
        return payload
    else:
        rating = random.random() * 5
        payload['data'] = {'rating': str(rating)}
        return payload


if __name__ == '__main__':
    pass
