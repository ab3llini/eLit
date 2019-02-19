import logging
import random
from typing import Dict

import pymongo.errors as mongoerr
from mongoengine.queryset import DoesNotExist
from mongoengine.queryset.visitor import Q

from database_classes import *

logger = logging.getLogger('server_logger')

image_basepath = 'assets/'


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

    classes = DrinkObject.__subclasses__()
    changed = []
    print(f"[*] - ids: {list(data.keys())}")

    for c in classes:

        diff_finder = Q(id__in=list(data.keys())) & Q(fingerprint__not__in=list(data.values()))
        diff = [*c.objects(diff_finder)]

        changed += diff

    new = [*Ingredient.objects(id__not__in=list(data.keys())),
           *Drink.objects(id__not__in=list(data.keys())),
           *DrinkCategory.objects(id__not__in=list(data.keys()))]

    print("[*] The following items have changed:", changed)
    print(f"[*] The following items are new: {new}")

    payload = {
        'request': 'update_db',
        'status_code': 200,
        'data': [o.to_dict() for o in [*changed, *new]]

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

    payload = {
        'request': 'fetch_reviews'
    }

    try:
        reviews = Review.objects(for_drink=drink_id).order_by('timestamp')
        n_reviews = Review.objects(for_drink=drink_id).count()
    except mongoerr.ServerSelectionTimeoutError:
        payload['status_code'] = 500
        return payload

    data_list = []

    if next_index < n_reviews:

        reviews = reviews[next_index: next_index + 10]

        for i, review in enumerate(reviews):

            data_list.append({
                'author': review.written_by.name,
                'timestamp': review.timestamp.strftime('%-d %b \'%y'),
                'title': review.title,
                'rating': review.rating,
                'text' : review.text,
                'is_last': i + next_index == n_reviews - 1
            })

    payload['data'] = data_list
    payload['status_code'] = 200

    return payload


def on_fetch_review_request(data: Dict) -> Dict:
    drink_id = data['drink_id']
    user_id = data['from_user']
    payload = {'request': 'fetch_review'}
    try:
        user = User.objects(user_id=user_id).get()
        review = Review.objects(Q(for_drink=drink_id) & Q(written_by=user.id)).get()
        payload['data'] = review.to_dict()
        payload['status_code'] = 200
        return payload
    except DoesNotExist:
        payload['status_code'] = 500
        return payload


def on_add_review_request(data: Dict) -> Dict:
    payload = {'request': 'add_review'}
    user_id = data['user_id']
    title = data['title']
    text = data['content']
    rating = float(data['rating'])
    drink_id = data['drink_id']
    try:
        drink = Drink.objects(id=drink_id).get()
        user = User.objects(user_id=user_id).get()
    except DoesNotExist:
        payload['status_code'] = 500
        payload['message'] = f'unable to find drink {drink_id} or user with id {user_id}'
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


def on_insert_category_request(data: Dict) -> Dict:
    connect()
    name = data['name']
    image = image_basepath + data['image']
    payload = {
        'request': 'insert_category'
    }
    try:
        _new = DrinkCategory(name=name, image=image)
        _new.save()
        payload['status_code'] = 200
        return payload
    except mongoerr.ServerSelectionTimeoutError:
        payload['status_code'] = 500
        return payload
    except mongoerr.DuplicateKeyError:
        payload['status_code'] = 500
        payload['message'] = f"Duplicate key {name}"
        return payload


def on_insert_ingredient_request(data: Dict) -> Dict:
    connect()
    name = data['name']
    grade = data['grade']
    image = image_basepath + data['image']
    description = data['ingredient_description']
    payload = {'request': 'insert_ingredient'}
    try:
        Ingredient(name=name, grade=float(grade), image=image, ingredient_description=description).save()
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
    category_name = data['category']
    # Category
    try:
        category = DrinkCategory.objects(name=category_name).get()
    except DoesNotExist:
        payload['status_code'] = 500
        payload['message'] = f"invalid category {category_name}"
        return payload
    steps_obj = []
    try:
        for step in recipe:

            components_obj = []
            components = step['components']

            for component in components:
                ingredient_name = component['ingredient']
                try:
                    ingredient = Ingredient.objects(name=ingredient_name).get()
                except DoesNotExist:
                    payload['status_code'] = 500
                    payload['message'] = f'invalid ingredient {ingredient_name}'
                    return payload

                cmp = DrinkComponent(ingredient, float(component['quantity']), component['unit'])
                components_obj.append(cmp)

            step = RecipeStep(step['description'], components_obj)
            steps_obj.append(step)

        recipe_obj = Recipe(steps_obj)
        drink = Drink(data['name'], float(data['grade']), image_basepath + data['image'], data['description'],
                      recipe=recipe_obj, category=category)
        drink.save()
    except mongoerr.ServerSelectionTimeoutError:
        payload['status_code'] = 500
        return payload

    except Exception as e:
        print("This is bad:", e)
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


def on_fetch_categories_request(data: Dict) -> Dict:
    connect()
    payload = {'request': 'fetch_categories'}
    try:
        categories = DrinkCategory.objects()
        data_dict = [category.to_dict() for category in categories]
        payload['data'] = data_dict
        payload['status_code'] = 200
        return payload
    except mongoerr.ServerSelectionTimeoutError:
        payload['status_code'] = 500
        return payload


def on_fetch_drinks_request(data: Dict) -> Dict:
    connect()
    logger.debug('Fetching drinks..')
    payload = {'request': 'fetch_drinks'}
    try:
        drinks = Drink.objects()
        data_dict = []
        for d in drinks:
            dict = d.to_dict()
            dict['steps'] = len(d.recipe.steps)
            data_dict.append(dict)
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
    connect()
    drink_id = data['drink_id']
    rating = Review.objects(for_drink=drink_id).average('rating')
    payload['data'] = {'rating': str(rating)}
    return payload


if __name__ == '__main__':
    pass
