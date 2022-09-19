/*
Hypersanity for Alto Saxophone & Computer
Composed and Programmed by Takumi Ikeda, 2018
Commissioned by Sumihisa Arima
*/

/*
// startup.scd
s.options.inDevice_("MME : IN (UA-4FX)");
s.options.outDevice_("MME : スピーカー");
s.options.memSize = 2**19;
s.boot;
*/

(
~input = 0;				// input channel number
~output = 0;			// output channel number
~demo = 0;				// 0 = on stage | 1 = demo with "midi.wav"
~thresh = -48.0;		// noise gate level (dB)
~time_chat = 2.0;		// debounce time (sec)

/* Pitch detection thresholds */

// Tx : 10-30 trigs per sec
~aTx = -26.0;			// ampThreshold (dB) (see UGens > Pitch)
~pTx = -26.0;			// peakThreshold (dB)

// Ty : 3-10 trigs per sec
~aTy = -20.0;			// ampThreshold (dB)
~pTy = -6.0;			// peakThreshold (dB)

~path = thisProcess.nowExecutingPath.dirname;
["UI", "config", "synth", "perc", "seq"].do{|e|
	(~path +/+ e ++ ".scd").load;
};
)