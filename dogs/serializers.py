from rest_framework import serializers
from .models import Dog


class DogSerializer(serializers.ModelSerializer):
    """
    Example Serializer
    """
    class Meta:
        model = Dog
        fields = ['name', 'breed']
