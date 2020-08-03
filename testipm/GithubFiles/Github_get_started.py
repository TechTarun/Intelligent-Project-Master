from github import Github
import json

git = Github("3c0450a2f009731b56e0f6c3a683cea6f3cc6044")

all_repo = list()       #for repo
all_users = list()

def getAllRepo():
    for repo in git.get_user().get_repos():
        details = dict()
        details['reponame'] = repo.name
        all_repo.append(details)
    return all_repo

def getUser():
    user = git.get_user()
    uname = user.login
    return uname
