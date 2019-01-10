import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.drink_component import DrinkComponent
from typing import List


class RecipeStep(DBObject):
    step_description = me.StringField()
    components = me.ListField(DrinkComponent)

    def __init__(self, description: str = None, components: List[DrinkComponent] = None, *args, **values):
        super().__init__(*args, **values)
        self.step_description = description or ''
        self.components_list = components or List[DrinkComponent]

    def save(self, force_insert=False, validate=True, clean=True, write_concern=None, cascade=None, cascade_kwargs=None,
             _refs=None, save_condition=None, signal_kwargs=None, **kwargs):

        self.components = self.components_list
        return super().save(force_insert, validate, clean, write_concern, cascade, cascade_kwargs, _refs,
                            save_condition, signal_kwargs, **kwargs)

    def add_component(self, component: DrinkComponent):
        self.components_list.append(component)
