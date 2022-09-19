(
var time_prev = 0;
var idx = -1;
var sco, src, ini;

var nxt = {
	var time = Date.getDate.rawSeconds;
	if((time - time_prev > ~time_chat), {
		idx = idx + 1;
		Score.play(sco[idx]);
		defer{ ~mrk.string = idx };
		time_prev = time;
	});
};

MIDIIn.connectAll;
// MIDIFunc.cc({ nxt.() });

~box.view.keyDownAction = {
	|view, char, modifiers, unicode, keycode|
	if(char==$q, { nxt.() });
};


src = [
	[
		[0, [\s_new, \input, 100, 0, 0]]
	],[
		[0, [\b_allocReadChannel, 10, ~path +/+ "midi.wav", 0, 0, 0]],
		[0.01, [\s_new, \demo, 100, 0, 0]],
	]
];


ini = [
	[0, [\s_new, \cntTrig, 99, 0, 0]],
	[0, [\s_new, \pchTrig, 400, 0, 0]],
	[0, [\s_new, \sndMeter, 990, 0, 0]],
	[0, [\s_new, \master, 999, 0, 0]],
];


sco = [
	[
		[0, [\s_new, \psOct, 200, 0, 0]],		// 0
		[0, [\s_new, \percMix, 300, 0, 0]],
	],[
		[0, [\s_new, \pchTrig1, 500, 0, 0]],	// 1
	],[
		[0, [\s_new, \pchComb, 600, 0, 0]],		// 2
	],[
		[0, [\s_new, \combTrem, 700, 0, 0]],	// 3
		[0, [\n_free, 200]],
		[0, [\n_free, 400]],
		[0, [\n_free, 500]],
		[5, [\n_set, 600, \cx, 1]],
	],[
		[0, [\s_new, \Scratch, 800, 0, 0]],		// 4
		[0, [\n_free, 300]],
	],[
		[0, [\n_set, 600, \amp, 0]],			// 5
		[0, [\n_set, 700, \dv, 1]],
	],[
		[0, [\n_set, 700, \sel, 1]],			// 6
	],[
		[0, [\s_new, \RMDelay, 900, 0, 0]],		// 7
		[0, [\s_new, \pchTrig2, 1000, 0, 0]],
		[0, [\n_free, 600]],
		[0, [\n_free, 700]],
		[0, [\n_free, 800]],
		[1, [\n_set, 900, \wx, 1]],
		[20, [\n_set, 900, \zx, 0.1]],
	],[
		[0, [\n_set, 900, \rx, 1, \zx, 0.7]],	// 8
	],[
		[0, [\s_new, \revComb, 1100, 0, 0]],	// 9
		[0, [\n_set, 900, \ix, 0, \zx, 0]],
		[0, [\n_free, 1000]],
		[2, [\n_free, 900]],
	],[
		[0, [\n_set, 1100, \sel, 1]],			// 10
	],[
		[0, [\s_new, \psHarm, 1200, 0, 0]],		// 11
		[0, [\n_set, 1100, \ix, 0]],
		[3, [\n_free, 1100]],
		[20, [\n_set, 1200, \bx, 1]],
	],[
		[0, [\s_new, \psDist, 1300, 0, 0]],		// 12
		[0, [\n_free, 1200]],
		[0, [\s_new, \xVib, 1400, 0, 0]],
	],[
		[0, [\n_free, 1300]],					// 13
		[0, [\n_set, 1400, \amp, 1]],
	],
];

Score.play(src[~demo]);
Score.play(ini);
)