from __future__ import absolute_import, division, print_function
### Crash Server Timer
#from .Extensions.timer.hack import *

import os
import sys

## Path Snd
#FOXDOT_SND   = os.path.realpath(FOXDOT_ROOT + "/crashsnd_mod/")
#FOXDOT_LOOP  = os.path.realpath(FOXDOT_ROOT + "/crashsnd/_loop_/")
#FoxDotCode.use_sample_directory(FOXDOT_SND)

#OSC VIDEO FORWARD
#my_client = OSCClient()
#my_client.connect(("127.0.0.1", 12345)) # Video OSC Ip:port
#DefaultServer.forward = my_client

class FilterOSCClient(OSCClient):
    def send(self, message, *args):
        if "video" in str(message.message):
            OSCClient.send(self, message, *args)

my_client = FilterOSCClient()
my_client.connect(("localhost", 12345))
DefaultServer.forward = my_client


##### SDur by Quantuum #####
def SDur(target):
  from random import randint
  sr = random.SystemRandom()
  indexes = random.randint(1,target+4)
  dividers = [1,1,1,2,2,2,2,4,8] # 1/4 and 1/8-typed notes get more scarce
  list=[]
  for i in range(0,indexes):
      if target%2 == 0:
          a = random.randint(1,target/2)/sr.choice(dividers)
      else:
          a = random.randint(1,(target-1)/2)/sr.choice(dividers)
      if sum(list)+a < target/2:
          list.append(a)
      if sum(list)+a < target:
          list.append(a)
  list.append(target-sum(list))
  return P[list].shuffle() # always return a list of durations with total duration equals target

# variation giving shorter durations
def SmDur(target):
  from random import randint
  sr = random.SystemRandom()
  indexes = random.randint(1,target+4)
  dividers = [1,1,1,2,2,2,2,4,8] # 1/4 and 1/8-typed notes get more scarce
  list=[]
  for i in range(0,indexes):
      if target%2 == 0:
          a = random.randint(1,target/2)/sr.choice(dividers)
      else:
          a = random.randint(1,(target-1)/2)/sr.choice(dividers)
      if sum(list)+a < target/2:
          list.append(a)
      if sum(list)+a/2 < target:
          list.append(a/2)
  list.append(target-sum(list))
  return P[list].shuffle() # always return a list of durations with total duration equals target

# a variation with score-like durations
def ScDur(target):
  from random import randint
  sr = random.SystemRandom()
  indexes = random.randint(1,target+4)
  standards = [0.25,0.375,0.75,0.5,1,2,3,4] # standard dur values found in scores
  dividers = [1,1,2] # skip 1/4 and 1/8 (comes after)
  list=[]
  for i in range(0,indexes):
      if target%2 == 0:
          a = random.randint(1,target/2)/sr.choice(dividers)
      else:
          a = random.randint(1,(target-1)/2)/sr.choice(dividers)
      if sum(list)+a < target/4:
          list.append(a)
      if sum(list)+a/2 < target/2:
          list.append(a/2)
      if sum(list)+a < target:
          list.append(a)
      if sum(list)+a/4 < target:
          list.append(a/4)
  if sum(list) < target:
      for i in range(0,len(standards)):
          if target-sum(list)%standards[i] != 0 and standards[i] < target-sum(list):
              list.append(standards[i])
      if sum(list) < target:
          list.append(target-sum(list))
  return P[list].shuffle() # always return a list of durations with total duration equals target
