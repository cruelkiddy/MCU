library verilog;
use verilog.vl_types.all;
entity MCU2 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        portIn          : in     vl_logic_vector(15 downto 0);
        exINT           : in     vl_logic;
        portOut         : out    vl_logic_vector(15 downto 0);
        Macc            : out    vl_logic_vector(15 downto 0);
        MaccH           : out    vl_logic_vector(15 downto 0);
        testout         : out    vl_logic_vector(15 downto 0);
        TimerValuePort  : out    vl_logic_vector(15 downto 0);
        INTtestout      : out    vl_logic;
        INTRPort        : out    vl_logic_vector(15 downto 0);
        McodeOut        : out    vl_logic_vector(15 downto 0);
        RomAddrPort     : out    vl_logic_vector(7 downto 0);
        OneRamData      : out    vl_logic_vector(15 downto 0);
        ram_r           : out    vl_logic;
        ram_w           : out    vl_logic;
        ram_addr        : out    vl_logic_vector(7 downto 0);
        PinOut          : out    vl_logic
    );
end MCU2;
