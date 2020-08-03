from JiraFiles.Jira_api import Jira
from GithubFiles.Github_api import Git
from ConfluenceFiles.Confluence_api import Confluence
from search_api import Search
from MailFiles.email_manager import EmailManager
import config_file as config
from InputOutputFiles import Speech_to_Text as listen
from InputOutputFiles import Text_to_Speech as speak
from InputOutputFiles import Process_input as process
# from fuzzywuzzy import fuzz, process

jira = Jira(config.JIRA_BASE_URL, config.JIRA_USER_EMAIL, config.JIRA_ACCESS_TOKEN)
github = Git(config.GITHUB_ACCESS_TOKEN)
confluence = Confluence(config.CONFLUENCE_BASE_URL, config.CONFLUENCE_USER_EMAIL, config.CONFLUENCE_ACCESS_TOKEN)
search = Search()
emailmanager = EmailManager()
args = {}
#bitbucket object
#confluence object
jira_query_type_list = {'create':['create', 'make', 'build', 'built', 'form', 'generate', 'add'], 'delete':['delete', 'remove', 'clear', 'erase', 'trash', 'bin'], 'update':['update', 'modify', 'change', 'edit'], 'details':['get', 'fetch', 'show', 'detail', 'give'], 'transition':['to do', 'in progress', 'done', 'move', 'shift', 'transition'], 'assign':['assign']}
jira_domain_list = ['project', 'user', 'issue' , 'ticket']


github_query_type_list = {'create':['create', 'make', 'form', 'add'], 'close':['close', 'end'], 'delete':['delete', 'remove'], 'search':['search', 'find'], 'details':['show', 'detail', 'get', 'fetch', 'give']}
github_domain_list = ['repository', 'file', 'issue', 'commit']
github_subdomain_list = ['body', 'label', 'number', 'latest', 'good first issue', 'language', 'open']

confluence_query_type_list = {"search":["search", "details", "show", "find"]}
confluence_domain_list = []

search_query_type_list = {"details":["show", "detail", "get", "give", "find", "what", "how", "know"]}
search_domain_list = ["feature", "installation", "progress", "status", "project"]

query_type_list_dict = {"Jira":jira_query_type_list, "Github":github_query_type_list, "Confluence":confluence_query_type_list, "Search":search_query_type_list}
domain_list_dict = {"Jira":jira_domain_list, "Github":github_domain_list, "Confluence":confluence_domain_list, "Search":search_domain_list}
subdomain_list_dict = {"Github":github_subdomain_list}

mail_type_list = {"receive" : ['receive', 'find', 'show', 'get', 'fetch', 'bring', 'search'], "send" : ['send', 'create']}
mail_domain_list = ["sender", "subject"]

#################### query map #####################
QUERY_MAP = {
    "Github" : {
        "create" : {
            "repository" : {
                None : {"function":github.createNewRepo, "args":["repo name"]}
            },
            "file" : {
                None : {"function":github.createNewFileInRepo, "args":["repo name", "file name"]}
            },
            "issue" : {
                None : {"function":github.createNewIssue, "args":["repo name", "title"]},
                "body" : {"function":github.createIssueWithBody, "args":["repo name", "title", "body description"]},
                "label" : {"function":github.createIssueWithLabel, "args":["repo name", "title", "label"]}
            }
        },
        "close" : {
            "issue" : {
                "open" : {"function":github.closeAllOpenIssues, "args":["repo name"]},
                "number" : {"function":github.closeIssueByNumber, "args":["repo name", "issue number"]},
                None : {"function":github.closeIssueByNumber, "args":["repo name", "issue number"]}
            }
        },
        "delete" : {
            "file" : {
                None : {"function":github.deleteFileFromRepo, "args":["repo name", "file name"]}
            }
        },
        "search" : {
            "repository" : {
                "good first issue" : {"function":github.searchRepoWithGoodFirstIssue, "args":[]}
            },
            "repository" : {
                "language" : {"function":github.searchRepoByLanguage, "args":["language"]}
            }
        },
        "details" : {
            "issue" : {
                "open" : {"function":github.listOfOpenIssues, "args":["repo name"]},
                None : {"function":github.getIssueByNumber, "args":["repo name", "issue number"]}
            },
            "repository" : {
                "label" : {"function":github.getLabelsOfRepo, "args":["repo name"]},
                None : {"function":github.getAllContentsOfRepo, "args":["repo name"]}
            },
            "commit" : {
                "latest" : {"function":github.getLatestCommitDateOfUser, "args":[]}
            }
        }
    },

    "Jira" : {
        "create" : {
            "project" : {"function":jira.createNewProject, "args":["project name", "lead name"]},
            "issue" : {"function":jira.createIssue, "args":["summary", "project id", "issue type"]}
        },
        "delete" : {
            "project" : {"function":jira.deleteProject, "args":["project key"]},
            "issue" : {"function":jira.deleteIssue, "args":["issue key"]}
        },
        "update" : {
            "project" : {"function":jira.updateProject, "args":[]},
            "issue" : {"function":jira.updateIssue, "args":[]}
        },
        "details" : {
            "project" : {"function":jira.getSpecificProjectDetails, "args":["project key"]},
            "issue" : {"function":jira.getIssue, "args":["issue key"]}
        },
        "transition" : {
            "issue" : {"function":jira.issueTransition, "args":["issue key", "transition type"]}
        },
        "assign" : {
            "issue" : {"function":jira.assignIssue, "args":["issue key", "assignee name"]}
        }
    },

    "Bitbucket" : {
    },

    "Confluence" : {
        # "search" : {
        #     None : {"function":confluence.search, "args":["query"]}
        # }
    },

    "Search" : {
        "details" : {
            "project" : {"function":search.getDetails, "args":["project name"]},
            "installation" : {"function":search.getInstallation, "args":["project name"]},
            "progress" : {"function":search.getProgress, "args":["project name"]},
            "status" : {"function":search.getProgress, "args":["project name"]},
            "feature" : {"function":search.getFeatureProgress, "args":["project name"]}
        },
    }
} 
################### end query map ####################

################### mail map ######################
MAIL_MAP = {
    "receive" : {
        "sender" : {
            "subject" : {"function":emailmanager.searchMailBySenderSubject, "args":["sender name", "subject"]},
            None : {"function":emailmanager.searchMailBySender, "args":["sender name"]}
        },
        "subject" : {
            "sender" : {"function":emailmanager.searchMailBySenderSubject, "args":["sender name", "subject"]},
            None : {"function":emailmanager.searchMailBySubject, "args":["subject"]}
        }
    },
    "send" : {"function":emailmanager.sendMail, "args":["receiver email", "subject", "message"]}
}
#################### end mail map ####################

################### get query type ##################

def getQueryType(text, provider):
    query_type_list = query_type_list_dict[provider]
    query_type = ""
    """query type includes create, delete, assign, transition, update, details"""
    for key in query_type_list:
        value = query_type_list[key]
        for word in value:
            if word in text:
                query_type = key
                return query_type


################### end get query type ###############

################### get domain #####################

def getDomain(text, provider):
    """domain includes repository, project, user, issue"""
    domain_list = domain_list_dict[provider]
    domain = ""
    for word in domain_list:
        if word in text:
            domain = word
            if domain == 'ticket':
                domain = 'issue'
            return domain

################### end domain #####################

################### get sub domain #####################

def getSubDomain(text, provider):
    """domain includes repository, project, user, issue"""
    subdomain_list = subdomain_list_dict[provider]
    subdomain = None
    for word in subdomain_list:
        if word in text:
            subdomain = word
            return subdomain

################### end sub domain #####################

################# get arguments ################

def getArgs(text, provider, query_type, domain, subdomain=None):
    params = {}
    if provider not in ['Github', 'Bitbucket']:
        args = QUERY_MAP[provider][query_type][domain]["args"]
    else:
        args = QUERY_MAP[provider][query_type][domain][subdomain]["args"]
    if len(args) == 0:
        return params
    speak.say("Please give required details")
    for arg in args:
        speak.say("What is"+arg)
        params[arg] = listen.listenInput()
        if arg == "file name":
            params[arg] = process.createFileName(params[arg])
    print(params)
    return params

################# end get arguments ###############

################### get APi #################

def getAPIOutput(text, provider):
    text = process.extractRootwords(text)
    domain = getDomain(text, provider)
    query_type = getQueryType(text, provider)
    subdomain = None
    if provider in ['Github', 'Bitbucket']:
        subdomain = getSubDomain(text, provider)
    print(query_type)
    print(domain)
    print(subdomain)
    # try:
    args = getArgs(text, provider, query_type, domain, subdomain)
    if provider not in ['Github', 'Bitbucket']:
        output = QUERY_MAP[provider][query_type][domain]["function"](**args)
    else:
        output = QUERY_MAP[provider][query_type][domain][subdomain]["function"](**args)
    return output
    # except:
    #     return "Dont get the query properly. Try saying it again"
################### end get API ###############

################ get mail type ################
def getMailType(text):
    mail_type = ""
    for key in mail_type_list:
        value = mail_type_list[key]
        for word in value:
            if word in text:
                mail_type = key
                return mail_type
################ end get mail type ###############

############### get mail domain(in case of receive mail type) ####################
def getMailDomain(text):
    mail_domain = []
    for domain in mail_domain_list:
        if domain in text:
            mail_domain.append(domain)
    return mail_domain
############### end get mail domain ####################

############## get mail args ##################
def getMailArgs(text, mail_type, mail_domain):
    username = config.SENDER_MAIL_ID
    password = config.SENDER_MAIL_PASSWORD
    params = {"username":username, "password":password}
    if mail_domain == None:
        args = MAIL_MAP[mail_type]["args"]

    elif len(mail_domain) == 1:
        domain = mail_domain[0]
        subdomain = None
        args = MAIL_MAP[mail_type][domain][subdomain]["args"]

    elif len(mail_domain) == 2:
        domain = mail_domain[0]
        subdomain = mail_domain[1]
        args = MAIL_MAP[mail_type][domain][subdomain]["args"]
    speak.say("Please give required details")
    for arg in args:
        speak.say("What is"+arg)
        params[arg] = listen.listenInput()
    print(params)
    return params


############## end get mail args ###################

################# get mail output ################
def getMailOutput(text):
    text = process.extractRootwords(text)
    mail_type = getMailType(text)
    if mail_type == None:
        return "Query not clear, please try again!!"
    elif mail_type == "receive":
        mail_domain = getMailDomain(text)
        if len(mail_domain) == 0:
            return "Query not clear, please try again with keywords sender or subject!!"
        args = getMailArgs(text, mail_type, mail_domain)
        if len(mail_domain) == 1:
            domain = mail_domain[0]
            subdomain = None
        elif len(mail_domain) == 2:
            domain = mail_domain[0]
            subdomain = mail_domain[1]
        output = MAIL_MAP[mail_type][domain][subdomain]["function"](**args)
    elif mail_type == "send":
        args = getMailArgs(text, mail_type, None)
        output = MAIL_MAP[mail_type]["function"](**args)
    return output

def getToDoIssueNum():
    return 1

def getInProgressIssueNum():
    return 1

def getDoneIssueNum():
    return 0