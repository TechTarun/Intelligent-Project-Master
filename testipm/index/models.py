from django.db import models

class User(models.Model):
    user_name= models.CharField(max_length=50)
    user_password= models.CharField(max_length=50)
    def _str_(self):
      return self.user_name+'-'+self.user_password



