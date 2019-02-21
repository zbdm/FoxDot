from __future__ import absolute_import, division, print_function
### Crash Server Timer
#from .Extensions.timer.hack import *

import os
import sys

## Path Snd
FOXDOT_SND   = os.path.realpath(FOXDOT_ROOT + "/crashsnd_mod/")
FOXDOT_LOOP  = os.path.realpath(FOXDOT_ROOT + "/crashsnd/_loop_/")
FoxDotCode.use_sample_directory(FOXDOT_SND)

#OSC VIDEO FORWARD
#my_client = OSCClient()
#my_client.connect(("127.0.0.1", 12345)) # Video OSC Ip:port
#DefaultServer.forward = my_client

### Effects
#Dist mod
#    fx = FxList.new('disto', 'disto_mod', {'disto': 0, 'smooth': 0.3, 'distomix': 1}, order=1)
#    fx.add("osc = LinXFade2.ar(CrossoverDistortion.ar(osc, amp:0.5*disto, smooth:smooth),  osc, 1-distomix)")
#    fx.save()

#New Chop, with wave select :
#chopwave = (0: Pulse, 1: Tri, 2: Saw, 3: Sin, 4: Parabolic )
# and chopi = oscillator phase
# fx = FxList.new('chop', 'chop', {'chop': 0, 'sus': 1, 'chopmix': 1, 'chopwave': 0, 'chopi': 0}, order=2)
# fx.add("osc = LinXFade2.ar(osc * SelectX.kr(chopwave, [LFPulse.kr(chop / sus, iphase:chopi, add: 0.01), LFTri.kr(chop / sus, iphase:chopi, add: 0.01), LFSaw.kr(chop / sus, iphase:chopi, add: 0.01), FSinOsc.kr(chop / sus, iphase:chopi, add: 0.01), LFPar.kr(chop / sus, iphase:chopi, add: 0.01)]), osc, 1-chopmix)")
# fx.save()

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
