SynthDef.new(\octafuz,
{|bus, octafuz, octamix|
var osc;
osc = In.ar(bus, 2);
osc = LinXFade2.ar(Clip.ar(TwoPole.ar(osc * (octafuz * 10), [60, 20000], 0.9), -0.75, 4).tanh, osc, 1-octamix);
ReplaceOut.ar(bus, osc)}).add;