SynthDef.new(\chop,
{|bus, chop, sus, chopmix=1|
var osc;
osc = In.ar(bus, 2);
osc = osc = LinXFade2.ar(osc * LFPulse.kr(chop / sus, add: 0.01), osc, 1-chopmix);
ReplaceOut.ar(bus, osc)}).add;
