(SynthDef.new(\flanger,
	{|bus, flgdelay, flgdepth, flgrate, flgfb|
    var decay=0.0, osc, maxdelay=0.013, maxrate=10.0, dsig, mixed, local;
    osc = In.ar(bus, 2);
    local = LocalIn.ar(2);
    dsig = AllpassL.ar(osc + (local * flgfb), maxdelay * 2, LFPar.kr(flgrate * maxrate,0,flgdepth * maxdelay,flgdelay * maxdelay),decay);
    osc = osc + dsig;
    LocalOut.ar(osc);
    ReplaceOut.ar(bus, osc);
}).add;
)
