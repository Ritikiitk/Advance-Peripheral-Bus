interface apb_if(input logic PCLK, PRESETn);
	logic [31:0]PADDR;
	logic PWRITE;
	logic PSEL;
	logic PENABLE;
	logic [31:0]PWDATA;
	logic PREADY;
	logic [31:0]PRDATA;
endinterface