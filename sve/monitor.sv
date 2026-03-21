class monitor extends uvm_monitor;
  virtual apb_if vif;
 
  uvm_analysis_port #(seq_item) item_collect_port;
  seq_item mon_item;
  `uvm_component_utils(monitor)
 
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collect_port = new("item_collect_port", this);
    //mon_item = new();
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) `uvm_fatal(get_type_name(), "Not set at top level");
  endfunction
 
  task run_phase(uvm_phase phase);
 	 wait (vif.PRESETn);
  forever begin
	//$display("monitor entry");

	wait(vif.PSEL && !vif.PENABLE);
       
    mon_item = seq_item::type_id::create("mon_item", this); // Creating new item forever
    	mon_item.PADDR  = vif.PADDR;
    	mon_item.PWRITE = vif.PWRITE;
   	mon_item.PWDATA = vif.PWDATA;
    	`uvm_info(get_type_name(), $sformatf("SETUP: PADDR = %0h, PWRITE = %0b", mon_item.PADDR, mon_item.PWRITE), UVM_MEDIUM)
        
	
	@(posedge vif.PSEL && vif.PENABLE && vif.PREADY);
    	mon_item.PREADY  = vif.PREADY;

    	`uvm_info(get_type_name(), $sformatf("ACCESS: PWDATA =%0h PREADY=%0b", mon_item.PWDATA, mon_item.PREADY), UVM_MEDIUM)
 
    	if (!vif.PWRITE) begin
		mon_item.PRDATA = vif.PRDATA;
        `uvm_info(get_type_name(),$sformatf("READ: ADDR=%0h PRDATA=%0h", mon_item.PADDR, mon_item.PRDATA),UVM_MEDIUM)
    	end

    	else begin
      	`uvm_info(get_type_name(),$sformatf("WRITE: ADDR=%0h PWDATA=%0h", mon_item.PADDR, mon_item.PWDATA),UVM_MEDIUM)
	$display("------------------------------------------WRITE Complete---------------------------------------------------");
    	end
	
    	item_collect_port.write(mon_item);
	//$display("monitor exit");
	//mon_item.print();
	
  	end

  endtask
endclass