import mongoengine as me
from database_classes.db_object import DBObject
from database_classes.drink_component import DrinkComponent
from typing import List, Dict
from database_classes.drink_object import DrinkObject


class RecipeStep(DrinkObject):
    step_description = me.StringField()
    components = me.ListField(me.ReferenceField(DrinkComponent))

    def __init__(self, step_description: str = None, components: List[DrinkComponent] = None, *args, **values):
        super().__init__(*args, **values)
        self.step_description = step_description or ''
        self.components = components if len(components) > 0 else None

    def save(self, force_insert=False, validate=True, clean=True, write_concern=None, cascade=None, cascade_kwargs=None,
             _refs=None, save_condition=None, signal_kwargs=None, **kwargs):
        for component in self.components:
            component.save()
        return super().save(force_insert, validate, clean, write_concern, cascade, cascade_kwargs, _refs,
                            save_condition, signal_kwargs, **kwargs)

    def add_component(self, component: DrinkComponent):
        self.components.append(component)

    def to_dict(self) -> Dict:
        data = super().to_dict()
        data['step_description'] = self.step_description
        data['components'] = [x.to_dict() for x in self.components]
        return data

