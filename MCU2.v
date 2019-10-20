module MCU2(
    input  clk,
    input  rst,
    input  [15:0] portIn,
    output [15:0] portOut,
    output [15:0] Macc,
    output [15:0] MaccH,
    output [15:0] testout,
    output [15:0] McodeOut    
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
    assign testout = DataACC[15:0];
    assign McodeOut = ProgramCode;

    ///< Wires Linking Controller & Ram
    wire RamCS;
    wire RamRE;
    wire RamWE;
    wire [7:0] RamAddr;
    wire [15:0] DataFromRam;
    wire [15:0] DataIntoRam;



    Ram myRam(DataIntoRam, DataFromRam, RamAddr, RamCS, RamWE, RamRE);
    
    Rom ProgramMemory(ProgramCode, RomAddr, RomCS, RomRE);

    ALU MainALU(FunctionSelect, ar, br, DataACC);

    controller MainController(.clk(clk),
                              .rom_cs(RomCS), 
                              .re(RomRE), 
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
                              .portOut(portOut)
                             );



endmodule // MCU2