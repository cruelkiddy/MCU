module timer
#(
    parameter timerwid = 16
)
(
    input clk,
    input cs,
    input wr,
    input start,
    input rd,
    input [timerwid - 1 : 0] datain,
    output reg intrup,
    output reg [timerwid - 1 : 0] dataout,
    input clearFlag
);
    reg [timerwid - 1 : 0] realTimer;

    always@(posedge clearFlag) 
        intrup <= 0;

    always@(posedge clk) begin
        if(cs) begin    
            if (start) begin

                if(realTimer == 16'hffff) begin
                    intrup <= 1'b1;
                    realTimer <= datain;
                end

                else
                    realTimer <= realTimer + 1'b1;
            end
            else begin
                if(wr)
                    realTimer <= datain;
                else
                    realTimer <= realTimer;
            end

            if(rd)
                dataout <= realTimer;
        end
    end



endmodule