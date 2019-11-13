module bit4Tube(
    input [3:0] bit4data,
    output reg [7:0] drive
);
    always@(*) begin
        case(bit4data)

            4'd0: begin
                drive[0] <= 0;
                drive[1] <= 0;
                drive[2] <= 0;
                drive[3] <= 0;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 1;
                drive[7] <= 1;
            end

            4'd1:begin
                drive[0] <= 1;
                drive[1] <= 1;
                drive[2] <= 1;
                drive[3] <= 1;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 1;
                drive[7] <= 1;                
            end

            4'd2:begin
                drive[0] <= 0;
                drive[1] <= 0;
                drive[2] <= 1;
                drive[3] <= 0;
                drive[4] <= 0;
                drive[5] <= 1;
                drive[6] <= 0;
                drive[7] <= 1;                
            end

            4'd3:begin
                drive[0] <= 0;
                drive[1] <= 0;
                drive[2] <= 0;
                drive[3] <= 0;
                drive[4] <= 1;
                drive[5] <= 1;
                drive[6] <= 0;
                drive[7] <= 1;            
            end

            4'd4:begin
                drive[0] <= 1;
                drive[1] <= 0;
                drive[2] <= 0;
                drive[3] <= 1;
                drive[4] <= 1;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                
            end

            4'd5:begin
                drive[0] <= 0;
                drive[1] <= 1;
                drive[2] <= 0;
                drive[3] <= 0;
                drive[4] <= 1;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                
            end

            4'd6:begin
                drive[0] <= 0;
                drive[1] <= 1;
                drive[2] <= 0;
                drive[3] <= 0;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                
            end

            4'd7:begin
                drive[0] <= 0;
                drive[1] <= 0;
                drive[2] <= 0;
                drive[3] <= 1;
                drive[4] <= 1;
                drive[5] <= 1;
                drive[6] <= 1;
                drive[7] <= 1;                
            end

            4'd8:begin
                drive[0] <= 0;
                drive[1] <= 0;
                drive[2] <= 0;
                drive[3] <= 0;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                
            end

            4'd9:begin
                drive[0] <= 0;
                drive[1] <= 0;
                drive[2] <= 0;
                drive[3] <= 1;
                drive[4] <= 1;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                
            end

            4'd10:begin
                drive[0] <= 0;
                drive[1] <= 0;
                drive[2] <= 0;
                drive[3] <= 1;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                
            end

            4'd11:begin
                drive[0] <= 1;
                drive[1] <= 1;
                drive[2] <= 0;
                drive[3] <= 0;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                 
            end

            4'd12:begin
                drive[0] <= 0;
                drive[1] <= 1;
                drive[2] <= 1;
                drive[3] <= 0;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 1;
                drive[7] <= 1;                 
            end

            4'd13:begin
                drive[0] <= 1;
                drive[1] <= 0;
                drive[2] <= 0;
                drive[3] <= 0;
                drive[4] <= 0;
                drive[5] <= 1;
                drive[6] <= 0;
                drive[7] <= 1;                 
            end

            4'd14:begin
                drive[0] <= 0;
                drive[1] <= 1;
                drive[2] <= 1;
                drive[3] <= 1;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                 
            end

            4'd15:begin
                drive[0] <= 0;
                drive[1] <= 1;
                drive[2] <= 1;
                drive[3] <= 1;
                drive[4] <= 0;
                drive[5] <= 0;
                drive[6] <= 0;
                drive[7] <= 1;                 
            end
        endcase

    end


endmodule // bit4Tube


module NixieTube(
    input [15:0] data,
    output [31:0]bit16drive
);

    bit4Tube tl1(data[15:12], bit16drive[7:0]);
    bit4Tube tl2(data[11:8], bit16drive[15:8]);
    bit4Tube tl3(data[7:4], bit16drive[23:16]);
    bit4Tube tl4(data[3:0], bit16drive[31:24]);


endmodule // NixieTube


