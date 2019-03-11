SynthDef.new(\fx2out,
{|bus, fx2, tmp2, fx_lvl2|
var osc;
osc = In.ar(bus, 2);
Out.ar(3, osc);
tmp2 = AudioIn.ar(2);
tmp2 = Mix(tmp2) * (fx_lvl2+0.001);
osc = SelectX.ar(fx2, [osc, tmp2]);
ReplaceOut.ar(bus, osc)}).add;