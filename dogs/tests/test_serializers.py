"""
There must be at least two tests, ``test_serializer_required`` and
``test_serializer_all``
"""

from rest_framework import serializers
from rest_framework import fields


class DogSerializer(serializers.Serializer):
    """
    Example Serializer
    """
    name = fields.CharField()
    breed = fields.CharField(required=False)


def test_dog_serializer_required():
    """
    Example serializer required fields test

    - Initialize ``serializer`` with empty data set
    - Assert ``serializer.is_valid()`` is ``False``
    - Assert ``serializer.errors reflects`` the number of required fields

    - Initialize serializer with only required
    - Assert serializer is True
    """
    serializer = DogSerializer(data={})
    assert not serializer.is_valid()
    assert len(serializer.errors) == 1

    data = {'name': 'bruce'}
    serializer = DogSerializer(data=data)
    assert serializer.is_valid()


def test_dog_serializer_all():
    """
    Example serializer all fields test

    - Initialize ``serializer`` with empty data set
    - Assert ``serializer.is_valid()`` is ``False``
    - Assert ``serializer.errors reflects`` the number of required fields
    """
    data = {'name': 'bruce', 'breed': 'bulldog'}
    serializer = DogSerializer(data=data)
    assert serializer.is_valid()
    assert serializer.data['name'] == 'bruce'
    assert serializer.data['breed'] == 'bulldog'
