module controller(
    input clk,
    input rst,
    input [15:0] ProgramCode,                    ///< Program from ROM
    input [15:0] ramData,
    output reg rom_cs,
    output reg re,                          ///< Enable read from ROM
    output reg ram_cs,
    output reg ram_re,
    output reg ram_we,
    output reg [7:0] ram_addr,
    output reg [15:0] ram_data_in,
    output reg [15:0] ram_data_out,
    output reg [3:0] functionSelect,
    output reg [15:0] portOut,
    output reg [15:0] codeOut,              ///< Test Port to see Program Code
    output reg [7:0] addr,                  ///< Program Counter
    input [31:0] dataACC,              ///< Store Result
    output reg [15:0] arin,
    output reg [15:0] brin
);
    parameter IDLE=0, State1=1,
              State2=2, State3=3, 
              State4=4, State5=5,
              State6=6, State7=7,
              State8=8, State9=9,
              State21=21,
              State22=22, State23=23,
              State24=24, State25=25,
              State26=26, State27=27; 
    
    reg[4:0] CurrentState = IDLE;
    reg[7:0] ProgramCounter;
    reg[15:0] hacc; 

    reg[15:0] romReg;
    wire[2:0] ControlSelect;
    wire[3:0] FuntionSelect;

    wire[31:0] ar32, br32;  


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
           ram_data_in <= 0;
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
                    CurrentState <= State4;
                    rom_cs <= 0;
                    re <= 0;
                    case(ControlSelect)
                        3'b000:CurrentState <= State4;///< Arithmetic & Logic Operation
                        3'b001:CurrentState <= State8;///< Memory Operation
                        3'b011:CurrentState <= 5'd21; ///< TODO HERE!
                        default:CurrentState <= 5'd24;///< TODO HERE!
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
                    CurrentState <= IDLE;
                    arin <= dataACC[15:0];
                    hacc <= dataACC[31:16];
                    ProgramCounter <= ProgramCounter + 1'b1;
                end
                State8:begin
                    CurrentState <= State9;
                    case(FuntionSelect)
                        4'b0101:arin <= romReg[7:0];
                        4'b1101:brin <= romReg[7:0];
                    endcase
                end
                State9:begin
                    CurrentState <= State24;
                end
                State21:begin
                    CurrentState <= State22;
                    case(FuntionSelect)
                        4'b0000:arin <= ProgramCode;
                        4'b0001:portOut <= arin;
                    endcase
                end
                State22:begin
                    CurrentState <= State23;
                end
                State23:begin
                    CurrentState <= IDLE;
                    ProgramCounter <= ProgramCounter + 1'b1;
                end
                State24:begin
                    CurrentState <= State25;
                end
                State25:begin
                    CurrentState <= State26;
                end
                State26:begin
                    CurrentState <= State27;
                end
                State27:begin
                    CurrentState <= IDLE;
                    ProgramCounter <= ProgramCounter + 1'b1;
                end     
                default:CurrentState <= IDLE; 
            endcase                                          
        end
    end



endmodule // 