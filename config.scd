var ary = [];
var trigs = [[0],[0]];

~in_a = 50;
~out_a = 60;
~mxA_a = 70;
~mxB_a = 80;
~moA_k = 0;
~moB_k = 1;
~pcA_k = 2;
~pcB_k = 3;

OSCFunc({|msg|
	x = msg[3].round%4;
	x = [\pa, \pb, \pc, \pd][x];
	s.sendMsg(\s_new, x, -1, 0, 0, \pch, msg[3]);
}, '/perc');

OSCFunc({|msg|
	if ((ary.size < 20), {
		x = [\pe, \pf][msg[4]];
		s.sendMsg(\s_new, x, -1, 0, 0, \pch, msg[3]);
		ary = ary.add(msg[3]);
		// ary.postln;
	});
}, '/tupl');

OSCFunc({|msg|
	ary.removeAt(ary.indexOf(msg[3]));
	// ary.postln;
}, '/fin');

OSCFunc({|msg|
	var id = msg[4];
	if(trigs[id].size==10, { trigs[id].removeAt(0) });
	trigs[id] = trigs[id].add(msg[3]);
	fork{
		defer{ ~num[id].string = trigs[id].sum };
		defer{ ~lev[id].value = trigs[id].sum/40 };
	};
}, '/cnt');

OSCFunc({|msg|
	msg.postln;
}, '/mon');

OSCFunc({|msg|
	defer{
		~meter[msg[3]].value = msg[4].ampdb.linlin(-80, 0, 0, 1);
		~meter[msg[3]].peakLevel = msg[5].ampdb.linlin(-80, 0, 0, 1);
	};
}, '/meter');