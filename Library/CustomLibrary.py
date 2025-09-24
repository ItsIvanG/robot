import requests, random, string

class CustomLibrary():

    def get_random_users(self):
        response = requests.get("https://jsonplaceholder.typicode.com/users",verify=False)
        users = response.json()
        for i in users:
            i["birthday"]=self.get_random_birthday()
            i["password"]=self.generate_password()
            i["address"]["stateAbbr"]=str(i["address"]["street"][0]+str(i["address"]["suite"][0]+str(i["address"]["city"][0])))
        print(response.json())
        return users
    
    def get_random_birthday(self):
        return str(random.randint(1,12)).zfill(2) +str(random.randint(1,28)).zfill(2)+str(random.randint(1999,2006))
    
    def generate_password(self,length=8):
        chars = string.ascii_letters+string.digits+"!@#$%"
        return '' .join(random.choice(chars) for _ in range(length))
