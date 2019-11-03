module Ram
(
	input [15:0] data,
    output reg [15:0] q,
    output [15:0] test,
	input [7:0] addr,
    input cs,
	input we, 
    input re
);

	// Declare the RAM variable
	reg [15:0] ram[0:255];

    assign test = q;

    always@(posedge we) 
        if(cs)
            ram[addr] <= data;
        else
            ram[addr] <= ram[addr];

    always@(posedge re)
        if(cs)
            q <= ram[addr];
        else
            q <= q;


endmodule
