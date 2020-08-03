from __future__ import absolute_import
import smtplib, ssl
import config_file

port = 465  # For SSL
smtp_server = "smtp.gmail.com"
sender_email = config_file.SENDER_MAIL_ID  # Enter your address
password = config_file.SENDER_MAIL_PASSWORD

def sendMail(message):
	receiver_email = "tarunagarwal27.99@gmail.com"  # Enter receiver address
	message = """
	Subject : IPM query details

	{message}
	""".format(message=message)
	context = ssl.create_default_context()
	with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
	    server.login(sender_email, password)
	    server.sendmail(sender_email, receiver_email, message)
