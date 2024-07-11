library ieee;
use ieee.std_logic_1164.all;

entity DSP48E2 is
    generic (
        ACASCREG : integer := 1;    -- In conjunction with AREG, selects the number of A input
                                    -- registers on the A cascade path, ACOUT. This attribute
                                    -- must be equal to or one less than the AREG value:
                                    -- Register Control Attributes
                                    -- ACASCREG
                                    -- AREG = 0: ACASCREG must be 0
                                    -- AREG = 1: ACASCREG must be 1
                                    -- AREG = 2: ACASCREG can be 1 or 2

        ADREG : integer := 1;       -- Selects the number of AD pipeline registers.

        ALUMODEREG : integer := 1;  --  Selects the number of ALUMODE input registers.

        AREG : integer := 1;        -- Selects the number of A input registers to the X
                                    -- multiplexer to the ALU. When 1 is selected, the A2
                                    -- register is used. Used in conjunction with INMODE[0] for
                                    -- the multiplier and ACASCREG for the cascade path.

        BCASCREG : integer := 1;    -- In conjunction with BREG, selects the number of B input
                                    -- registers on the B cascade path, BCOUT. This attribute
                                    -- must be equal to or one less than the BREG value:
                                    -- BREG = 0: BCASCREG must be 0
                                    -- BREG = 1: BCASCREG must be 1
                                    -- BREG = 2: BCASCREG can be 1 or 2

        BREG : integer := 1;        -- Selects the number of B input registers to the X
                                    -- multiplexer to the ALU. When 1 is selected, the B2
                                    -- register is used. Used in conjunction with INMODE[4] for
                                    -- the multiplier and BCASCREG for the cascade path.

        CARRYINREG : integer := 1;  -- Selects the number of CARRYIN input registers.

        CARRYINSELREG   : integer := 1;     -- Selects the number of CARRYINSEL input registers.
        
        CREG : integer := 1;        -- Selects the number of C input registers.

        DREG : integer := 1;        -- Selects the number of D input registers.

        INMODEREG : integer := 1;   -- Selects the number of INMODE input registers.

        MREG : integer := 1;        -- Selects the number of M pipeline registers.

        OPMODEREG : integer := 1;   -- Selects the number of OPMODE input registers.
                                    -- PREG : integer := 1;    -- Selects the number of P output registers (also used by
                                    -- CARRYOUT/ PATTERNDETECT/ PATTERNBDETECT /
                                    -- OVERFLOW / UNDERFLOW / XOROUT /
                                    -- CARRYCASCOUT/ MULTSIGNOUT, and PCOUT.).

        A_INPUT : string := "DIRECT";   -- Selects the A input between parallel input (DIRECT) or
                                        -- the cascaded input from the previous slice (CASCADE).

        B_INPUT : string := "DIRECT";   -- Selects the B input between parallel input (DIRECT) or
                                        -- the cascaded input from the previous slice (CASCADE).

        PREADDINSEL : string := "A";    -- Selects the input to be added with D in the preadder.

        AMULTSEL : string := "A";   -- Selects the input to the 27-bit A input of the multiplier.
                                    -- In the 7 series primitive DSP48E1 the attribute is called
                                    -- USE_DPORT, but has been renamed due to new
                                    -- pre-adder flexibility enhancements (default
                                    -- AMULTSEL = A is equivalent to USE_DPORT=FALSE).

        BMULTSEL : string := "B";   -- Selects the input to the 18-bit B input of the multiplier.

        USE_MULT : string := "MULTIPLY";    -- Selects usage of the multiplier. Set to NONE to save
                                            -- power when using only the Adder/Logic Unit.
                                            -- The DYNAMIC setting indicates that the user is switching
                                            -- between A*B and A:B operations on the fly and therefore
                                            -- needs to get the worst-case timing of the two paths.

        RND : bit_vector(47 downto 0) := "000000000000000000000000000000000000000000000000";    -- This 48-bit value is used as the Rounding Constant into
                                                                                                -- the WMUX.

        USE_SIMD : string := "ONE48";       -- Selects the mode of operation for the adder/subtracter.
                                            -- The attribute setting can be one 48-bit adder mode
                                            -- (ONE48), two 24-bit adder mode (TWO24), or four 12-bit
                                            -- adder mode (FOUR12). Selecting ONE48 mode is
                                            -- compatible with Virtex-6 devices DSP48 operation and is
                                            -- not actually a true SIMD mode. Typical Multiply-Add
                                            -- operations are supported when the mode is set to
                                            -- ONE48.
                                            -- When either TWO24 or FOUR12 mode is selected, the
                                            -- multiplier must not be used, and USE_MULT must be set
                                            -- to NONE

        USE_WIDEXOR : string := "FALSE";    -- Determines whether the Wide XOR is used or not used.

        XORSIMD : string := "XOR24_48_96";  -- Selects the mode of operation for the Wide XOR. The
                                            -- attribute setting can be one 96-bit, two 48-bit and four
                                            -- 24-bit XOR mode (XOR24_48_96), or eight 12-bit XOR
                                            -- mode (XOR12).

        AUTORESET_PATDET : string := "NO_RESET";    -- Automatically resets the P Register (accumulated value
                                                    -- or counter value) on the next clock cycle, if a pattern
                                                    -- detect event has occurred on this clock cycle. The
                                                    -- RESET_MATCH and RESET_NOT_MATCH settings
                                                    -- distinguish between whether the DSP48E2 slice should
                                                    -- cause an auto reset of the P Register on the next cycle:
                                                    -- • if the pattern is matched
                                                    -- or
                                                    -- • whenever the pattern is not matched on the current
                                                    -- cycle but was matched on the previous clock cycle

        AUTORESET_PRIORITY : string := "RESET";     -- When using the AUTORESET_PATDET feature, if the
                                                    -- attribute is set to CEP, the P Register will only reset
                                                    -- pending the value of the clock enable. Otherwise, the
                                                    -- autoreset will have precedence.

        MASK : bit_vector(47 downto 0) := "001111111111111111111111111111111111111111111111";   -- This 48-bit value is used to mask out certain bits during
                                                                                                -- a pattern detection. When a MASK bit is set to 1, the
                                                                                                -- corresponding pattern bit is ignored. When a MASK bit
                                                                                                -- is set to 0, the pattern bit is compared.

        PATTERN : bit_vector(47 downto 0) := "000000000000000000000000000000000000000000000000";    -- This 48-bit value is used in the pattern detector.

        SEL_MASK : string := "MASK";    -- Selects the mask to be used for the pattern detector. The
                                        -- C and MASK settings are for standard uses of the pattern
                                        -- detector (counter, overflow detection, etc.).
                                        -- ROUNDING_MODE1 (C-bar left shifted by 1) and
                                        -- ROUNDING_MODE2 (C-bar left shifted by 2) select
                                        -- special masks based off of the optionally registered C
                                        -- input. These rounding modes can be used to implement
                                        -- convergent rounding in the DSP48E2 slice using the
                                        -- pattern detector.

        SEL_PATTERN : string := "PATTERN";  -- Selects the input source for the pattern field. The input
                                            -- source can either be a 48-bit dynamic “C” input or a
                                            -- 48-bit static attribute field.

        USE_PATTERN_DETECT : string := "NO_PATDET"; -- Selects whether the pattern detector and related
                                                    -- features are used (PATDET) or not used (NO_PATDET).
                                                    -- This attribute is used for speed specification and
                                                    -- Simulation Model purposes only.

        IS_ALUMODE_INVERTED : bit_vector(3 downto 0) := "0000"; -- Indicates if the ALUMODE[3:0] is optionally inverted
                                                                -- within the DSP slice. The default 4’b0000 indicates that
                                                                -- all bits of the ALUMODE bus are not inverted. Each
                                                                -- attribute bit controls its respective bit of the ALUMODE
                                                                -- bus.

        IS_CARRYIN_INVERTED : bit := '0';   -- Indicates if the CARRYIN is optionally inverted within the
                                            -- DSP slice. The default 1’b0 indicates that the CARRYIN is
                                            -- not inverted.

        IS_CLK_INVERTED : bit := '0';   -- Indicates if the CLK is optionally inverted within the DSP
                                        -- slice. The default 1’b0 indicates that the CLK is not
                                        -- inverted.

        IS_INMODE_INVERTED : bit_vector(4 downto 0) := "00000"; -- Indicates if the INMODE[4:0] is optionally inverted within
                                                                -- the DSP slice. The default 5’b00000 indicates that all the
                                                                -- bits of the INMODE bus are not inverted. Each Attribute
                                                                -- bit controls its respective bit of the INMODE bus.

        IS_OPMODE_INVERTED : bit_vector(8 downto 0) := "000000000"; -- Indicates if the OPMODE[8:0] is optionally inverted
                                                                    -- within the DSP slice. The default 9’b000000000 indicates
                                                                    -- that all the bits of the OPMODE bus are not inverted.
                                                                    -- Each attribute bit controls its respective bit of the
                                                                    -- OPMODE bus.

        IS_RSTA_INVERTED : bit := '0';  -- Indicates if the RSTA is optionally inverted within the
                                        -- DSP slice. The default 1’b0 indicates that the RSTA is not
                                        -- inverted.

        IS_RSTALLCARRYIN_INVERTED : bit:= '0';  -- Indicates if the RSTALLCARRYIN is optionally inverted
                                                -- within the DSP slice. The default 1’b0 indicates that the
                                                -- RSTALLCARRYIN is not inverted.

        IS_RSTALUMODE_INVERTED : bit := '0';    -- Indicates if the RSTALUMODE is optionally inverted
                                                -- within the DSP slice. The default 1’b0 indicates that the
                                                -- RSTALUMODE is not inverted.

        IS_RSTB_INVERTED : bit := '0';  -- Indicates if the RSTB is optionally inverted within the
                                        -- DSP slice. The default 1’b0 indicates that the RSTB is not
                                        -- inverted.

        IS_RSTC_INVERTED : bit := '0';  -- Indicates if the RSTC is optionally inverted within the
                                        -- DSP slice. The default 1’b0 indicates that the RSTC is not
                                        -- inverted.

        IS_RSTCTRL_INVERTED : bit := '0';   -- Indicates if the RSTCTRL is optionally inverted within the
                                            -- DSP slice. The default 1’b0 indicates that the RSTCTRL is
                                            -- not inverted.

        IS_RSTD_INVERTED : bit := '0';  -- Indicates if the RSTD is optionally inverted within the
                                        -- DSP slice. The default 1’b0 indicates that the RSTD is not
                                        -- inverted.

        IS_RSTINMODE_INVERTED : bit := '0';     -- Indicates if the RSTINMODE is optionally inverted within
                                                -- the DSP slice. The default 1’b0 indicates that the
                                                -- RSTINMODE is not inverted.

        IS_RSTM_INVERTED : bit := '0';  -- Indicates if the RSTM is optionally inverted within the
                                        -- DSP slice. The default 1’b0 indicates that the RSTM is not
                                        -- inverted.

        IS_RSTP_INVERTED : bit := '0'  -- Indicates if the RSTP is optionally inverted within the
                                        -- DSP slice. The default 1’b0 indicates that the RSTP is not
                                        -- inverted.

    );
    port(
        A : in std_logic_vector(29 downto 0);   -- A[26:0] is the A input of the multiplier or the pre-adder. A[29:0]
                                                -- are the most significant bits (MSBs) of the A:B concatenated input
                                                -- to the second-stage adder/subtracter or logic function.

        B : in std_logic_vector(17 downto 0);   -- The B input of the multiplier. B[17:0] are the least significant bits
                                                -- (LSBs) of the A:B concatenated input to the second-stage
                                                -- adder/subtracter or logic function.

        C : in std_logic_vector(47 downto 0);   -- Data input to the second-stage adder/subtracter, pattern
                                                -- detector, or logic function.

        D : in std_logic_vector(26 downto 0);   -- 27-bit data input to the pre-adder or alternative input to the
                                                -- multiplier. The pre-adder implements D + A as determined by the
                                                -- INMODE3 signal.

        OPMODE : in std_logic_vector(8 downto 0);   -- Controls the input to the W, X, Y, and Z multiplexers in the
                                                    -- DSP48E2 slice.

        ALUMODE : in std_logic_vector(3 downto 0);  -- Controls the selection of the logic function in the DSP48E2 slice.

        CARRYIN : in std_logic;                 -- Carry input from the logic.

        CARRYINSEL : in std_logic_vector(2 downto 0);   -- Selects the carry source.

        INMODE : in std_logic_vector(4 downto 0);   -- These five control bits select the functionality of the pre-adder,
                                                    -- the A, B, and D inputs, and the input registers. These bits should
                                                    -- be tied to GND if unused.

        CEA1 : in std_logic;    -- Clock enable for the first A (input) register. A1 is only used if
                                -- AREG = 2 or INMODE[0] = 1.

        CEA2 : in std_logic;    -- Clock enable for the second A (input) register. A2 is only used if
                                -- AREG = 1 or 2 and INMODE[0] = 0.

        CEB1 : in std_logic;    -- Clock enable for the first B (input) register. B1 is only used if BREG
                                -- = 2 or INMODE[4] = 1.

        CEB2 : in std_logic;    -- Clock enable for the second B (input) register. B2 is only used if
                                -- BREG = 1 or 2 and INMODE[4] = 0.

        CEC : in std_logic;     -- Clock enable for the C (input) register.

        CED : in std_logic;     -- Clock enable for the D (input) register.

        CEM : in std_logic;     -- Clock enable for the post-multiply M (pipeline) register and the
                                -- internal multiply round CARRYIN register.

        CEP : in std_logic;     -- Clock enable for the P (output) register.

        CEAD : in std_logic;    -- Clock enable for the pre-adder output AD pipeline register.

        CEALUMODE : in std_logic;   -- Clock enable for ALUMODE (control inputs) registers.

        CECTRL : in std_logic;      -- Clock enable for the OPMODE and CARRYINSEL (control inputs)
                                    -- registers.

        CECARRYIN : in std_logic;   -- Clock enable for the CARRYIN (input from the logic) register.

        CEINMODE : in std_logic;    -- Clock enable for the INMODE control input registers.

        RSTA : in std_logic;    -- Reset for both A (input) registers.

        RSTB : in std_logic;    -- Reset for both B (input) registers.

        RSTC : in std_logic;    -- Reset for the C (input) register.

        RSTD : in std_logic;    -- Reset for the D (input) register and for the pre-adder (output) AD
                                -- pipeline register.

        RSTM : in std_logic;    -- Reset for the M (pipeline) register.

        RSTP : in std_logic;    -- Reset for the P (output) register.

        RSTCTRL : in std_logic; -- Reset for OPMODE and CARRYINSEL (control inputs) registers.

        RSTALLCARRYIN : in std_logic;   -- Reset for the Carry (internal path) and the CARRYIN register.

        RSTALUMODE : in std_logic;  -- Reset for ALUMODE (control inputs) registers.

        RSTINMODE : in std_logic;   -- Reset for the INMODE (control input) registers.

        CLK : in std_logic;     -- The DSP48E2 input clock, common to all internal registers and
                                -- flip-flops.

        ACIN : in std_logic_vector(29 downto 0);    -- Cascaded data input from ACOUT of previous DSP48E2 slice
                                                    -- (muxed with A).

        BCIN : in std_logic_vector(17 downto 0);    -- Cascaded data input from BCOUT of previous DSP48E2 slice
                                                    -- (muxed with B).

        PCIN : in std_logic_vector(47 downto 0);    -- Cascaded data input from PCOUT of previous DSP48E2 slice to
                                                    -- adder.

        CARRYCASCIN : in std_logic;     -- Cascaded carry input from CARRYCASCOUT of previous DSP48E2
                                        -- slice.

        MULTSIGNIN : in std_logic;      -- Sign of the multiplied result from the previous DSP48E2 slice for
                                        -- MACC extension.

        ACOUT : out std_logic_vector(29 downto 0);  -- Cascaded data output to ACIN of next DSP48E2 slice.

        BCOUT : out std_logic_vector(17 downto 0);  -- Cascaded data output to BCIN of next DSP48E2 slice.

        PCOUT : out std_logic_vector(47 downto 0);  -- Cascaded data output to PCIN of next DSP48E2 slice.

        P : out std_logic_vector(47 downto 0);  -- Data output from second stage adder/subtracter or logic
                                                -- function.

        CARRYOUT : out std_logic_vector(3 downto 0);    -- 4-bit carry output from each 12-bit field of the
                                                        -- accumulate/adder/logic unit. Normal 48-bit operation uses only
                                                        -- CARRYOUT3. SIMD operation can use four carry out bits
                                                        -- (CARRYOUT[3:0]).
                                                        
        CARRYCASCOUT : out std_logic;   -- Cascaded carry output to CARRYCASCIN of next DSP48E2 slice.
                                        -- This signal is internally fed back into the CARRYINSEL multiplexer
                                        -- input of the same DSP48E2 slice.

        MULTSIGNOUT : out std_logic;    -- Sign of the multiplied result cascaded to the next DSP48E2 slice
                                        -- for MACC extension.

        PATTERNDETECT : out std_logic;  -- Match indicator between P[47:0] and the complement of the
                                        -- pattern.

        PATTERNBDETECT : out std_logic; -- Match indicator between P[47:0] and the complement of the
                                        -- pattern.

        OVERFLOW : out std_logic;   -- Overflow indicator when used with the appropriate setting of the
                                    -- pattern detector.

        UNDERFLOW : out std_logic;  -- Underflow indicator when used with the appropriate setting of
                                    -- the pattern detector.
                                    
        XOROUT : out std_logic_vector(7 downto 0)   -- Wide XOR outputs, based on XORSIMD attribute.
    );
end entity;

architecture arch_DSP48E2 of DSP48E2 is

    component DUAL_A_D_PREADDER is
        port(
            clk : in std_logic;
            A : in std_logic_vector(29 downto 0);
            ACIN : in std_logic_vector(29 downto 0);
            D : in std_logic_vector(26 downto 0);
            CEA1 : in std_logic;
            CEA2 : in std_logic;
            CED : in std_logic;
            CEAD : in std_logic;
            RSTA : in std_logic;
            RSTD : in std_logic;
            INMODE : in std_logic_vector(3 downto 0);
            ACOUT : out std_logic_vector(29 downto 0);
            XMUX : out std_logic_vector(29 downto 0);
            AMULT : out std_logic_vector(26 downto 0)
        );      
    end component;


    component DUAL_B_REGISTER is
        port(
            clk : in std_logic;
            B : in std_logic_vector(17 downto 0);
            BCIN : in std_logic_vector(17 downto 0);
            BCOUT : out std_logic_vector(17 downto 0);
            XMUX : out std_logic_vector(17 downto 0);
            BMULT : out std_logic_vector(17 downto 0);
    
            CEB1 : in std_logic;
            RSTB : in std_logic;
            CEB2 : in std_logic;
            INMODE :  in std_logic_vector(4 downto 0);
        );
    end component;

    component MULT_25x18 is
        port(
            clk : in std_logic;
            input_1 : in std_logic_vector(24 downto 0);
            input_2 : in std_logic_vector(17 downto 0);
            output : out std_logic_vector(47 downto 0)
        );
    end component;

signal AMULT : std_logic_vector(24 downto 0);

signal INMODE_4 : std_logic_vector(3 downto 0);
signal INMODE_1 : std_logic;

signal BCOUT : std_logic_vector(17 downto 0);
signal XMUX : std_logic_vector(17 downto 0);
signal BMULT : std_logic_vector(17 downto 0);

begin

impl_DUAL_A_D_PREADDER :  DUAL_A_D_PREADDER 
        port map(
            clk => clk,
            A => A,
            ACIN => ACIN,
            D => D,
            CEA1 => CEA1,
            CEA2 => CEA2,
            CED => CED,
            CEAD => CEAD,
            RSTA => RSTA,
            RSTD => RSTD,
            INMODE => INMODE_4,
            ACOUT => ACOUT,
            XMUX => XMUX,
            AMULT => AMULT
        );      


    INMODE_4 <= INMODE(4 downto 0);
    INMODE_1 <= INMODE(5);

impl_DUAL_B_REGISTER : DUAL_B_REGISTER 
        port map(
            clk => clk,
            B => B,
            BCIN => BCIN,
            BCOUT => BCOUT,
            XMUX => XMUX,
            BMULT => BMULT,
    
            CEB1 => CEB1,
            RSTB => RSTB,
            CEB2 => CEB2,
            INMODE => INMODE_1;
        );

impl_MULT_25x18 : MULT_25x18 is
        port map (
            clk => clk,
            input_1 => BMULT,
            input_2 => AMULT,
            output => 
        );

end architecture;