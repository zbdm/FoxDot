SynthDef.new(\jpverb,
{|bus, jpverb, damp, jpmix|
var osc;
osc = In.ar(bus, 2);
osc = LinXFade2.ar(JPverb.ar(osc, jpverb, damp, earlyDiff: 0.707, modDepth: 0.1, modFreq: 2, low: 1, mid: 1, high: 1, lowcut: 500, highcut: 2000),  osc, 1-jpmix);
ReplaceOut.ar(bus, osc)}).add;