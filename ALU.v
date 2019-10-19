module ALU(funcSelect, ar, br, dataAcc, carry);
    
    input[3:0] funcSelect;
    input[15:0] ar;
    input[15:0] br;
    output reg[31:0] dataAcc;
    output reg carry;

    reg[31:0] result;       ///< Bit 16 is carry bit 
    
    always@(*) begin
        case (funcSelect)
            4'b0001: begin 
                result <= ar + br; 
                dataAcc <= result[15:0]; 
                carry <= result[16]; 
            end
            4'b0010: begin 
                result <= ar - br; 
                dataAcc <= result[15:0]; 
                carry <= result[16]; 
            end
            4'b0011: begin 
                result <= ar * br; 
                dataAcc <= result; 
                carry <= 0; 
            end
            4'b0100: begin 
                result <= ar / br; 
                dataAcc <= result; 
                carry <= 0; 
            end
            4'b0101: begin 
                result <= ar & br; 
                dataAcc <= result[15:0]; 
                carry <= 0; 
            end
            4'b0110: begin 
                result <= ar | br; 
                dataAcc <= result[15:0]; 
                carry <= 0; 
            end
            4'b0111: begin 
                result <= ~ar; 
                dataAcc <= result[15:0]; 
                carry <= 0; 
            end
            4'b1000: begin 
                result <= ar << br; 
                dataAcc <= result[15:0]; 
                carry <= 0; 
            end
            4'b1001: begin 
                result <= ar >> br; 
                dataAcc <= result[15:0]; 
                carry <= 0; 
            end 

            default: begin result <= 0; carry <= 0; end
        endcase
    end


endmodule // ALU