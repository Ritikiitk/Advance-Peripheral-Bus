`include "uvm_macros.svh"
import uvm_pkg::*;
 
class seq_item extends uvm_sequence_item;
	  rand bit [31:0] PADDR;
  rand bit [31:0] PWDATA;
  bit [31:0] PRDATA;

  bit PWRITE;
  bit PSEL;
  bit PENABLE;
  bit PREADY;

  function new(string name = "seq_item");
    super.new(name);
  endfunction
  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(PADDR,UVM_ALL_ON)
    `uvm_field_int(PWDATA,UVM_ALL_ON)
    `uvm_field_int(PWRITE,UVM_ALL_ON)
    `uvm_field_int(PREADY,UVM_ALL_ON)
    `uvm_field_int(PRDATA,UVM_ALL_ON)
  `uvm_object_utils_end
   constraint PADDR_c1 {
  PADDR inside {[32'h00 : 32'hFC]};
  PADDR[1:0] == 2'b00;   // word aligned
}
endclass
