#!/usr/bin/env python3

import re
import socket
from time import sleep

# --------------------------------------------- Start Settings ----------------------------------------------------
HOST = "irc.twitch.tv"                          # Hostname of the IRC-Server in this case twitch's
PORT = 6667                                     # Default IRC-Port
CHAN = "#oce_humblepie"                               # Channelname = #{Nickname}
NICK = "ritualbotbot"                                # Nickname = Twitch username
PASS = "oauth:ico8y53ltf4mmkuncsecowqnb9dewx"   # www.twitchapps.com/tmi/ will help to retrieve the required authkey
# --------------------------------------------- End Settings -------------------------------------------------------

def chat(sock, msg):
    """
    Send a chat message to the server.
    Keyword arguments:
    sock -- the socket over which to send the message
    msg  -- the message to be sent
    """
    print("PRIVMSG {} :{}".format(CHAN, msg))
    sock.send("PRIVMSG {} :{}\n".format(CHAN, msg).encode("utf-8"))

def ban(sock, user):
    """
    Ban a user from the current channel.
    Keyword arguments:
    sock -- the socket over which to send the ban command
    user -- the user to be banned
    """
    chat(sock, ".ban {}".format(user))

def timeout(sock, user, secs=600):
    """
    Time out a user for a set period of time.
    Keyword arguments:
    sock -- the socket over which to send the timeout command
    user -- the user to be timed out
    secs -- the length of the timeout in seconds (default 600)
    """
    chat(sock, ".timeout {}".format(user, secs))


#Join Channel----------------
s = socket.socket()
s.connect((HOST, PORT))
s.send("PASS {}\r\n".format(PASS).encode("utf-8"))
s.send("NICK {}\r\n".format(NICK).encode("utf-8"))
s.send("JOIN {}\r\n".format(CHAN).encode("utf-8"))
#---------------------------

#Connect with game client---
gameSocket = socket.socket()
gameHost = socket.gethostname()
gameSocket.bind((gameHost,8080))
gameSocket.listen(5)

CMDS = [
    r"!Awaken",
    # ...
    r"!Killp1"
]

def ProcessCommand(sock,client,cmd):
  if ("!Awaken" in cmd):
    chat(sock,"I am awakened")
    client.send("Awakened\n".encode('utf-8'))


CHAT_MSG=re.compile(r"^:\w+!\w+@\w+\.tmi\.twitch\.tv PRIVMSG #\w+ :")

print('waiting for game client')
client, address = gameSocket.accept()
print('client found')

while True:
    response = s.recv(1024).decode("utf-8")
    if response == "PING :tmi.twitch.tv\r\n":
        s.send("PONG :tmi.twitch.tv\r\n".encode("utf-8"))
    else:
        username = re.search(r"\w+", response).group(0)
        message = CHAT_MSG.sub("", response)
        for pattern in CMDS:
            if re.match(pattern, message):
                ProcessCommand(s,client,message)
                break