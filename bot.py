#!/usr/bin/env python3

import re
import socket
import threading
from time import sleep
import cfg



def chat(sock, msg):
    """
    Send a chat message to the server.
    Keyword arguments:
    sock -- the socket over which to send the message
    msg  -- the message to be sent
    """
    sock.send("PRIVMSG {} :{}\n".format(cfg.CHAN, msg).encode("utf-8"))

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
s.connect((cfg.HOST, cfg.PORT))
s.send("PASS {}\r\n".format(cfg.PASS).encode("utf-8"))
s.send("NICK {}\r\n".format(cfg.NICK).encode("utf-8"))
s.send("JOIN {}\r\n".format(cfg.CHAN).encode("utf-8"))
#---------------------------

#Connect with game client---
gameSocket = socket.socket()
gameHost = socket.gethostname()
gameSocket.bind((gameHost,8080))
gameSocket.listen(5)



CMDS = [
    r"!Awaken",
    r"!KillRed",
    r"!KillOrange",
    r"!KillYellow",
    r"!KillGreen"
]
class Command:
    def __init__(self):
        self.awaken = 0
        self.awakened = False
        self.consuming = False
        self.votes = [0,0,0,0]
        self.candidates = []
        
    def ProcessCommand(self,sock,client,cmd):
      if ("!Awaken" in cmd and not self.awakened):
        self.AwakenPlus(sock,client,cmd)
      if ("!KillRed" in cmd):
        self.VotePlus(sock,client,0)
      if ("!KillOrange" in cmd):
        self.VotePlus(sock,client,1)
      if ("!KillYellow" in cmd):
        self.VotePlus(sock,client,2)
      if ("!KillGreen" in cmd):
        self.VotePlus(sock,client,3)

    def AwakenPlus(self,tsock,client,cmd):
        self.awaken += 1
        if(self.awaken >= cfg.SPAM):
            self.awakened = True
            chat(tsock,"I am awakened")
            client.send("Awakened\n".encode('utf-8'))

    def VotePlus(self,tsock,client,num):
        print(self.candidates)
        if num in self.candidates:
            if self.consuming:
                self.votes[num] += 1
                if(self.votes[num] >= cfg.SPAM):
                    chat(tsock,"I shall consume player "+str(num))
                    msg = "Consume "+str(num)+"\n"
                    client.send(msg.encode('utf-8'))
                    self.votes = [0,0,0,0]
                    self.consuming = False

    def StartConsuming(self,tsock,num1,num2):
        if(self.awakened and not self.consuming):
            self.consuming = True
            chat(tsock,"Who shall I consume?")
            self.candidates = [num1,num2]


CHAT_MSG = re.compile(r"^:\w+!\w+@\w+\.tmi\.twitch\.tv PRIVMSG #\w+ :")
CONSUME_MSG = r"AskConsume (\d+) (\d+)\n"

print('waiting for game client')
client, address = gameSocket.accept()
print('client found')

command = Command()

def ClientLoop():
    while(True):
        response = client.recv(1024).decode("utf-8");
        if re.match(CONSUME_MSG,response):
            num1 = int(re.match(CONSUME_MSG,response).group(1))
            num2 = int(re.match(CONSUME_MSG,response).group(2))
            print(str(num1)+" "+str(num2))
            command.StartConsuming(s,num1,num2)
        if("Quit" in response):
            return

clientThread = threading.Thread(target=ClientLoop)
clientThread.start()

while True:
    response = s.recv(1024).decode("utf-8")
    if response == "PING :tmi.twitch.tv\r\n":
        s.send("PONG :tmi.twitch.tv\r\n".encode("utf-8"))
    else:
        username = re.search(r"\w+", response).group(0)
        message = CHAT_MSG.sub("", response)
        for pattern in CMDS:
            if re.match(pattern, message):
                command.ProcessCommand(s,client,message)
                break
    