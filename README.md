# heroku-ansible

Clone this repo: 

```git clone https://github.com/andela-oolarewaju/heroku-ansible.git ```

Then:

```$ cd heroku-ansible```

Create a ```vars.yml``` file and put the following credentials and variables like:

```
heroku_email: ""
heroku_password: ""
app_dir: "" 
repo_name: ""
app_name: ""
commit_message: ""
db_key: ""
db_uri: ""
secret_key: ""
secret_value: ""

```

This file **SHOULD NOT** be public

Fill in your machine's public ip address and the path to your private key in the ```inventory.ini``` file

**RUN** `ansible-playbook -i inventory.ini playbook.yml`

**TO TEST**
cd into features/install.steps.rb

Fill in the variable values in the install.steps.rb file. example:
```
PATHTOPRIVATEKEY = "/path/to/private/key"
PUBDNS = "" #example ubuntu@ec2-11-22-33-44.compute-1.amazonaws.com
APPDIR = "/path/to/app/directory"
EMAIL = "me@example.com" #same heroku_email as in vars.yml
APP_NAME = "" #app name
ANSIBLE_HOME = '/root'
APP_URL = "" #application url
```

**Then RUN** cucumber featuers/install.feature