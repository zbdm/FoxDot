
(
FoxDot.start;

StageLimiter.activate;

)
// SynthDefs



SynthDef(\glitchcore, {
	arg bus =0, amp= 0.5, gate=1, dur=1, sawFreq=1;
	var sigbase, sigmod, sig, env, env2, bass;
	env =  EnvGen.ar(Env.adsr(0, 0, 0.5, dur), gate, doneAction: 2);
	env2 = EnvGen.ar(Env.perc(0, 0.1), gate);
	sigbase = LocalBuf(1e4,2).clear;
	bass = CombL.ar(env2 * SinOsc.ar(54, mul: 8), 8);
	sigmod = Sweep.ar(BufRd.ar(2, sigbase, Saw.ar(sawFreq, 4, 125)), 5e5);
	sig = BufWr.ar(SinOsc.ar([1, 120]), sigbase, sigmod); //SinOsc / LFPulse / Saw
	sig = BufRd.ar(2, sigbase, sigmod) ;
	sig = (sig.tanh + bass);
	sig = sig + RHPF.ar(sig,3200, 1, 2);
	sig = sig + 2 * BPF.ar(sig, 200, 2);
	sig = LPF.ar(sig, 400);
	sig = CompanderD.ar(sig,8/4,1/3,1/10);
	sig = sig * amp;
    ReplaceOut.ar(bus, sig * env);

}).add;

SynthDef(\cluster, {
	arg value=4, bus=0, mult=4, gate=0, amp=1;
	// var env = EnvGen.ar(Env.adsr(doneAction:2));
	var snd = Splay.ar(LeakDC.ar(CombN.ar(SinOsc.ar(1/value, Spring.ar(LFPulse.ar(3/value), 4/value,
		[[0.5e-1, 1.4e-3]]) *
	LFTri.ar(0.125/value, 0, 2pi, mult * pi), mul: 0.5), 4, 1/4, 2))).tanh;

	snd = ReplaceOut.ar(bus, snd * amp);

}).add;


SynthDef(\rsin, {
	arg amp=0, gate=1, rel=1, dur=1, bus=0, freq=440, para1=2000;
	var sig1, env, sig,sig2;
    sig1 = VarSaw;
	env = EnvGen.ar(Env.adsr(0, 0, 1, 16, 1.2  ), gate, doneAction:2);
	sig = FreeVerb2.ar(*XFade2.ar(SinOscFB.ar([60,4],sig1.kr(para1)+1/2),SinOscFB.ar([freq*2,freq],sig1.kr(3.5252)+526/2),sig1.kr(0.1)));
	sig = sig  * env;
	sig2 = LPF.ar(sig, 1000);
	sig = sig + sig2;
	ReplaceOut.ar(bus, (sig * amp) * env);
}).add;

SynthDef(\electric, { arg bus=0,vib=1, destroy=4, mult=9999, amp=0.1, pan=0,gate=1, rel= 1, saw=12, dur=1;
	var sig =  Saw.ar(saw)*mult+CuspN.ar(100, 0.1)*0.00001;
	var sig2 = Gendy5.ar(vib).lag+2/[2.02,3]/99++9;
	var sig4 = LFNoise0.ar(1/2).lag+destroy/[2.02,3]/99++9;
	var sig3 = BPF.ar(sig, 440, 4);
	var env =  EnvGen.ar(Env.linen(0.0,dur,0),doneAction:2);
	sig3 =     FreeVerb.ar(CombN.ar(sig3, 1, (sig2/8) + sig4,9),0.25);
	sig3 =     sig3.sum.tanh!2;
	ReplaceOut.ar(bus, (sig3 * amp) * env);}).add;

SynthDef(\radiostatic, { |bus=0, freq=800, gate=1, amp=0.5, dur=0.25, pan=0|
	var env = EnvGen.ar(Env.asr(0,1),gate,doneAction:2);
	var son = LFSaw.ar(freq, 0, Gendy4.ar(dur)) + LFNoise2.ar(freq) + Gendy5.ar(120,2,10,1,freq,Gendy5.ar(15500, 0, 100),0.8 ); 	son = CombN.ar(LPF.ar(FreeVerb.ar(son, 0.5, 0.5), 1600), 0.5);
	son = son * env;
	ReplaceOut.ar(bus,Splay.ar(Pan2.ar(son * amp, pan)));
}).add;

SynthDef(\electricity, {
	arg amp=0, gate=1, rel=1, dur=8, bus=0, freq=440, para1=2000, comp=1;
	var sig1, env, sig,sig2;
	env = EnvGen.ar(Env.adsr(0, 0, 1, rel, 1  ), gate, doneAction:2);
	sig =  SinOscFB.ar([29,32.7]*2,0.5,2).sqrt.thresh(LFNoise2.ar(12.3)).scaleneg(PinkNoise.ar(0.12)).ring2(Impulse.ar([12.7,10.1]).squared);
	sig = sig * env;
	sig = CompanderD.ar(sig,comp/4,1/2,1/2);
	ReplaceOut.ar(bus, (sig * amp) * env);
}).add;

SynthDef(\drone, { arg bus = 0, speed = 1, amp = 0.5, sus = 4, dur = 1, freq=200, gate=1, hpf=40;
	var base_signal = LFNoise1;

    var adsr = EnvGen.ar(Env.linen(0.1,sus,0.1, 1, -3),gate,doneAction:2);
	var sig =  HPF.ar(FreeVerb2.ar(*XFade2.ar(SinOscFB.ar([20,freq],base_signal.ar(speed*2)+1),
	SinOscFB.ar([freq,freq],base_signal.ar(speed)+1/2),base_signal.ar(40))),hpf);
	sig = LeakDC.ar((sig * 1.1).tanh, 0.999);
	sig = (sig * adsr) * amp;
	ReplaceOut.ar(bus, sig);
}).add;

SynthDef(\osc_table, {
	arg gate=1, amp=0.5, bus=0, rel=1;
	var sig, env;

	env = EnvGen.ar(Env.adsr(releaseTime: rel), gate, doneAction: 2);
	sig = {x=0;(80..100).do{|f|f=f/2;x=SinOsc.ar(f+[0,1],x*LFTri.kr(0.4,2).range(1.2,1.6))};x};
	sig = sig * env;
	sig = HPF.ar(sig.tanh, 800);
	sig = sig * amp;

	ReplaceOut.ar(bus, Splay.ar(sig));
}).add;

SynthDef(\osc_table_var, {
	arg gate=1, amp=0.5, bus=0, rel=1;
	var sig, env;

	env = EnvGen.ar(Env.adsr(releaseTime: rel), gate, doneAction: 2);
	sig = {GVerb.ar({|i|Ringz.ar(LPF.ar(Impulse.ar(2/(1.2+i)),6e3),1e3/(i+1),0.3)}.dup(20).scramble.sum/2,18,5).tanh};
	sig = HPF.ar(sig, 1600);
	sig = sig.tanh * env;
	sig = sig * amp;

	ReplaceOut.ar(bus, Splay.ar(sig));
}).add;

SynthDef(\drum_bass, { |amp = 0.25, freq = 42, pulse = 0.1, attackFreq = 100, decay = 0.075, bus=0,
	sustain = 3, pan = 0|
	var sig;
	sig = BLowPass.ar( Impulse.ar(0,0,pulse), 8000 );
	sig = sig + LFPar.ar(
		Env.perc(0,decay).ar.linexp(0,1,freq, attackFreq) *
		LFDNoise3.kr(0.1).exprange(-0.1.midiratio, 0.1.midiratio),
		-1);
	sig = sig * Env([1,0], [sustain], -4).kr(2);
	ReplaceOut.ar(bus,Splay.ar( sig * amp ))
}).add;


SynthDef(\totalsin, {arg bus = 0, amp = 0.5, freq = 220, rel = 0.2, gate=1, hpf = 6000, pan = 0, slicer=0, totalmix1=1, totalmix2=1;

	var sig , sig1, sig2, sig3, env;
    sig1 = SinOscFB;
	sig2 = GVerb.ar(mean(FreqShift.ar(c=sig1.ar(sig1.ar(sig1.ar(800/b=(1..9),1),1/b)+b*[24, 99, 140],1),1/b)+c)/3,200,64,0.5,0.5,9,1,0.7,1);
	sig = sig2 ;
	sig = sig * LinSelectX.kr(slicer,[1, SinOsc.ar(4, 0, 1)]);
	sig = LinXFade2.ar(PitchShift.ar(sig, 0.02, Line.kr(0.1,4,20), 0, 0.0001), sig, totalmix1);
		sig = LinXFade2.ar(PitchShift.ar(sig, 0.02, Line.kr(0.1,1,1), 0, 0.0001), sig, totalmix2);

	env = EnvGen.ar(Env.adsr(1, releaseTime: 64), gate, doneAction:2);
	// sig = GVerb.ar(sig,80,4)/8+sig;
	sig = CompanderD.ar(sig,8/4,1/3,1/10);
	// sig = Limiter.ar(sig);
	sig = sig * env;
	sig = sig * amp;
	ReplaceOut.ar(bus, Pan2.ar(sig, pan));
}).add;


SynthDef(\pianovel, { |bus=0, amount=440, detune=0, gate=1, amp=0.5, velocity=127, hard=0.8, velhard=0.8|
	var son = MdaPiano.ar(amount + detune, gate, release: 0.9, stereo: 0.3, sustain: 0, vel: velocity, hard: hard, velhard: velhard);
	DetectSilence.ar(son, 0.01, doneAction:2);
	ReplaceOut.ar(bus, son * amp);
}).add;

	SynthDef(\explosion2, {arg bus=0, freq = 200, pan=0.5, amp=0.5;
		var ae,sig,finalsig;
		ae = EnvGen.kr(Env.asr(0, 1, 0.05, 1, 0));
		sig = Impulse.ar(0);
		sig = LPF.ar(FreeVerb2.ar(sig,sig,1,0.95,0.4),freq);
		sig = (sig*5000).tanh;
		sig = LPF.ar(sig,8000);
		finalsig = amp*ae*sig;
		DetectSilence.ar(finalsig, doneAction:Done.freeSelf);
		ReplaceOut.ar(bus, finalsig);
	}).add;

)


SynthDef(\garfield, { arg bus=0, freq=440, mult=4, amp=1, pan=0,gate=1, rel= 1, dur=1, phase=0, vib=1;

	var env =  EnvGen.ar(Env.linen(0.0,dur,0),doneAction:2);
	var del =  SinOsc.ar(1/8, phase, mult);
	var sig =  SinOscFB.ar(freq, del, add: SinOsc.ar(vib));

	sig = Decimator.ar(sig, 2000);
	sig = CrossoverDistortion.ar(sig);
	sig = RLPF.ar(sig, 800);
	sig = CombN.ar(sig, 0.04, 0.085);
	sig = Splay.ar(sig);
	ReplaceOut.ar(bus, (sig * amp) * env);}).add;


SynthDef(\ppad, {
	arg  sus,  amp, bus=0,gate=1;
	var sig, env, fenv;

	env=EnvGen.kr(Env([0,1,0],[1,6]),gate,timeScale:sus,doneAction:2);
	sig=SinOsc.ar(\freq.kr+LFNoise0.ar([400,160]).range(2,40).round(2));
	sig=sig+BPF.ar(PinkNoise.ar([0.4,0.6]),\freq.kr,0.1);
	sig=sig - sig.tanh;
	sig=sig*env*amp;
	ReplaceOut.ar(bus, sig);

}).add;



SynthDef(\pulseLead, { |bus=0, gate = 1, t_gate, amp = 1,
        freq = 080, i_prevFreq = -1,
        pwidth = 0.5, detun = 1.01, detunRand = 1.005, widthRand = 0.05, freqLag =
0.08, spread = 0.6,
        ffreq = 2000, gain = 1, t_panic = 0, ffDecay = 0.1, ffHeight = 0, acc = 0,
        atk = 0.01, dcy = 0.15, sus = 0.5, rel = 0.1, retrigLevel = 0.05|
        var n = 7,
        sig,
        detuneArray = Array.fill(n, { |i| detun ** (i / (n-1) * 2 - 1) }),
        ffreqEg = EnvGen.kr(Env.perc(0.01, ffDecay), gate) * (ffHeight * (acc >
0)),
        egTest = LocalIn.kr(1, 0), eg,
        retrig = t_gate * (egTest < retrigLevel);  // at trig time, are we below
retrigLevel?

        i_prevFreq = Select.kr(i_prevFreq < 0, [i_prevFreq, freq]);  // negative,
        freq = Select.kr(
                Duty.kr(Dseq([ControlDur.ir, Dseq([1], inf)]), 0, Dseq([1, Dseq([0],
inf)])),
                [freq, i_prevFreq]
        );
        freq = Lag.kr(freq, freqLag);

        sig = Pulse.ar(
                freq * detuneArray * Array.fill(detuneArray.size, {
                        TExpRand.kr(detunRand.reciprocal, detunRand, t_gate)
                }),
                Clip.kr(pwidth + Array.fill(detuneArray.size, {
                        TRand.kr(widthRand.neg, widthRand, t_gate)
                }), 0.01, 0.99)
        );
        sig = Splay.ar(sig.scramble, spread) * amp;

        ffreq = ffreq * (1 + ffreqEg);
        sig = MoogFF.ar(sig, Clip.kr(ffreq, 20, 20000), gain, t_panic);

        gate = (gate > 0) - (retrig > 0);
        eg = EnvGen.kr(Env.adsr(atk, dcy, sus, rel), gate, doneAction: 2);
        LocalOut.kr(eg, DC.kr(0));  // workaround for 3.8 bug
        sig = sig * eg;

        ReplaceOut.ar(bus, sig);
}).add;


SynthDef(\synthWave, {
	arg bus=0, amp=0.5, freq=220, modpartial=1, carPartial=0.5, index=4, mul= 0.1, delMul=0.04, gate=1,rel=8;
	var env, sig, sig2;

	env = EnvGen.ar(Env.adsr(rel, rel, releaseTime:rel, ),gate, doneAction: 2);

	sig =  SinOsc.ar(freq * 1, 0, freq * index * LFNoise1.kr(10.reciprocal).abs);
	sig2 = SinOsc.ar((freq * carPartial) + sig, 0, mul);

	sig = DelayN.ar(sig2, 0.048, 0.048);
	sig = Mix.arFill(5, { CombN.ar(sig, 0.1, LFNoise1.ar(Rand(0, 0.1), delMul, 0.05), 15) });
	sig = AllpassN.ar(sig, 0.050, [Rand(0, 0.05), Rand(0,0.05)], 1)!4;
	sig = LPF.ar(sig, 1200) + sig/8;
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);


	ReplaceOut.ar(bus, (sig * env) * amp);

}).add;



SynthDef(\saw3, {
	arg atk=2, sus=0, rel=3, ts=1, c1=1, c2=(-1), freq=500, detune=0.2, pan=0, cfhzmin=4, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1, bus=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[c1,0,c2]),timeScale:ts,doneAction:2);
	sig = Saw.ar(freq*{SinOsc.kr(0.1,detune).midiratio}!2) + VarSaw.ar(freq /2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin,cfhzmax)
		).exprange(cfmin,cfmax)}!4,
		{LFNoise1.kr(0.1).exprange(rqmin,rqmax)}!4
	);
	sig = FreeVerb.ar(sig, 1, 40);
	sig = LPF.ar(sig, [300, 4300], 1);
	sig = BLowShelf.ar(sig,lsf,2,ldb);
	sig = Balance2.ar(sig[0],sig[1],pan);
	sig = sig*env*amp;
	ReplaceOut.ar(bus,sig);
}).add;


SynthDef(\faim, { arg bus=0, amp=0.1, sus=0.2, gate=1, pan=0, freq=200, vib=32;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * ((0..1)/1 - 0.5 * 0.0007 + 1);
	env1 = EnvGen.kr(Env([0,1,0.051,0],[0.001,0.01,0.8], [4,-8]), 1);
	env2 = EnvGen.kr(Env([0,1,0.051,0],[0.005,0.5,1.5], [0,-8], releaseNode:2), 1);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.2], [0,0,-4], releaseNode:2), gate);
	env4 = EnvGen.kr(Env([0,1,0],[0.002,2.8], [0,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.8], [4,0,-4], releaseNode:2), gate);
	env6 = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4]), 1);
	sig1 = SinOsc.ar(freq * 11 + 0) * env1 + (SinOsc.ar(vib) * env1);
	sig2 = SinOsc.ar(freq * 6 * ( sig1 * 2.5 + 1 )) * env2;
	sig3 = SinOsc.ar(freq * 2 * 1 + 0) * env3;
	sig4 = SinOsc.ar(freq * 1 * ( sig3 * 2.5 + 1 ) + 0) * env4;
	sig5 = SinOsc.ar(freq * 1 * ( sig2 * 2.5 + 1 ) * (sig4 * 2.5 + 1)) * env5;
	sig6 = SinOsc.ar(freq * 2) * env6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0.0, 0.0, 0.0,  0.0, 0.5, 0.5]);
	sig = sig /2;
	sig = sig.flop.sum;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.001,0,1,0.01, 1,-1) ),gate,doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig = Limiter.ar(sig);
	sig = sig.tanh;
	sig = Pan2.ar(sig, pan + [ 0, 0, 0, 0, 0, 0], amp).sum;
	ReplaceOut.ar(bus, sig);
}).add;


SynthDef(\dfm, {
	arg gate=1, amp=0.5, bus=0, rel=1, freq=440, mult=1, multrange=0.1, vib=1;
	var sig, env;

	env = EnvGen.ar(Env.adsr(releaseTime: rel), gate, doneAction: 2);
	sig = Saw.ar(freq);

	sig = DFM1.ar(VarSaw.ar([freq,freq*[1.01, 4.01]]*mult,0.0,multrange),(freq*2)*mult,VarSaw.kr(vib).range(multrange,1.1),1,0,0.001,0.5);

	sig = DelayN.ar(sig, 0.048, 0.048);
	sig = AllpassN.ar(sig, 0.050, [Rand(0, 0.05), Rand(0,0.05)], 1)!2;
	sig = sig / 2.5;
	sig = sig * env;
	sig = sig * amp;

	ReplaceOut.ar(bus, Splay.ar(sig));
}).add;

//////////Zbdm Synth//////////

/////!! Small dur = Server(40%) !!///////
(
SynthDef(\coreNoiz, {
	|amp=1, pan=0, freq=0, vib=0, fmod=0, rate=8, bus=0, blur=1, beat_dur=1, atk=0.001, decay=0.001, sus=0.55,rel=0.125, peak=1, level=0.8, gate=1, lfofreq = 3, lopfreq = 800, rq = 0.5, detune1 = 12, detune2 = 8|

	var env, nvoices1=2, nvoices2=4, osc1, m, lfo, osc2, output;

	sus = sus * blur;
	freq = In.kr(bus, 1);
	freq = [freq, freq+fmod];

	env = EnvGen.ar(Env.adsr(atk, decay, sus, rel, amp), gate, doneAction:2);

	osc1 = {
		 m = 2**(detune1/1200).rand2;
		 lfo = SinOsc.ar(lfofreq.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq/2), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices1);

	osc2 = {
		 m = 2**(detune2/1200).rand2;
		 lfo = SinOsc.ar(lfofreq.rand).range(0,1);
		DelayC.ar(LFSaw.ar(m * freq), 0.02, freq.reciprocal.rand * lfo);
	}.dup(nvoices2);

	output = Pan2.ar(output*amp*env*0.1, pan);
	Out.ar(bus, output);
}).add;
)


/////Cool with small dur, low CPU////
(
SynthDef("profenstring", {
	arg amp=0.3, pan=0, freq=0, vib=0, fmod=0, rate=8, bus=0, blur=1, beat_dur=1, atk=0.01, decay=0.5, sus=1, rel=0, peak=1, level=0.8, gate = 1, lforate = 10, lfowidth = 0.5, cutoff = 12000, rq = 0.5;

	var lfo, pulse, filter, env;
	lfo = LFTri.kr(lforate * [1, 1.01], Rand(0, 2.0) ! 2);
	pulse = Pulse.ar(freq * [1, 1.01], lfo * lfowidth + 0.5);
	filter = RLPF.ar(pulse, cutoff, rq);
	env = EnvGen.ar(
		envelope: Env.adsr(atk, decay, sus, rel, amp),
		gate: gate,
		doneAction: 2);
	Out.ar(bus, Pan2.ar(
		in: Mix(filter*amp*0.4) * env,
		pos: pan)
	);
}).add;
)
