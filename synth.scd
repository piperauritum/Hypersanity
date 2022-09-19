SynthDef(\input, {
	a = SoundIn.ar(~input);
	b = InRange.ar(Amplitude.ar(a), ~thresh.dbamp, 1).lag(0.05);
	ReplaceOut.ar(~in_a, a*b);
}).store;


SynthDef(\master, {
	a = InFeedback.ar(~out_a, 2);
	a = HPF.ar(a, 20);
	Out.ar(~output, a);
}).store;


SynthDef(\demo, {
	a = PlayBuf.ar(1, 10, 1, loop: 0);
	ReplaceOut.ar(~in_a, a);
}).store;


SynthDef(\psOct, {
	var in, ps;
	in = InFeedback.ar(~in_a);
	ps = LocalIn.ar;
	ps = PitchShift.ar(in+ps, 0.05, 0.5, 0, 0.01);
	LocalOut.ar(Limiter.ar(ps));
	z = Limiter.ar(in/2+ps*2, -6.dbamp);
	Out.ar(~out_a, z!2);
}).store;


SynthDef(\percMix, {
	a = InFeedback.ar(~mxA_a, 2);
	a = a**0.7;
	a = Limiter.ar(a, -3.dbamp);
	a = FreeVerb.ar(a, 0.1, 0.6, 0);
	b = InFeedback.ar(~mxB_a, 2);
	z = Limiter.ar(a+b, -6.dbamp);
	Out.ar(~out_a, z);
}).store;


SynthDef(\cntTrig, {
	a = In.kr(~moA_k, 2);
	t = Impulse.kr(10);
	Array.fill(2, {|n|
		c = PulseCount.kr(a[n], t);
		c = LastValue.kr(c, 0);
		SendReply.kr(t, '/cnt', [c, n]);
	});
}).store;


SynthDef(\pchTrig, {
	arg gt = 1;
	var in, pc, tr, cn, ps;
	in = InFeedback.ar(~in_a);

	pc = Pitch.kr(in*2, ampThreshold: ~aTx.dbamp, peakThreshold: ~pTx.dbamp)[0];
	Out.ar(99, in);
	Out.kr(~pcA_k, pc);

	tr = Changed.kr(pc.cpsmidi, 1);
	SendReply.kr(tr, '/perc', pc);
	Out.kr(~moA_k , tr);

	pc = DelayN.kr(pc, 2, 2);
	SendReply.kr(Changed.kr(pc.cpsmidi, 1), '/perc', pc/1.5);
}).store;


SynthDef(\pchTrig1, {
	var pc;
	pc = In.kr(~pcA_k);
	pc = DelayN.kr(pc, 1, 1);
	SendReply.kr(Changed.kr(pc.cpsmidi, 5), '/tupl', [pc, 0]);
}).store;


SynthDef(\pchTrig2, {
	var in, pc;
	in = InFeedback.ar(~in_a);
	pc = Pitch.kr(in*2, ampThreshold: ~aTy.dbamp, peakThreshold: ~pTy.dbamp)[0];
	pc = midicps(cpsmidi(pc)-48%36+48);
	Out.ar(99, in);
	pc = DelayN.kr(pc, 20, 20);
	SendReply.kr(Changed.kr(pc.cpsmidi, 5), '/tupl', [pc, 1]);
}).store;


SynthDef(\pchComb, {
	arg amp = 1, cx = 0;
	var in, pc, tr, ip, cm, ba, ch;
	in = InFeedback.ar(~in_a);
	pc = Pitch.kr(in*2, ampThreshold: ~aTy.dbamp, peakThreshold: ~pTy.dbamp)[0];
	pc = midicps(cpsmidi(pc)-48%36+48);
	Out.ar(99, in);
	Out.kr(~pcB_k, pc);

	tr = Changed.kr(pc.cpsmidi, 0.1);
	Out.kr(~moB_k , tr);
	// SendReply.kr(tr, '/mon', pc);

	pc = Latch.ar(pc, tr);
	ip = Pan2.ar(Impulse.ar(pc/48), LFNoise0.ar);

	cm = DelayN.kr(pc, 2, LFNoise0.ar(LFNoise0.ar(1, 1, 2), 1, 1));
	cm = Array.fill(2, {
		Mix(CombN.ar(LFNoise0.ar(1000), 0.1, [2,8]/cm, 1, [0.01, 0.05]));
	});

	ba = LFNoise0.ar(LFNoise0.ar(2, 3, 4), 6, 30);
	ba = SinOsc.ar(midicps(ba).lag(0.1));
	ba = Array.fill(2, {|n|
		p = Phasor.ar(0, [13/23, 11/27][n]/44100)**10;
		HPF.ar(ba**(1-p), 120);
	});

	t = Changed.ar(pc);
	e = EnvGen.ar(Env.perc(0, 0.5), t);
	ch = Mix.fill(4, {|n|
		f = [0, 5, 7, 10][n];
		f = 2**(f/12)*pc;
		f = midicps(f.cpsmidi%24+60).lag(0.05);
		SinOsc.ar(f, SinOsc.ar(f*7, 0, e**4*2), e/6);
	});
	ch = LFNoise0.ar(2, 0.5, 0.5)>0.5*ch;
	ch = Pan2.ar(ch, LFNoise2.ar(5)**0.5);
	ch = DelayN.ar(ch, 2, LFNoise0.ar(LFNoise0.ar(1, 2, 3), 1, 1))*cx;

	z = Limiter.ar(cm+ba+ch*amp+ip, -1.dbamp);
	Out.ar(~out_a, z);
}).store;


SynthDef(\combTrem, {
	arg dv = 4, sel = 0;
	var in, pc, mo, ds, cm;
	in = InFeedback.ar(~in_a);
	pc = In.kr(~pcB_k);
	mo = SinOsc.ar(midicps(pc.cpsmidi*5%24)/dv)**5;
	ds = BPF.ar(in, 800, 0.2)**0.1*dbamp(-9)*mo;
	cm = DelayL.ar(in/8, 0.2, SinOsc.ar(0.2, 0, 0.1, 0.1));
	cm = CombN.ar(cm, 1/200, [1/200, 1/201], 1);
	cm = Limiter.ar(cm, -3.dbamp);
	z = Select.ar(sel, [ds, cm]);
	Out.ar(~out_a, z);
}).store;


SynthDef(\Scratch, {
	var in, pc, px, bp;
	in = InFeedback.ar(~in_a);
	pc = In.kr(~pcB_k);
	px = Latch.kr(pc%5/5*2, Changed.kr(pc.cpsmidi, 1));
	x = DelayN.ar(in, 2, Phasor.ar(0, px/44100, 0, 2));
	y = DelayN.ar(in, 1, (pc%2/2).lag(2));
	z = Select.ar(DelayN.kr(px, 1, 1), [x, y]);
	z = Pan2.ar(z, Wrap.kr(DelayN.kr(px, 1.5, 1.5), -1, 1));
	z = DelayN.ar(z, 3, DelayN.kr(px, 0.5, 0.5)/2*3);
	z = Limiter.ar(z*2, -3.dbamp);
	Out.ar(~out_a, z);
}).store;


SynthDef(\RMDelay, {
	arg ix = 1, rx = 0, zx = 0, wx = 0;
	var in, rm, mo, cp, am, tr, wh, bp, sl, hi;
	in = InFeedback.ar(~in_a)*ix;

	rm = SinOsc.ar(midicps(70.5), 0, in);
	rm = LPF.ar(rm, 200, 2, rm);
	mo = SinOsc.ar(5/9)**4;
	mo = Pan2.ar(rm*mo, SinOsc.ar(7/11, SinOsc.ar(5/11)));
	t = 60/90*7/8;
	rm = CombN.ar(mo, t, t, t*3, -8.dbamp, rm);
	cp = Compander.ar(in, LPF.ar(in, 150, 2, in), 0.5, 0.1, 1, 0.01, 0.05, -12.dbamp);
	rm = Select.ar(rx, [rm, cp]);

	/* high tone and noise */
	am = Amplitude.ar(in, 0, 0.05);
	am = InRange.ar(am, 0.1, 1);
	tr = Trig.ar(1-am, 1e-4);
	wh = Latch.ar(WhiteNoise.ar(wx).abs, tr);
	bp = BPF.ar([PinkNoise.ar, PinkNoise.ar], midicps(wh*84+24).lag(0.1), 1, -18.dbamp);
	sl = InRange.ar(wh%1, 0, 0.5);
	hi = SinOsc.ar(12000, SinOsc.ar(7)*200, -24.dbamp);
	bp = Select.ar(sl, [bp, hi]);

	/* zip */
	z = LFNoise0.ar(0.5, 0.6, 0.7);
	z = LFSaw.ar(z, 0, 0.5, 0.5)**3*60;
	z = Impulse.ar(z);
	z = EnvGen.ar(Env.perc(0, 0.1), z);
	z = HPF.ar(z, 50);
	z = Pan2.ar(z, LFNoise2.ar(5)**0.5, zx.lag(1));
	z = Latch.ar(WhiteNoise.ar.abs, tr)>0.5*z;

	Out.ar(~out_a, rm+bp+z);
}).store;


SynthDef(\revComb, {
	arg sel = 0, ix = 1;
	var in, tr, pn, dx, rf, ph, rv, lo, la, lb, kk;
	in = InFeedback.ar(~in_a)*ix;
	tr = Trig.ar(InRange.ar(Amplitude.ar(in, 0, 0), 0.1, 1));
	pn = Pan2.ar(in, Latch.ar(WhiteNoise.ar, tr));
	dx = Pan2.ar(in, Latch.ar(WhiteNoise.ar**0, tr));

	/* rise & fall */
	rf = Mix.fill(2, {|n|
		w = [2**(-1/8), 2**(1/8)][n];
		x = InFeedback.ar(40+n) + dx[n];
		y = PitchShift.ar(x, 0.05, w, 0, 0.01);
		z = DelayN.ar(y, 0.1, 0.07, 0.97);
		Out.ar(40+n, z);
		Pan2.ar(z, n*2-1*dbamp(-3));
	});

	/* reversed echo */
	ph = Phasor.ar(0, 2/44100, 0, 10);
	rv = DelayL.ar(pn, 10, ph);
	rv = CombN.ar(rv, 0.2, 60/90/8, 0.7)+rv;
	rv = DelayL.ar(rv, 10, ph);

	/* reverse to reverb */
	a = 3.dbamp;
	lo = Phasor.ar(0, 1.5/44100, 0, 2);

	la = DelayL.ar(pn, 2, lo);
	la = LPF.ar(la, 150, 4, la)*a;
	la = FreeVerb.ar(la, 0.5, 0.9, 0.9);

	/* reverb to reverse */
	lb = LPF.ar(pn, 150, 4, pn);
	lb = FreeVerb.ar(lb, 0.5, 0.9, 0.9);
	lb = DelayL.ar(lb, 2, lo)*a;

	/* kick */
	t = PulseDivider.ar(tr, 7);
	f = 50;
	e = EnvGen.ar(Env.perc(0, 0.5), t);
	n = e**8*20+1*f;
	kk = SinOsc.ar(n, SinOsc.ar(f*3.5), e**0.5/2);
	kk = LPF.ar(kk, 80, 1, kk);
	kk = FreeVerb2.ar(kk, kk, 0.1, 0.97);
	kk = Compander.ar(kk, kk, 0.04, 10, 1);

	z = Select.ar(sel, [rf+la, rv+lb]);
	z = Limiter.ar(z+in+kk, -1.dbamp);
	Out.ar(~out_a, z);
}).store;


SynthDef(\psHarm, {
	arg bx = 0;
	var in, ps, ba;
	in = InFeedback.ar(~in_a);
	in = PitchShift.ar(in, 0.1, 3/8, 0, 0.05, 1, in);
	ps = PitchShift.ar(InFeedback.ar(~mxA_a, 2)+in, 0.1, 4/3, 0, 0.05);
	ps = DelayN.ar(ps, 0.5, 6/9/6, 0.97);
	Out.ar(~mxA_a, Limiter.ar(HPF.ar(ps, 30)));

	ba = InFeedback.ar(~mxB_a, 2)+ps*bx.lag(1);
	ba = PitchShift.ar(ba, 0.1, 1/2, 0, 0.05);
	Out.ar(~mxB_a, Limiter.ar(HPF.ar(ba, 30)));
	ba = LPF.ar(ba, 300, 1, ba);

	z = Limiter.ar(HPF.ar(in/2+ps+ba, 50));
	Out.ar(~out_a, z);
}).store;


SynthDef(\psDist, {
	var in, ps, pw;
	in = InFeedback.ar(~in_a);
	ps = PitchShift.ar(LocalIn.ar(2)+in, 0.05, 3/8, 0, 0.01);
	LocalOut.ar(Limiter.ar(ps));
	ps = HPF.ar(ps, 50);

	z = Array.fill(2, {|n|
		pw = if(LFNoise0.ar(LFNoise0.ar(3,3,7)).abs<0.8, 0.05, -0.4);
		HPF.ar(in/2+ps[n]**pw, 50);
	});
	z = Limiter.ar(z, -1.dbamp);
	Out.ar(~out_a, z);
}).store;


SynthDef(\xVib, {
	arg amp = 0;
	var in, va, vb;
	in = InFeedback.ar(~in_a);
	va = DelayL.ar(in, 0.002, LFNoise2.ar(100, 0.001, 0.001));
	vb = DelayL.ar(in, 5, SinOsc.ar(20, 0, 0.1, 4.9));
	vb = Pan2.ar(vb, vb**0.5);
	z = Limiter.ar(vb*2+va, -6.dbamp)*amp;
	Out.ar(~out_a, z);
}).store;


SynthDef(\sndMeter, {
	a = [SoundIn.ar(~input), InFeedback.ar(~output), InFeedback.ar(~output+1)];
	t = Impulse.kr(30);
	Array.fill(3, {|i|
		x = Amplitude.kr(a[i]).lag(0, 0.5);
		y = K2A.ar(Peak.ar(a[i], Delay1.kr(t)).lag(0, 0.5));
		SendReply.kr(t, '/meter', [i, x, y]);
	});
}).store;


/* not in use */

SynthDef(\autochord, {
	arg dt = 0, du = 3;
	var tm, tr, fq, ev, hi;
	EnvGen.ar(Env.sine(du), dt, doneAction: 2);
	tm = { LFNoise0.ar(4, 4, 8) };
	tr = LFNoise0.ar(tm.(), 8, 12);
	tr = Impulse.ar(tr);
	fq = LFSaw.ar(1e4).abs*36+36;
	fq = Latch.ar(fq.midicps, tr);
	#tr, fq = DelayN.ar([tr, fq], 3, LFNoise0.ar(tm.(), 1.5, 1.5));
	ev = EnvGen.ar(Env.perc(0, 0.5), tr);
	hi = SinOsc.ar(12000, SinOsc.ar(7)*200, -20.dbamp);
	o = Mix.fill(4, {|n|
		a = [0, 10.5, 7, 15.5][n];
		a = 2**(a/12)*fq;
		Pan2.ar(LFSaw.ar(a, 0, ev), n/3*2-1*(-12.dbamp));
	});
	o = RLPF.ar(o, ev**4*8000+100, 1);
	o = Limiter.ar(o+hi, -3.dbamp);
	o = DelayC.ar(o, 6, VarLag.kr(dt, du, 2));
	Out.ar(~out_a, o);
}).store;


SynthDef(\freeze, {
	a = InFeedback.ar(~in_a);
	b = Amplitude.ar(a, 0, 0.1);
	c = InRange.ar(b, 0.5, 1);
	d = Phasor.ar(0, c, 0, 44100/20);
	e = LocalBuf(44100/20, 1);
	f = BufWr.ar(a, e, d);
	g = PlayBuf.ar(1, e, loop: 1);
	g = FreeVerb2.ar(g, g, 0.9, 0.1);
	Out.ar(~out_a, g);
}).store;


SynthDef(\hoge, {
	arg pch, dur;
	e = EnvGen.ar(Env.linen(0.01, dur-0.02, 0.01), doneAction: 2);
	f = midicps(pch+48-9);
	o = SinOsc.ar(f*2, SinOsc.ar(f)*8, e/5);
	Out.ar(~in_a, o);
}).store;