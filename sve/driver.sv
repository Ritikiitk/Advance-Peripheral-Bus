class driver extends uvm_driver #(seq_item);
  virtual apb_if vif;
  seq_item req;
  `uvm_component_utils(driver)
 
  function new(string name="driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "APB virtual interface not set")
  endfunction
 
  task run_phase(uvm_phase phase);
         @(posedge vif.PCLK);
         vif.PENABLE = 1'b0;
    	 vif.PSEL    = 1'b0;
    	 `uvm_info(get_type_name(), "IDLE: PSEL=0 PENABLE=0", UVM_MEDIUM)
    forever begin
      seq_item_port.get_next_item(req);
    // SETUP PHASE
    @(posedge vif.PCLK);
    vif.PENABLE = 1'b0;
    vif.PSEL    = 1'b1;
    vif.PADDR   =req.PADDR;
    vif.PWRITE  = req.PWRITE;
    if(req.PWRITE)	vif.PWDATA  = req.PWDATA;
    else 		vif.PWDATA  = 32'd0;
    `uvm_info(get_type_name(),$sformatf("SETUP: PADDR=%0h PWRITE=%0b PWDATA=%0h",vif.PADDR, vif.PWRITE, vif.PWDATA),UVM_MEDIUM)

       // ACCESS PHASE
    @(posedge vif.PCLK);
    vif.PENABLE = 1'b1;
    `uvm_info(get_type_name(),$sformatf("ACCESS: PADDR=%0h PWRITE=%0b PWDATA=%0h ",vif.PADDR, vif.PWRITE, vif.PWDATA),UVM_MEDIUM)
    wait(vif.PREADY==1);
    `uvm_info(get_type_name(),$sformatf("ACCESS: PREADY=%0b", vif.PREADY),UVM_HIGH)

      seq_item_port.item_done();
    end
  endtask

endclass