# This code sample uses the 'requests' library:
# http://docs.python-requests.org
import requests
from requests.auth import HTTPBasicAuth
import json

base_url = "https://abesit-ipm.atlassian.net"
auth = HTTPBasicAuth("tarunagarwal27.99@gmail.com", "tl4F0d5aapRqiR7BfGkiBBDD")
all_projects = list()
all_users = list()

def getAllProjects():
  url = "/rest/api/2/project/search"
  api = base_url+url
  headers = {
     "Accept": "application/json"
  }
  response = requests.request(
     "GET",
     api,
     headers=headers,
     auth=auth
  )
  result = json.loads(response.text)
  result = result['values']
  total_projects = len(result)
  for ctr in range(total_projects):
    details = dict()
    details['projectId'] = result[ctr]['id']
    details['projectKey'] = result[ctr]['key']
    details['projectName'] = result[ctr]['name']
    all_projects.append(details)
  return all_projects

def getAllUsers():
  url = '/rest/api/2/users/search'
  api = base_url+url
  headers = {
    "Accept": "application/json"
  }
  response = requests.request(
    "GET",
    api,
    headers=headers,
    auth=auth
    )
  result = json.loads(response.text)
  total_users = len(result)
  for ctr in range(total_users):
    details = dict()
    if result[ctr]['accountType'] == 'atlassian':
      details['accountId'] = result[ctr]['accountId']
      details['emailAddress'] = result[ctr]['emailAddress']
      all_users.append(details)
  return all_users

getAllProjects()
getAllUsers()
# print(all_projects)
# print(all_users)
# getSpecificProject()