library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TonePlayer IS
	PORT (
		clk_50MHz : IN STD_LOGIC; -- system clock (50 MHz)
		BTNU : IN STD_LOGIC; -- activates square wave
		BTNC : IN STD_LOGIC; -- activates triangle wave
		SW : IN std_logic_vector (14 downto 0);
		dac_MCLK : OUT STD_LOGIC; -- outputs to PMODI2L DAC
		dac_LRCK : OUT STD_LOGIC;
		dac_SCLK : OUT STD_LOGIC;
		dac_SDIN : OUT STD_LOGIC
	);
END TonePlayer;

ARCHITECTURE Behavioral OF TonePlayer IS

	signal pitch : UNSIGNED (13 DOWNTO 0); -- multiply by .745 to determine frequency
	
	COMPONENT dac_if IS
		PORT (
			SCLK : IN STD_LOGIC;
			L_start : IN STD_LOGIC;
			R_start : IN STD_LOGIC;
			L_data : IN signed (15 DOWNTO 0);
			R_data : IN signed (15 DOWNTO 0);
			SDATA : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT tone IS
		PORT (
		    SWITCH : IN STD_LOGIC;
		    BTNU : IN STD_LOGIC;
		    BTNC : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			pitch : IN UNSIGNED (13 DOWNTO 0);
			data : OUT SIGNED (15 DOWNTO 0)
		);
	END COMPONENT;
	
	
	SIGNAL tcount : unsigned (19 DOWNTO 0) := (OTHERS => '0'); -- timing counter
	SIGNAL data_L, data_R,data0,data1,data2,data3,data4,data5,data6,data7,data8,data9,data10,data11,data12,data13,data14: SIGNED (15 DOWNTO 0); -- 16-bit signed audio data
	SIGNAL dac_load_L, dac_load_R : STD_LOGIC; -- timing pulses to load DAC shift reg.
	SIGNAL sclk, audio_CLK : STD_LOGIC;
	
BEGIN
	-- this process sets up a 20 bit binary counter clocked at 50MHz. This is used
	-- to generate all necessary timing signals. dac_load_L and dac_load_R are pulses
	-- sent to dac_if to load parallel data into shift register for serial clocking
	-- out to DAC
	
	tim_pr : PROCESS
	BEGIN
		WAIT UNTIL rising_edge(clk_50MHz);
		IF (tcount(9 DOWNTO 0) >= X"00F") AND (tcount(9 DOWNTO 0) < X"02E") THEN
			dac_load_L <= '1';
		ELSE
			dac_load_L <= '0';
		END IF;
		IF (tcount(9 DOWNTO 0) >= X"20F") AND (tcount(9 DOWNTO 0) < X"22E") THEN
			dac_load_R <= '1';
		ELSE dac_load_R <= '0';
		END IF;
		tcount <= tcount + 1;
	END PROCESS;
	dac_MCLK <= NOT tcount(1); -- DAC master clock (12.5 MHz)
	audio_CLK <= tcount(9); -- audio sampling rate (48.8 kHz)
	dac_LRCK <= audio_CLK; -- also sent to DAC as left/right clock
	sclk <= tcount(4); -- serial data clock (1.56 MHz)
	dac_SCLK <= sclk; -- also sent to DAC as SCLK
	
	
	dac : dac_if
	PORT MAP(
		SCLK => sclk, -- instantiate parallel to serial DAC interface
		L_start => dac_load_L, 
		R_start => dac_load_R, 
		L_data => data_L, 
		R_data => data_R, 
		SDATA => dac_SDIN 
		);

    t0 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(0),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(704,14), -- use pitch to modulate tone
		data => Data0
		);
	t1 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(1),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(790,14), -- use pitch to modulate tone
		data => Data1
		);
	t2 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(2),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(887,14), -- use pitch to modulate tone
		data => Data2
		);
	t3 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(3),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(939,14), -- use pitch to modulate tone
		data => Data3
		);
	t4 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(4),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(1054,14), -- use pitch to modulate tone
		data => Data4
		);
	t5 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(5),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(1184,14), -- use pitch to modulate tone
		data => Data5
		);
	t6 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(6),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(1329,14), -- use pitch to modulate tone
		data => Data6
		);
	t7 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(7),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(1408,14), -- use pitch to modulate tone
		data => Data7
		);
	t8 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(8),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(1580,14), -- use pitch to modulate tone
		data => Data8
		);
		
	t9 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(9),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(1774,14), -- use pitch to modulate tone
		data => Data9
		);
		
	t10 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(10),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(1878,14), -- use pitch to modulate tone
		data => Data10
		);
		
	t11 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(11),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(2108,14), -- use pitch to modulate tone
		data => Data11
		);
		
	t12 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(12),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(2368,14), -- use pitch to modulate tone
		data => Data12
		);
		
	t13 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(13),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(2658,14), -- use pitch to modulate tone
		data => Data13
		);
		
	t14 : tone
	PORT MAP(
	    BTNU => BTNU,
	    SWITCH => SW(14),
	    BTNC => BTNC,
		clk => audio_clk, -- instance a tone module
		pitch => to_unsigned(2816,14), -- use pitch to modulate tone
		data => Data14
		);
		
    data_L <= data0+data1+data2+data3+data4+data5+data6+data7+data8+data9+data10+data11+data12+data13+data14;
    data_R <= data_L; -- duplicate data on right channel
    
END Behavioral;
