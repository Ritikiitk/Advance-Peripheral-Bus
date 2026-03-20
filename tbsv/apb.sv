module apb(
    input  logic        PCLK,
    input  logic        PRESETn,
    input  logic [31:0] PADDR,
    input  logic        PWRITE,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    output logic        PREADY,
    output logic [31:0] PRDATA
);
//APB protocol with wait state logic 
logic [31:0] mem [63:0];
logic [2:0] cnt;

parameter WAIT = 2;

typedef enum logic [1:0] {IDLE, SETUP, ACCESS} apb_state;
apb_state state, next_state;


// State Register

always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)
        state <= IDLE;
    else
        state <= next_state;
end


    always @(*) begin
        next_state = state;
        case (state)
            IDLE:   if (PSEL && !PENABLE)   next_state = SETUP;
            SETUP:  if (PSEL &&  PENABLE)   next_state = ACCESS;
            ACCESS: if (!PSEL)              next_state = IDLE;
                    else                    next_state = SETUP;
            default: next_state = IDLE;
        endcase
    end

//WAIT LOGIc
always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn)			cnt <= 0;

  else if (PSEL && PENABLE) begin
        if (cnt < WAIT)		 cnt <= cnt + 1;
        else		         cnt <= 0;        
        end
    else
        cnt <= 0;
end
  assign PREADY = (cnt == WAIT);


always @(posedge PCLK) begin
  if (PREADY && PWRITE)
        mem[PADDR[7:2]] <= PWDATA;
end


always @(*) begin
    if ( PREADY && !PWRITE)
        PRDATA = mem[PADDR[7:2]];
   // else
     //   PRDATA = 32'b0;
end

endmodule