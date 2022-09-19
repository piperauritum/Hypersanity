SynthDef(\pa, {
	arg pch;
	n = pch/4;
	e = EnvGen.ar(Env.perc(0, 0.3), doneAction: 2);
	a = SinOsc.ar(n, SinOsc.ar(n*2.5, 0, e**4*8), e/2);
	o = Pan2.ar(a, pch%2-1);
	Out.ar(~mxA_a, o);
}).store;

SynthDef(\pb, {
	arg pch;
	e = EnvGen.ar(Env.perc(0, 0.3), doneAction: 2);
	n = e**15*8*pch+pch;
	m = pch%3/3*5;
	a = SinOsc.ar(n, SinOsc.ar(pch/3.5)*m, e/2);
	o = Pan2.ar(a, pch%2-1);
	Out.ar(~mxA_a, o);
}).store;

SynthDef(\pc, {
	arg pch;
	e = EnvGen.ar(Env.perc(0, 0.2), doneAction: 2);
	n = e**10*10*pch+pch;
	a = SinOsc.ar(n, 0, e**2);
	o = Pan2.ar(a, pch%2-1);
	Out.ar(~mxA_a, o);
}).store;

SynthDef(\pd, {
	arg pch;
	e = EnvGen.ar(Env.perc(0, 0.5), doneAction: 2);
	a = LFNoise0.ar(4000)*(e**4);
	a = BPF.ar(a, pch*4, 0.05, 10);
	o = Pan2.ar(a, pch%2-1);
	Out.ar(~mxA_a, o);
}).store;

SynthDef(\pe, {
	arg pch;
	d = Line.kr(dur: 2, doneAction: 2);
	i = Impulse.ar(pch%10+5)*Line.ar(1, 0, 1);
	e = EnvGen.ar(Env.perc(0, 0.1), i);
	a = Mix(LFPulse.ar(pch*[2, 1/2], 0, 0.5, e/5));
	o = Pan2.ar(a, pch%2-1);
	SendReply.kr(Done.kr(d), '/fin', pch);
	Out.ar(~mxB_a, o);
}).store;

SynthDef(\pf, {
	arg pch;
	d = Line.ar(0, 1, 5, doneAction: 2);
	f = d/20+1*pch;
	e = sin(d*pi);
	a = SinOsc.ar(f, 0, e/30);
	o = Pan2.ar(a, pch%2-1);
	SendReply.kr(Done.kr(d), '/fin', pch);
	Out.ar(~out_a, o);
}).store;