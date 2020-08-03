import imaplib
import email
import mailparser
import re
from datetime import datetime

"""
show me the last email from sender {sender name} (single mail),
find me the mail on subject {subject}(single mail/multi mail),
show me mails from sender {sender name}(multi mail),
show me email from sender {sender} on subject {subject}
"""

class EmailManager:

    def remove_html_tags(self, text):
        """Remove html tags from a string"""
        clean = re.compile('<.*?>')
        return re.sub(clean, '', text)

    def searchMailBySenderSubject(self, **args):
        """This function will search for a particular mail as per the given sender and subject"""
        output = ""
        attach_list = list()
        FROM_EMAIL = args["username"]
        FROM_PWD = args["password"]
        sender = args["sender name"]
        subject = args["subject"]
        SMTP_SERVER = "imap.gmail.com"
        SMTP_PORT = 993
        mail = imaplib.IMAP4_SSL(SMTP_SERVER)
        try:
            mail.login(FROM_EMAIL, FROM_PWD)
        except:
            return ["Authentication failed, contact admin", []]
        mail.select('inbox')
        type, data = mail.search(None, '(FROM "{sender}" SUBJECT "{subject}")'.format(sender=sender, subject=subject))
        # search and return uids instead
        mail_count = len(data[0].split())  # data[0] is a space separate string
        if (mail_count == 0):  # if there are no mails found, i==0
            return ["No mails!!", attach_list]
        latest_email_uid = data[0].split()[-1]  # unique ids wrt label selected
        result, email_data = mail.fetch(latest_email_uid, '(RFC822)')
        # fetch the email body (RFC822) for the given ID
        raw_email = email_data[0][1]
        # continue inside the same for loop as above
        raw_email_string = raw_email.decode('utf-8')
        email = mailparser.parse_from_string(raw_email_string)
        attach = email.attachments
        if (len(attach) > 0):
            for i in range(len(attach)):
                attach_list.extend(attach[i]['filename'])
        output = "Email from " + email.from_[0][1] + " dated " + str(email.date) + " on the subject " + email.subject + " is " + self.remove_html_tags(str(email.text_html))
        return [output, attach_list]
        mail.close()
        mail.logout()

    def searchMailBySender(self, **args):
        """This function will search for a particular mail as per the given sender and subject"""
        try:
            output = ""
            attach_list = list()
            FROM_EMAIL = args["username"]
            FROM_PWD = args["password"]
            sender = args["sender name"]
            SMTP_SERVER = "imap.gmail.com"
            SMTP_PORT = 993
            mail = imaplib.IMAP4_SSL(SMTP_SERVER)
            try:
                mail.login(FROM_EMAIL, FROM_PWD)
            except:
                return ["Authentication failed, contact admin", []]
            mail.select('inbox')
            type, data = mail.search(None, '(FROM "{sender}")'.format(sender=sender))
            # search and return uids instead
            mail_count = len(data[0].split())  # data[0] is a space separate string
            if (mail_count == 0):  # if there are no mails found, i==0
                return ["No mails!!", attach_list]
            latest_email_uid = data[0].split()[-1]  # unique ids wrt label selected
            result, email_data = mail.fetch(latest_email_uid, '(RFC822)')
            # fetch the email body (RFC822) for the given ID
            raw_email = email_data[0][1]
            # continue inside the same for loop as above
            raw_email_string = raw_email.decode('utf-8')
            email = mailparser.parse_from_string(raw_email_string)
            attach = email.attachments
            if (len(attach) > 0):
                for i in range(len(attach)):
                    attach_list.extend(attach[i]['filename'])
            output = "Email from " + email.from_[0][1] + " dated " + str(email.date) + " on the subject " + email.subject + " is " + self.remove_html_tags(str(email.text_html))
            return [output, attach_list]
            mail.close()
            mail.logout()
        except:
            return ["Some error occured, try again", []]

    def searchMailBySubject(self, **args):
        """This function will search for a particular mail as per the given sender and subject"""
        try:
            output = ""
            attach_list = list()
            mail_list = list()
            FROM_EMAIL = args["username"]
            FROM_PWD = args["password"]
            subject = args["subject"]
            SMTP_SERVER = "imap.gmail.com"
            SMTP_PORT = 993
            mail = imaplib.IMAP4_SSL(SMTP_SERVER)
            try:
                mail.login(FROM_EMAIL, FROM_PWD)
            except:
                return ["Authentication failed, contact admin", []]
            mail.select('inbox')
            type, data = mail.search(None, '(SUBJECT "{subject}")'.format(subject=subject))
            # search and return uids instead
            mail_count = len(data[0].split())  # data[0] is a space separate string
            if (mail_count == 0):  # if there are no mails found, i==0
                return ["No mails!!", attach_list]
            latest_email_uid = data[0].split()[-1]  # unique ids wrt label selected
            result, email_data = mail.fetch(latest_email_uid, '(RFC822)')
            # fetch the email body (RFC822) for the given ID
            raw_email = email_data[0][1]
            # continue inside the same for loop as above
            raw_email_string = raw_email.decode('utf-8')
            email = mailparser.parse_from_string(raw_email_string)
            attach = email.attachments
            if (len(attach) > 0):
                for i in range(len(attach)):
                    attach_list.extend(attach[i]['filename'])
            output = "Email from " + email.from_[0][1] + " dated " + str(email.date) + " on the subject " + email.subject + " is " + self.remove_html_tags(str(email.text_html))
            return [output, attach_list]
            mail.close()
            mail.logout()
        except:
            return ["Some error occured, try again!", []]

    def sendMail(self, **args):
        port = 465  # For SSL
        smtp_server = "smtp.gmail.com"
        sender_email = args["username"]  # Enter your address
        password = args["password"]
        receiver_email = args["receiver email"]  # Enter receiver address
        subject = args["subject"]
        message = args["message"]
        mail = """
        Subject : IPM query details

        {message}
        """.format(message=message)
        context = ssl.create_default_context()
        with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
            server.login(sender_email, password)
            server.sendmail(sender_email, receiver_email, mail)
        return "sent mail successfully!!"