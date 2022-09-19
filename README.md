# ﻿Hypersanity

﻿Hypersanity (2018) for Alto Saxophone & Computer

Composed and programmed by **Takumi Ikeda**

## The live electronic part with SuperCollider
Updated: Sep. 14, 2021

### Audio Input/Output

- Input: 1ch (mono)
- Output: 2ch (stereo)

### Footswitch
- Place a MIDI footswitch onstage for use by the saxophonist.
- The SuperCollider program performs scene changes by receiving CC messages from the footswitch.
- The program ignores switching sequences within ~time_chat seconds of the last scene change.

### Initial Settings

When running the program for the first time, perform the following steps.

- Launch SuperCollider (3.9 or later).
- Select `File > Open startup file`.
- Write the following code in the startup file (startup.scd) and save it.
- Select `Language > Recompile Class Library`.
- Select `Server > Boot Server`.

~~~
s.options.memSize = 2**19;
~~~

To make the audio interface explicit, add the following code to startup.scd.
The device names are displayed in the Post window when SuperCollider is started.

~~~
s.options.inDevice_(" [Your input device name] ");
s.options.outDevice_(" [Your output device name] ");
~~~

### The Method of Use
- Open MAIN.scd in SuperCollider.
- Move the cursor inside the parentheses, `~input = 0;` or the line below it, and evaluate the code. The meterBox window appears.
- Scene changes are executed by the saxophone player using the footswitch.
- The scene change is also possible by pressing the "q" key while the meterBox window is active. If the meterBox window is not active, the window's background color is darkened.
- Close the meterBox window to end the performance.

### The Configuration Items on MAIN.scd

- `~input` The index number of the channel for audio input
- `~output` The index number of the channel for audio output
- `~demo` 1 = Test play using midi.wav
- `~thresh` The threshold (dB) of noise gate
- `~time_chat` Time to ignore switches from previous switching (sec)

#### `Pitch detection thresholds`

Adjust `~aTx`, `~pTx`, `~aTy`, and `~pTy` so that the values of `Tx` and `Ty` in the meterBox are approximate as follows.

- `Tx` : 10-30 triggers per second (Effective for scenes 0 to 2)
- `Ty` : 3-10 triggers per second (Effective for scenes 3 to 6)

### Other Materials

The materials below are available to those who contact the composer.

- Score for Saxophone
- Audio file for testing (midi.wav)

### License

See [LICENSE.md](LICENSE.md).
