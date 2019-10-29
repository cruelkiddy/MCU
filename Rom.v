module Rom
#(
    parameter Width = 16,
    parameter AddrWidth = 8
)
(
	output reg [Width - 1:0] data,
	input [AddrWidth - 1:0] addr,
    input cs,
    input re
);

    reg[7:0] addrtmp;
    integer i = 0;
    // Declare the ROM variable
	reg [Width - 1:0] rom[(1<<AddrWidth) - 1:0];
    
    // Initialize the memory
    initial
        $readmemb("init.mem", rom);

    // initial begin
    //     for(addrtmp=0;addrtmp<50;addrtmp=addrtmp+5) begin
    //         rom[addrtmp] = {8'b001X0000, addrtmp};
    //         rom[addrtmp+1] = 16'b001X0011XXXXXXXX;
    //         rom[addrtmp+2] = {8'b001X0000, (addrtmp+1)};
    //         rom[addrtmp+3] = 16'b000X0001XXXXXXXX;
    //         rom[addrtmp+4] = 16'b001X0011XXXXXXXX;
    //     end
    //     rom[50] = 16'b001X000111111111;
    // end

    always@(posedge re)
        if(cs)
            data <= rom[addr];
        else
            data <= data;

endmodule
