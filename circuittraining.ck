15 => int interval; //Interval in seconds
30 => int circuitlength; //Length of each circuit in seconds
.5 => float beeplength; //Length of beep in seconds
"dnb.wav" => string inputfile;
500.0 => float freq;

SndBuf buf;
//buf.rate(8); //Useful for testing

SinOsc s;
inputfile => buf.read;

//Play interval first
//Beep (end of circuit)
beep(s, beeplength, freq);
//Silence
play(buf, interval-2*beeplength);
//Beep again (next circuit)
beep(s, beeplength, freq);

while (buf.pos()::samp < buf.length())
{
	//Play track for circuitlength seconds
	play (buf, circuitlength);
	
	//Don't put an interval at end of audio
	if (buf.pos()::samp < buf.length()) {
		//Beep (end of circuit)
		beep(s, beeplength, freq);
		//Play for interval seconds
		play(buf, interval-2*beeplength);
		//Beep again (next circuit)
		beep(s, beeplength, freq*2);
	}
}

fun void beep ( SinOsc s, float duration, float freq ) {
	freq => s.freq;
	//Set output to sine wave for beeplength seconds
	s => dac;
	duration::second => now;
	s =< dac;
}

fun void play (SndBuf buf, float seconds) {
	buf => dac;
	seconds::second => now;
	buf =< dac;
}