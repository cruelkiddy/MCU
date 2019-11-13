module MCU2(
    input  clk,
    input  rst,
    input  [15:0] portIn,
    input exINT,    ///< Interrupt Pin
    output [15:0] portOut,
    output [31:0] drive,
    output PinOut   ///< Pin out    
);

    ///< Wires Linking ROM & Controller
    wire [15:0] ProgramCode;
    wire [7:0] RomAddr;
    wire RomCS;
    wire RomRE;


    ///< Wires Linking ALU & Controller 
    wire [3:0] FunctionSelect;
    wire [15:0] ar, br;
    wire [31:0] DataACC;

    ///< Test For calculate using ALU
    // assign testout = RomAddr;


    ///< Wires Linking Controller & Ram
    wire RamCS;
    wire RamRE;
    wire RamWE;
    wire [7:0] RamAddr;
    wire [15:0] DataFromRam;
    wire [15:0] DataIntoRam;

    ///< Wires Linking Controller & Timer
    wire TimerCS;
    wire TimerWR;
    wire TimerSTART;
    wire TimerRD;
    wire [15:0] TimerDataIn;
    wire TimerINT;
    wire [15:0] TimerValue;

    wire [15:0] datadisplay;

    assign datadisplay = portOut;



    Ram myRam(DataIntoRam, DataFromRam, RamAddr, RamCS, RamWE, RamRE);
    
    Rom ProgramMemory(ProgramCode, RomAddr, RomCS, RomRE);

    ALU MainALU(FunctionSelect, ar, br, DataACC);

    timer myTimer(clk, TimerCS, TimerWR, TimerSTART, TimerRD, TimerDataIn, TimerINT, TimerValue);

    controller MainController(.clk(clk),
                              .rst(rst),
                              .rom_cs(RomCS), 
                              .re(RomRE), 
                              .EXT_INT(exINT),
                              .timer_INT(TimerINT),
                              .timer_value(TimerValue),
                              .timer_cs(TimerCS),
                              .timer_wr(TimerWR),
                              .timer_start(TimerSTART),
                              .timer_rd(TimerRD),
                              .timer_datain(TimerDataIn),
                              .ProgramCode(ProgramCode), 
                              .addr(RomAddr), 
                              .dataACC(DataACC),
                              .functionSelect(FunctionSelect),
                              .arin(ar),
                              .brin(br),
                              .ramData(DataFromRam),
                              .ram_data_out(DataIntoRam),
                              .ram_cs(RamCS),
                              .ram_re(RamRE),
                              .ram_we(RamWE),
                              .portOut(portOut),
                              .PinOut(PinOut),
                              .portIn(portIn),
                              .ram_addr(RamAddr)
                             );

    NixieTube myNT(datadisplay, drive);


endmodule // MCU2