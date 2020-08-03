from ConfluenceFiles.Confluence_api import Confluence
from JiraFiles.Jira_api import Jira
from GithubFiles.Github_api import Git
import config_file as config

# args = {
#     "space name" : "ipm",
#     "space key" : "IPM",
#     "project name" : "project name 2",
#     "description" : "this is the new page created by IPM",
#     "query" : "Intelligent project master",
#     "repo name" : "IPM-MainRepo",
#     "project key" : "IPM"
# }
class Search:
    c = Confluence(config.CONFLUENCE_BASE_URL, config.CONFLUENCE_USER_EMAIL, config.CONFLUENCE_ACCESS_TOKEN)
    jira = Jira(config.JIRA_BASE_URL, config.JIRA_USER_EMAIL, config.JIRA_ACCESS_TOKEN)
    github = Git(config.GITHUB_ACCESS_TOKEN)
    
    def getDetails(self, **args):
        #get complete voice output if required
        allProjects = self.jira.getAllProjects()
        output1, ctr, response = self.c.searchConfluenceByTitle(**args)
        args["repo name"] = args["project name"]
        output2 = self.github.listOfOpenIssues(**args)
        if output2 == "No such repo found":
            output2 = ""
        if args["project name"] not in allProjects:
            output3 = ""
        else:
            project_key = allProjects[args["project name"]]["project key"]
            args["project key"] = project_key
            output3 = self.jira.getSpecificProjectDetails(**args)
        output = output1 + '\n' + output2 + '\n' + output3
        print(output)
        print("Various pages related to the search are ")
        if ctr > 0:
            for num in range(ctr):
                print("https://ipm-demo.atlassian.net/wiki"+response["results"][num]["url"])
        return output

    def getInstallation(self, **args):
        args["query"] = "install"
        allProjects = self.jira.getAllProjects()
        if args["project name"] not in allProjects.keys():
            print("Project doesnt exist")
            return "Project doesnt exist"
        args["space key"] = allProjects[args["project name"]]["project key"]
        output1, ctr, response = self.c.searchConfluenceByQuery(**args)
        print(output1)
        if ctr > 0:
            for num in range(ctr):
                print("https://ipm-demo.atlassian.net/wiki"+response["results"][num]["url"])
        return output1

    def getProgress(self, **args):
        args["query"] = "progress"
        allProjects = self.jira.getAllProjects()
        args["repo name"] = args["project name"]
        print(allProjects)
        if args["project name"] not in allProjects.keys():
            print("Project doesnt exist")
            return "Project doesnt exist"
        # args["space key"] = allProjects[args["project name"]]["project key"]
        # output3, size, response = self.c.searchConfluenceByQuery(**args)
        # if output3 == "No results found! Try with another query":
        #     output3 = ""
        args["project key"] = allProjects[args["project name"]]["project key"]
        to_do, in_progress, done = self.jira.getAllIssuesWithPriority(**args)
        output1 = "Progress report of the Project is as : '\n' Stories with their status and priority are '\n' Stories in to do : {to_do} '\n' Stories in progress : {in_progress} \n Stories done : {done}.\n".format(to_do=to_do, in_progress=in_progress, done=done)
        print(output1)
        output2 = self.github.listOfOpenIssues(**args)
        if output2 == "No such repo found":
            output2 = ""
        output = output1 + "\n" + output2
        return output

    def getFeatureProgress(self, **args):
        pass


# s = Search()
# args = {
#     "project name" : "intelligent project master"
# }
# s.getDetails(**args)