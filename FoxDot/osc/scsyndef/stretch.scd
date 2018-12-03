SynthDef.new(\stretch,
{|amp=1, sus=1, pan=0, freq=0, vib=0, fmod=0, rate=1.0, bus=0, blur=1, beat_dur=1, atk=0.01, decay=0.01, rel=0.01, peak=1, level=0.8, buf=0, pos=0, room=0.1, sample=0, dur=1, freqScale=1, windowSize=0.2|
var osc, env, pointer;
sus = sus * blur;
rate = In.kr(bus, 1);
pointer = Line.kr(0, 1, dur);
osc = Warp1.ar(2, buf, pointer, freqScale, windowSize);
osc = osc * EnvGen.ar(Env([0,1,1,0],[0.05, sus-0.05, 0.05]));
osc=(osc * amp);
osc = Mix(osc) * 0.5;
osc = Pan2.ar(osc, pan);
ReplaceOut.ar(bus, osc)}).add;

