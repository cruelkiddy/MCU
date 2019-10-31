library verilog;
use verilog.vl_types.all;
entity MCU2_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        exINT           : in     vl_logic;
        portIn          : in     vl_logic_vector(15 downto 0);
        rst             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end MCU2_vlg_sample_tst;
