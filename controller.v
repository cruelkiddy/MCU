module controller(
    input clk,
    input rst,
    input [15:0] ProgramCode,               ///< Program from ROM
    input [15:0] ramData,
    input [15:0] portIn,                    ///< For port operation
    input timer_INT,
    input EXT_INT,
    input [15:0] timer_value, 
    output reg rom_cs,
    output reg re,                          ///< Enable read from ROM
    output reg ram_cs,
    output reg ram_re,
    output reg ram_we,
    output timer_cs,
    output timer_wr,
    output timer_start,
    output timer_rd,
    output reg [15:0] timer_datain,
    output reg [7:0] ram_addr,
//  output reg [15:0] ram_data_in,
    output reg [15:0] ram_data_out,
    output reg [3:0] functionSelect,
    output reg [15:0] portOut,
    output reg [15:0] codeOut,              ///< Test Port to see Program Code
    output reg [7:0] addr,                  ///< Program Counter
    input [31:0] dataACC,                   ///< Store Result
    output reg [15:0] arin,
    output reg [15:0] brin,
    output reg PinOut
);
    parameter IDLE=0, State1=1,
              State2=2, State3=3, 
              State4=4, State5=5,
              State6=6, State7=7,
              State8=8, State9=9,
              State21=21,
              State22=22, State23=23,
              State24=24, State25=25,
              State26=26, State27=27,

              TState0 = 28, TState1 = 29,

              PState0 = 30, PState1 = 31,
              PState2 = 32, PState3 = 33,
              CheckINT = 34, PINT = 35,
              NBranch0 = 36, NBranch1 = 37,
              NBranch2 = 38, NBranch3 = 39,
              NBranch4 = 40, NBranch5 = 41;

    parameter rom_E0 = 8'b11110000; ///< Timer INT Entrance
    parameter rom_F0 = 8'b10101010; ///< External INT Entrance

    
    reg[4:0] CurrentState = IDLE;
    reg[7:0] ProgramCounter;
    reg[15:0] hacc; 

    reg[15:0] romReg;
    wire[2:0] ControlSelect;
    wire[3:0] FuntionSelect;

    wire[31:0] ar32, br32;  

    ///< Registers Concerning INTERRUPT
    reg [15:0] TC;   ///< Timer Controll Register, TC[3]: cs;  TC[2]: wr; TC[1]: start;TC[0]: rd
    reg [15:0] INTR; ///< INTERRUPT Register,      INTR[15]: always allow, INTR[9]: allow timer(?),  
                     ///<                          INTR[8]: allow external INT, INTR[1]: timer request, 
                     ///<                          INTR[0]: external request
    reg [7:0] pcSave;///< Save Program Counter before processing Interrupt


    ///< TODO: Turn Down Interrupt Signal when Request Flag has been
    ///< Do this in Interrupt Service Routine
    always@(*) begin
        if(INTR[15] & INTR[9] & timer_INT)
            INTR[1] <= 1'b1;
        else
            INTR[1] <= 0;
        if(INTR[15] & INTR[8] & EXT_INT)
            INTR[0] <= 1'b1;    
        else
            INTR[0] <= 0; 
    end

    ///< Control by TC
    assign timer_cs = TC[3];
    assign timer_wr = TC[2];
    assign timer_start = TC[1];
    assign timer_rd = TC[0];


    assign ControlSelect = romReg[15:13];
    assign FuntionSelect = romReg[11:8];
    assign ar32 = arin;
    assign br32 = brin;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
           CurrentState <= IDLE;
           ProgramCounter <= 0;
           re <= 0;
           ram_addr <= 0;
           ram_cs <= 0;

           ram_data_out <= 0;
           ram_re <= 0;
           ram_we <= 0;
           rom_cs <= 0;
           arin <= 0;
           brin <= 0;
           functionSelect <= 0;
        end
        else begin
            case (CurrentState)

                CheckINT:begin  
                    if(INTR[15] & INTR[9] & INTR[1]) begin ///< Check INT
                        pcSave <= ProgramCounter;
                    end

                    if(INTR[15] & INTR[8] & INTR[0]) 
                        pcSave <= ProgramCounter;

                    CurrentState <= PINT;
                end

                PINT:begin
                    if(INTR[15] & INTR[9] & INTR[1]) begin
                        ProgramCounter <= rom_E0;
                    end
                    if(INTR[15] & INTR[8] & INTR[0]) begin
                        ProgramCounter <= rom_F0;
                    end
                    CurrentState <= IDLE;
                end


                IDLE:begin
                    rom_cs <= 1'b1;
                    addr <= ProgramCounter;
                    if(ProgramCounter >= 8'b10000000)
                        CurrentState <= IDLE;
                    else
                        CurrentState <= State1;
                end

                State1:begin
                    CurrentState <= State2;
                    re <= 1'b1;
                end
                State2:begin
                    CurrentState <= State3;
                    romReg <= ProgramCode;
                    codeOut <= ProgramCode;
                end
                State3:begin
                    // CurrentState <= State4;
                    rom_cs <= 0;
                    re <= 0;
                    case(ControlSelect)
                        3'b000:CurrentState <= State4;///< Arithmetic & Logic Operation
                        3'b001:CurrentState <= State8;///< Memory Operation

                        3'b010:CurrentState <= TState0;///< Transfer Operation
                        3'b011:CurrentState <= PState0;///< Port Operation
                        3'b100:CurrentState <= NBranch0; ///< Instructions from MCU3
                        default:CurrentState <= State23;///< PC++ And Go CheckINT
                    endcase
                end
                State4:begin
                    CurrentState <= State5;
                    case(FuntionSelect)
                        4'b0001: begin ///< Perform arin + brin 
                            functionSelect <= 4'b0001;
                        end
                        4'b0011: begin ///< Perform arin * brin
                            functionSelect <= 4'b0011;
                        end
                        4'b0101: begin ///< Perform arin & brin
                            functionSelect <= 4'b0101;
                        end
                        4'b1000: begin ///< Perform ar32 << br32;
                            functionSelect <= 4'b1000;
                        end
                        4'b0100:begin  ///< Perform ar / br32
                            functionSelect <= 4'b0100;
                        end
                        4'b0010:begin ///< Perform ar - br
                            functionSelect <= 4'b0010;
                        end
                        4'b0101:begin ///< Perform ar and br
                            functionSelect <= 4'b0101;
                        end
                        4'b0110:begin ///< Perform ar or br
                            functionSelect <= 4'b0110;
                        end            
                        4'b0111:begin ///< Perform not ar 
                            functionSelect <= 4'b0111;
                        end            
                        4'b1000:begin ///< Perform ar << br
                            functionSelect <= 4'b1000;
                        end
                        4'b1001:begin ///< Perform ar >> br
                            functionSelect <= 4'b1001;
                        end                       
                        default: begin ///< Do nothing
                            functionSelect <= 0;
                        end
                    endcase
                end
                State5:begin
                    CurrentState <= State6;
                end
                State6:begin
                    CurrentState <= State7;
                end
                State7:begin
                    CurrentState <= CheckINT;
                    arin <= dataACC[15:0];
                    hacc <= dataACC[31:16];
                    ProgramCounter <= ProgramCounter + 1'b1;
                end
                State8:begin
                    CurrentState <= State9;
                    case(FuntionSelect)
                        4'b0101:arin <= romReg[7:0];
                        4'b1101:brin <= romReg[7:0];
                        4'b0000:ram_cs <= 1;
                        4'b0001:ram_cs <= 1;
                        4'b0010:arin <= brin;
                        4'b0011:brin <= arin;
                        4'b0100:arin[15:8] <= romReg[7:0];
                        4'b0101:arin[7:0] <= romReg[7:0];
                        4'b1101:brin[7:0] <= romReg[7:0];
                        4'b0110:arin <= hacc;
                    endcase
                end
                State9:begin
                    CurrentState <= State24;
                    ram_addr <= romReg[7:0];
                end
                State21:begin
                    CurrentState <= State22;
                    case(FuntionSelect)
                        4'b0000:arin <= portIn;    
                        4'b0001:portOut <= arin;
                    endcase
                end
                State22:begin
                    CurrentState <= State23;
                end
                State23:begin
                    CurrentState <= CheckINT;
                    ProgramCounter <= ProgramCounter + 1'b1;
                end
                State24:begin
                    CurrentState <= State25;
                    case(FuntionSelect)
                        4'b0000: ram_re <= 1;
                        4'b0001: ram_data_out <= arin;
                        default: begin
                            ram_re <= 0;
                            ram_data_out <= 0;
                        end
                    endcase
                end
                State25:begin
                    CurrentState <= State26;
                    case(FuntionSelect)
                        4'b0000: arin <= ramData;
                        4'b0001: ram_we <= 1;
                        default: ram_we <= 0;
                    endcase
                end
                State26:begin
                    CurrentState <= State27;
                    ram_we <= 0;
                    ram_re <= 0;
                end
                State27:begin
                    CurrentState <= CheckINT;
                    ProgramCounter <= ProgramCounter + 1'b1;
                end
                TState0:begin
                    CurrentState <= TState1;
                    case(FuntionSelect)
                        4'b0000: begin
                            if(arin == 16'd0) ProgramCounter <= romReg[7:0];
                            else ProgramCounter <= ProgramCounter + 1'b1;
                        end
                        4'b0001: begin
                            if(arin == brin) ProgramCounter <= romReg[7:0];
                            else ProgramCounter <= ProgramCounter + 1'b1;                            
                        end
                        4'b0010: begin
                            brin <= brin - 1'b1;
                            if(brin != 16'b0) ProgramCounter <= romReg[7:0];
                            else ProgramCounter <= ProgramCounter + 1'b1;                             
                        end
                        4'b0011: ProgramCounter <= romReg[7:0];
                    endcase                    
                end 
                TState1:begin
                    CurrentState <= CheckINT;
                end

                PState0:begin
                    CurrentState <= PState1;
                    case(FuntionSelect)
                        4'b0000: arin <= portIn;
                        4'b0001: portOut <= arin;
                    endcase
                end

                PState1:begin
                    ProgramCounter <= ProgramCounter + 1;
                    CurrentState <= CheckINT;
                end

                NBranch0:begin
                    CurrentState <= NBranch1;
                    case(romReg[7:0])
                        8'b00000000:begin
                            timer_datain <= arin[15:0];
                        end
                        8'b00000001:begin
                            TC <= arin[15:0];
                        end
                        8'b00000010:begin
                            arin <= timer_value;
                        end
                        8'b00001000:begin
                            INTR <= arin[15:0];
                        end
                        8'b00001001:begin
                            arin <= INTR;
                        end
                        8'b00001010:begin
                            ProgramCounter <= pcSave;
                        end
                        8'b00010000:begin
                            PinOut <= 1'b1;
                        end
                        8'b00010001:begin
                            PinOut <= 0;
                        end
                    endcase
                end
                
                NBranch1:begin
                    if(romReg[7:0] == 8'b00001010) begin
                        CurrentState <= CheckINT;
                    end
                    else begin
                        ProgramCounter <= ProgramCounter + 1'b1;
                        CurrentState <= CheckINT;
                    end
                        

                end

                default:CurrentState <= CheckINT; 
            endcase                                          
        end
    end



endmodule // 