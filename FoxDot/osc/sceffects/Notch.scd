
SynthDef.new(\notch,
{|bus, npf, npr|
var osc;
osc = In.ar(bus, 2);
osc = Notch.ar(osc, npf, npr);
ReplaceOut.ar(bus, osc)}).add;
