(
SynthDef(\pianovel, { |bus=0, freq=440, fmod=0, gate=1, amp=0.5, velocity=127, hard=0.8, sus=1, blur=1, velhard=0.8, pan=0, vib=0|
	var son = MdaPiano.ar([freq + fmod], gate, release: 0.9, stereo: 0.8, sustain: sus * blur, vel: velocity, hard: hard, velhard: velhard);
	son = TwoPole.ar(son, 200,0.5, mul:0.5) + son/2;
	// son = CompanderD.ar(son, 0.5, 0.5);
	DetectSilence.ar(son, 0.01, doneAction:2);
	ReplaceOut.ar(bus, Splay.ar(son * amp, 1, 1, pan));
}).add;
)