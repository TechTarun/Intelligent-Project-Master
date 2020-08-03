import requests
from requests.auth import HTTPBasicAuth
import json
import Jira_get_started as jira_start
from MailFiles import send_mail
from github import Github

class Confluence:

    base_url = ""
    url = ""
    mail_body = {}

    def __init__(self, base_url, user_email, access_token):
        self.base_url = base_url
        self.auth = HTTPBasicAuth(user_email, access_token)

    def getAllSpaces(self, **args):
        url = "/wiki/rest/api/space"
        api = self.base_url+url
        headers = {
            "Accept": "application/json"
        }
        response = requests.request(
            'GET',
            api,
            auth=self.auth,
            headers=headers
        )
        print(response.text)

    def createSpace(self, **args):
        spacename = args["space name"]
        spacekey = spacename[:3].upper()
        url = "/wiki/rest/api/space"
        api = self.base_url+url
        headers = {
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        }
        payload = json.dumps({
            "key" : spacekey,
            "name" : spacename
        })
        response = requests.request(
            'POST',
            api,
            auth=self.auth,
            data=payload,
            headers=headers
        )
        print(response.text)

    def createPrivateSpace(self, **args):
        spacename = args["space name"]
        spacekey = spacename[:3].upper()
        url = "/wiki/rest/api/space/_private"
        api = self.base_url+url
        headers = {
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        }
        payload = json.dumps({
            "key" : spacekey,
            "name" : spacename
        })
        response = requests.request(
            'POST',
            api,
            auth=self.auth,
            data=payload,
            headers=headers
        )
        print(response.text)

    def getSpace(self, **args):
        spacekey = args["space key"]
        url = "/wiki/rest/api/space/"+spacekey
        api = self.base_url+url
        headers = {
            "Accept" : "application/json"
        }
        response = requests.request(
            'GET',
            api,
            auth=self.auth,
            headers=headers
        )
        print(response.text)

    def updateSpaceDescription(self, **args):
        spacekey = args["space key"]
        # spacename = all_spaces[spacekey]["name"]
        spacename = args["space name"]
        description = args["description"]
        url = "/wiki/rest/api/space/"+spacekey
        api = self.base_url+url
        headers = {
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        }
        payload = json.dumps({
            "name" : spacename,
            "description" : {
                "plain" : {
                    "value" : description
                }
            }
        })
        response = requests.request(
            'PUT', 
            api,
            auth=self.auth,
            headers=headers,
            data=payload
        )
        print(response.text)

    def getSpaceContent(self, **args):
        spacekey = args["space key"]
        url = "/wiki/rest/api/content"
        api = self.base_url+url
        headers = {
            "Accpet" : "application/json"
        }
        # query = {
        #     "spaceKey" = spacekey
        # }
        response = requests.request(
            "GET",
            api,
            auth=self.auth,
            headers=headers,
            # params=query
        )
        print(response.text)

    def createContent(self, **args):
        spacekey = args["space key"]
        title = args["title"]
        description = args["description"]
        url = "/wiki/rest/api/content"
        api = self.base_url+url
        headers = {
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        }
        payload = json.dumps({
            "title" : title,
            "space" : {
                "key" : spacekey
            },
            "type" : "page",
            "status" : "draft",
            "body" : {
                "export_view" : {
                    "value" : description,
                    "representation" : "view"
                }
            }
        })
        response = requests.request(
            "POST",
            api,
            headers=headers,
            data=payload,
            auth=self.auth
        )
        print(response.text)

    def searchConfluenceByTitle(self, **args):
        title = args["project name"]
        cql = "title ~ '{0}'".format(title)
        url = "/wiki/rest/api/search"
        api = self.base_url+url
        headers = {
            "Accept" : "application/json"
        }
        query = {
            "cql" : cql
        }
        response = requests.request(
            "GET",
            api,
            headers=headers,
            params=query,
            auth=self.auth
        )
        # print(response)
        if response.status_code != 200:
            self.output = "Project not found in the workshape or dont have required permissions"
        else:
            response = json.loads(response.text)
            self.output = "Here are the project details\nShort Description : {excerpt}".format(excerpt=response["results"][0]["excerpt"])
            # print(self.output)
            return [self.output, response["size"], response]

    def searchConfluenceByQuery(self, **args):
        text = args["query"]
        space_key = args["space key"]
        cql = "text ~ '{0}' and space = {1}".format(text, space_key)
        url = "/wiki/rest/api/search"
        api = self.base_url+url
        headers = {
            "Accept" : "application/json"
        }
        query = {
            "cql" : cql
        }
        response = requests.request(
            "GET",
            api,
            headers=headers,
            params=query,
            auth=self.auth
        )
        # print(response)
        if response.status_code != 200:
            self.output = "Project not found in the workshape or dont have required permissions"
        else:
            response = json.loads(response.text)
            if response["size"] == 0:
                self.output = "No results found! Try with another query"
            else:
                self.output = "Here are the some related details : \n{excerpt}".format(excerpt=response["results"][0]["excerpt"])
            # print(self.output)
            return [self.output, response["size"], response]

    def searchInGithub(self, **args):
        git = Github(args["GITHUB_ACCESS_TOKEN"])
        repo_name = args["repo name"]
        file_name = 'README.md'
        repo = git.get_user().get_repo(repo_name)
        contents = repo.get_contents(file_name)
        print(contents)