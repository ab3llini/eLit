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


def create_cocktail():
    ing1 = Ingredient(name='ing1', grade=1, ingredient_description='Ingrediente 1')
    ing2 = Ingredient(name='ing2', grade=2, ingredient_description='Ingrediente 2')
    ing3 = Ingredient(name='ing3', grade=3, ingredient_description='Ingrediente 3')
    component1 = DrinkComponent(ingredient=ing1, qty=2, unit=PART)
    component2 = DrinkComponent(ingredient=ing2, qty=1, unit=PART)
    component3 = DrinkComponent(ingredient=ing3, qty=5, unit=PART)
    step1 = RecipeStep(description='Mix component1 with component2', components=[component1, component2])
    step2 = RecipeStep(description='Add component3', components=[component3])
    recipe = Recipe(steps=[step1, step2])
    drink = Drink(name='Drink1', degree=20, image='http://test.me', description='Best drink ever', recipe=recipe)
    drink.save()


if __name__ == '__main__':
    # dbm = DBManager('192.168.178.37', 27017)
    me.connect('eLit', host='localhost', port=4444)
    # _ = Test(title='Luca').save()
    # _ = Test(title='Piero').save()
    # create_cocktail()
    obj = [*Drink.objects, *DrinkComponent.objects, *Ingredient.objects, *Recipe.objects, *RecipeStep.objects]
    for o in obj:
        print(o.to_json())
    # for drink in drinks:
        # drink.delete()
        # print(str(drink.id))
    print('*'*300)
    obj = Review.objects(for_drink='5c61c88cc7170d4d4fc70d4d').get()
    print(obj.to_dict())

    print(Drink.objects(name='vsbvsb').get().category.name)
