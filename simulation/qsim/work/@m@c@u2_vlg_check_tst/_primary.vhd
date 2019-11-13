library verilog;
use verilog.vl_types.all;
entity MCU2_vlg_check_tst is
    port(
        PinOut          : in     vl_logic;
        drive           : in     vl_logic_vector(31 downto 0);
        portOut         : in     vl_logic_vector(15 downto 0);
        sampler_rx      : in     vl_logic
    );
end MCU2_vlg_check_tst;
