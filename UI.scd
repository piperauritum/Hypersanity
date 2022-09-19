var trig;

~box = Window.new("meterBox", Rect(10, 100, 400, 250));
~box.alwaysOnTop = true;
~box.onClose = defer{ CmdPeriod.run };
~box.toFrontAction = {
	~box.background = Color.new255(255, 230, 180);
};
~box.endFrontAction = {
	~box.background = Color.new255(80, 80, 120);
};
~box.front;


trig = CompositeView(~box, Rect(100, 0, 100, 240));

Array.fill(2, {|n|
	a = StaticText(trig, Rect(40*n, 20, 30, 20));
	a.font = Font("Arial", 12, true);
	a.string = ["Tx", "Ty"][n];
});

a = StaticText(trig, Rect(0, 170, 100, 20));
a.font = Font("Arial", 12);
a.string = "trigs / sec";

~num = Array.fill(2, {|n|
	a = StaticText(trig, Rect(50*n, 40, 40, 20));
	a.font = Font("Arial", 12);
	a.align = \right;
	a.background = Color.gray(0.7);
});

~lev = Array.fill(2, {|n|
	a = LevelIndicator(trig, Rect(50*n, 70, 40, 100));
	a.style = \led;
	a.numSteps = 20;
	a.warning = 10/40;
	a.critical = 30/40;
});


~mrk = StaticText(~box, Rect(240, 50, 150, 100));
~mrk.font = Font("Arial", 120);
~mrk.align = \center;

~meter = Array.fill(3, {|i|
	a = StaticText(~box, Rect(i*25+10, 0, 20, 20));
	a.font = Font("Arial", 12, true);
	a.align = \center;
	a.string = ["IN", "L", "R"][i];

	m = LevelIndicator(~box, Rect(i*25+10, 20, 20, 210));
	m.drawsPeak = true;
	m.numTicks = 9;
	m.numMajorTicks = 3;
	m.warning = -3.dbamp;
	m.critical = -1.dbamp;
});