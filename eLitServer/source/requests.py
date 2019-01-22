from typing import Dict
from database_classes import *


def connect():
    me.connect('eLit', host='localhost', port=4321)


# Utilities functions for handle the requests
def on_fetch_all_request(data: Dict) -> Dict:
    connect()
    drinks = Drink.objects
    payload = {
        'request': 'fetch_all',
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
        'data': [x.to_dict() for x in obj]
    }
    return payload


def on_user_sign_in_request(data: Dict) -> Dict:
    connect()
    user_data = data['data']
    user = User.objects(user_id=user_data['user_id'])
    if user is None:
        user = User(data_dict=user_data)
        user.save()

    return {
        'request': 'user_sign_in'
    }


if __name__ == '__main__':
    pass