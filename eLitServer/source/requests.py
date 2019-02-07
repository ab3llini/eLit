from typing import Dict
from database_classes import *
import time
import random
import pymongo.errors as mongoerr
import numpy as np
import logging
import datetime
from mongoengine.queryset import DoesNotExist
from mongoengine.queryset.visitor import Q

logger = logging.getLogger('server_logger')


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
    payload = {'request': 'user_sign_in'}
    user_data = data
    try:
        User.objects(user_id=user_data['user_id']).get()
    except DoesNotExist:
        logger.info(f'sign in new user with email {user_data["email"]}')
        User(data_dict=user_data).save()
        payload['status_code'] = 200
    except mongoerr.ServerSelectionTimeoutError:
        payload['status_code'] = 500
    payload['status_code'] = 200
    return payload


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


def on_add_review_request(data: Dict) -> Dict:
    payload = {'request': 'add_review'}
    user_id = data['user_id']
    title = data['title']
    text = data['text']
    rating = float(data['rating'])
    drink_name = data['drink_name']
    try:
        drink = Drink.objects(name=drink_name).get()
        user = User.objects(user_id=user_id).get()
    except DoesNotExist:
        payload['status_code'] = 500
        payload['message'] = f'unable to find drink {drink_name} or user with id {user_id}'
        return payload

    current_reviews = Review.objects(Q(written_by=user) & Q(for_drink=drink))
    if len(current_reviews) >= 1:
        for review in current_reviews:
            review.delete()

    try:
        Review(title, text, rating, drink, user).save()
    except me.ValidationError:
        payload['status_code'] = 200
        payload['message'] = 'invalid attributes'
        return payload
    payload['status_code'] = 200
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
    except mongoerr.DuplicateKeyError:
        payload['status_code'] = 500
        payload['message'] = 'Found duplicate key'


def on_insert_drink_request(data: Dict) -> Dict:
    connect()
    logger.debug(data)
    payload = {'request': 'insert_drink'}
    recipe = data['recipe']
    steps = recipe['steps']
    steps_obj = []
    try:
        for step in steps:
            components_obj = []
            components = step['components']

            for component in components:
                ingredient_name = component['ingredient']['name']
                try:
                    ingredient = Ingredient.objects(name=ingredient_name).get()
                except DoesNotExist:
                    payload['status_code'] = 500
                    payload['message'] = f'invalid ingredient {ingredient_name}'
                    return payload

                component = DrinkComponent(ingredient, component['qty'], component['unit'])
                components_obj.append(component)

            step = RecipeStep(step['step_description'], components_obj)
            steps_obj.append(step)

        recipe_obj = Recipe(steps_obj)
        drink = Drink(data['name'], int(data['degree']), data['image'], data['description'], recipe=recipe_obj)
        drink.save()
    except (mongoerr.ServerSelectionTimeoutError, mongoerr.DuplicateKeyError):
        payload['status_code'] = 500
        return payload

    # All goes fine
    payload['status_code'] = 200
    return payload


def on_fetch_ingredients_request(data: Dict) -> Dict:
    connect()
    logger.debug('Fetching ingredients..')
    payload = {'request': 'fetch_ingredients'}
    try:
        ingredients = Ingredient.objects()
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
        rating = Review.objects(for_drink__id=drink_id).average('rating')
        payload['data'] = {'rating': str(rating)}
        return payload
    else:
        rating = random.random() * 5
        payload['data'] = {'rating': str(rating)}
        return payload


if __name__ == '__main__':
    pass
