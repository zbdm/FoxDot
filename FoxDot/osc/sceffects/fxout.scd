SynthDef.new(\fxout,
{|bus, fx, tmp, fx_lvl|
var osc;
osc = In.ar(bus, 2);
Out.ar(2, osc);
tmp = AudioIn.ar(1);
tmp = Mix(tmp) * fx_lvl * 0.5;
osc = SelectX.ar(fx, [osc, tmp+0.0001]);
ReplaceOut.ar(bus, osc)}).add;