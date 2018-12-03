SynthDef.new(\gverb,
{|bus, groom, gmix|
var osc;
osc = In.ar(bus, 2);
osc = GVerb.ar(osc, gmix, groom);
ReplaceOut.ar(bus, osc)}).add;
