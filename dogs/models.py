from django.db import models


class Dog(models.Model):
    """
    Example Model
    """
    name = models.CharField(max_length=256)
    breed = models.CharField(max_length=256, blank=True)
