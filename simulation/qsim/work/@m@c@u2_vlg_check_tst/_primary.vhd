library verilog;
use verilog.vl_types.all;
entity MCU2_vlg_check_tst is
    port(
        INTRPort        : in     vl_logic_vector(15 downto 0);
        INTtestout      : in     vl_logic;
        Macc            : in     vl_logic_vector(15 downto 0);
        MaccH           : in     vl_logic_vector(15 downto 0);
        McodeOut        : in     vl_logic_vector(15 downto 0);
        OneRamData      : in     vl_logic_vector(15 downto 0);
        PinOut          : in     vl_logic;
        RomAddrPort     : in     vl_logic_vector(7 downto 0);
        TimerValuePort  : in     vl_logic_vector(15 downto 0);
        portOut         : in     vl_logic_vector(15 downto 0);
        testout         : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end MCU2_vlg_check_tst;
