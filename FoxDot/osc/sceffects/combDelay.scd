SynthDef.new(\combDelay,
{|bus, echotime, echo, echomix, beat_dur|
var osc;
osc = In.ar(bus, 2);
osc = LinXFade2.kr(osc + CombL.ar(osc, delaytime: echo * beat_dur, maxdelaytime: 2 * beat_dur, decaytime: echotime * beat_dur), osc, 1-echomix);
ReplaceOut.ar(bus, osc)}).add;
