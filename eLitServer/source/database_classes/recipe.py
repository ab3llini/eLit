import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.recipe_step import RecipeStep
from typing import List, Dict


class Recipe(DBObject):
    steps = me.ListField(required=True)

    def __init__(self, steps: List[RecipeStep] = None, *args, **values):
        super().__init__(*args, **values)
        self.step_list = steps or List[RecipeStep]

    def save(self, force_insert=False, validate=True, clean=True, write_concern=None, cascade=None, cascade_kwargs=None,
             _refs=None, save_condition=None, signal_kwargs=None, **kwargs):
        self.steps = self.step_list
        return super().save(force_insert, validate, clean, write_concern, cascade, cascade_kwargs, _refs,
                            save_condition, signal_kwargs, **kwargs)

    def add_step(self, step: RecipeStep):
        self.step_list.append(step)

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['steps'] = [x.to_dict() for x in self.steps]
        return data


