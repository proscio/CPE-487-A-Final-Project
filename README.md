# CPE-487-A-Final-Project
Tone generator/ Instrument

Created using base code from CPE 487 [Lab 5](https://github.com/byett/dsd/tree/CPE487-Spring2024/Nexys-A7/Lab-5)

* The **_dac_if_** module converts 16-bit parallel stereo data to the serial format required by the digital to analog converter.
  * This module is unmodified from Lab 5
  * Similarly to its usage in the base code, the topmost module *TonePlayer* sends 16-bit parallel stereo data, which it converts it to the serial format required by the digital to analog converter.

* The **_tone_** module generates a set of signed waves at a sampling rate of 48.8 KHz.
  * This module contains mostly the same code as the *tone* module used in the final state of Lab 5.
  * The frequency of the tone is determined by the input signal pitch.
  * The process cnt_pr generates an unsigned sawtooth waveform count by incrementing a 16-bit counter pitch values every clock cycle.
  * It then takes 2<sup>16</sup> or 65,536 cycles to traverse the range of the counter.
  * The frequency is then 48.8kHz / 2<sup>16</sup> or 0.745 Hz.
  * The frequency with which it traverses the whole 16-bit count range is equal to 0.745*pitch.
  * The signals quad and index are used to generate a triangle wave.
  * quad is also used to generate a square wave, where each "quadrant" alternates the output at the selected frequency.
![finalchart (1)](https://github.com/proscio/CPE-487-A-Final-Project/assets/108437018/85642b0d-793b-469d-86ac-911ac0a7107f)
  * The wave that is assigned to the data output is determined by the button press input recieved by TonePlayer, as well as whether or not the corresponding switch for the instance is active.
   
* The **_TonePlayer_** module is the top level.
  * The 20-bit timing counter tcount is used to generate all the necessary timing signals.
  * This module creates 15 instances of *tone*, each corresponding to a particular pitch (A,B,C,D,E,F,or G) within the two-octave range.
  * The output of these modules is added together and sent to *dac_if*.
  * This module also duplicates the audio output from the left channel to the right channel.

## Parts Needed
* This Project requires the PMOD I2S2 DACattached to the "JA" port on the Nexys A7 board, as well as an device that uses AUX to output audio.

## Expected Behavior:
* When implemented correctly, the program should be able to play multiple notes as determined by the switch positions.
* The Notes will be played when a wave button is sellected:
  * BTNU: Generates a Square Wave
  * BTNC: Generates a Triangular Wave
  * BTND: Generates a Sawtooth Wave
## Steps to Get The Project Running:
### Step 1: Load all of the files into vivado
* Create a new project named Tone Player.
* Inside the project:
  * Add **TonePlayer.vhd** , **dac_if.vhd** , and **tone.vhd** to the sources
  * Add **siren.xdc** as a constraint
  * Select the  _Nexys A7 100 T__ as the board type
### Step 2: Build the Project
* Run Synthesis
* Run Implementation
* Run Generate Bitstream
### Step 3: Prgram device
* In the hardware manager:
  * Selett _Open Target_ and choose the attached board as the target
  * Choose _Program Device_ and select the appropriate bitstream file
##Modifications to code:
## dac_if.vhd
Nothing was changed within this file
## tone.vhd
Added with select statements, using quad(signal) to determine what kind of wave we will need.
 WITH quad SELECT
	   square <=  "0011111111111111" WHEN "00", -- 1st quadrant
               "0011111111111111" WHEN "01", -- 2nd quadrant
               "1100000000000001" WHEN "10", -- 3rd quadrant
               "1100000000000001" WHEN OTHERS; -- 4th quadrant

  WITH quad SELECT
        triangle <= index WHEN "00", -- 1st quadrant
                16383 - index WHEN "01", -- 2nd quadrant
                0 - index WHEN "10", -- 3rd quadrant
                index - 16383 WHEN OTHERS; -- 4th quadrant
                
