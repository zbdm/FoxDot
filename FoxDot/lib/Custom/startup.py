from __future__ import absolute_import, division, print_function

import os
import sys

## Path Snd
FOXDOT_SND   = os.path.realpath(FOXDOT_ROOT + "/crashsnd/")
FOXDOT_LOOP  = os.path.realpath(FOXDOT_ROOT + "/crashsnd/_loop_/")
FoxDotCode.use_sample_directory(FOXDOT_SND)

#OSC VIDEO FORWARD
my_client = OSCClient() 
my_client.connect((localhost, 12345)) # Video OSC Ip:port
DefaultServer.forward = my_client

#Video Synth
video = FileSynthDef("video")
video.add()

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
