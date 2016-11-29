"""
3 useful tests that cover ``ModelSerializer`` behavior are:

- ``test_deserialize_all_fields``
- ``test_deserialize_required_fields`` (optional)
- ``test_serialize_all_fields``

For code that implements create functionality, implement the
``deserialize_all_fields`` and ``deserialize_required_fields`` tests. For code
that only implements read functionality, implement ``serialize_all_fields``
tests.
"""
import pytest

from ..serializers import DogSerializer
from ..models import Dog


@pytest.mark.django_db
def test_deserialize_required_fields():
    """
    Test the required fields of the deserialization. Validate the
    ``serializer.save()`` deserializes and creates a new object in the
    datastore with the required fields.

    - Initialize ``serializer`` with empty data set
    - Assert ``serializer.is_valid()`` is ``False``
    - Assert ``len(serializer.errors)`` reflects the number of required fields

    - Initialize ``serializer`` with only required fields
    - Assert ``serializer.is_valid()`` is ``True``

    - Deserialize with ``serializer.save()``
    - Assert one new object is created in the datastore
    - Assert required fields are on new object in the datastore
    """
    data = {}
    serializer = DogSerializer(data=data)
    assert not serializer.is_valid()
    assert len(serializer.errors) == 1

    data = {'name': 'bruce'}
    serializer = DogSerializer(data=data)
    assert serializer.is_valid()

    serializer.save()
    assert Dog.objects.count() == 1

    dog = Dog.objects.first()
    assert dog.name == 'bruce'


@pytest.mark.django_db
def test_deserialize_all_fields():
    """
    Test all fields of the deserialization. Validate the
    ``serializer.save()`` deserializes and creates a new object in the
    datastore with all fields.

    - Initialize ``serializer`` with all fields
    - Assert ``serializer.is_valid()`` is ``True``

    - Deserialize with ``serializer.save()``
    - Assert one new object is created in the datastore
    - Assert required fields are on new object in the datastore
    """
    data = {'name': 'bruce', 'breed': 'bulldog'}
    serializer = DogSerializer(data=data)
    assert serializer.is_valid()

    serializer.save()
    assert Dog.objects.count() == 1

    dog = Dog.objects.first()
    assert dog.name == 'bruce'
    assert dog.breed == 'bulldog'


@pytest.mark.django_db
def test_serialize_all_fields():
    """
    Test all fields of the serialization. Validate the
    ``serializer.data`` contains all fields.

    - Create instance of object
    - Initialize serializer with object instance
    - Assert all fields are ``serializer.data``
    """
    dog = Dog.objects.create(name='bruce', breed='bulldog')
    serializer = DogSerializer(dog)
    assert serializer.data['name'] == 'bruce'
    assert serializer.data['breed'] == 'bulldog'
