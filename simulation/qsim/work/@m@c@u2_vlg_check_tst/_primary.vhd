library verilog;
use verilog.vl_types.all;
entity MCU2_vlg_check_tst is
    port(
        Macc            : in     vl_logic_vector(15 downto 0);
        MaccH           : in     vl_logic_vector(15 downto 0);
        McodeOut        : in     vl_logic_vector(15 downto 0);
        PinOut          : in     vl_logic;
        portOut         : in     vl_logic_vector(15 downto 0);
        testout         : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end MCU2_vlg_check_tst;
