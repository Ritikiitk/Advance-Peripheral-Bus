import uvm_pkg::*;
module tb_apb;
  bit PCLK;
  bit PRESETn;
  always #5 PCLK = ~PCLK;
 
  initial begin
    PCLK =0;
    PRESETn = 0;
    vif.PSEL    = 0;
    vif.PENABLE = 0;
    vif.PWRITE  = 0;
    vif.PADDR   = 0;
    vif.PWDATA  = 0;
    #5;
    PRESETn = 1;
  end
 
  apb_if vif(PCLK, PRESETn); 
apb DUT (
    .PCLK    (vif.PCLK),
    .PRESETn (vif.PRESETn),
    .PADDR   (vif.PADDR),
    .PWRITE  (vif.PWRITE),
    .PSEL    (vif.PSEL),
    .PENABLE (vif.PENABLE),
    .PWDATA  (vif.PWDATA),
    .PREADY  (vif.PREADY),
    .PRDATA  (vif.PRDATA)
  );
 
  initial begin
    uvm_config_db#(virtual apb_if)::set(uvm_root::get(), "*", "vif", vif);
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_apb);
  end
 
  initial begin
    run_test("base_test");
       #120;
    $finish;
  end
endmodule