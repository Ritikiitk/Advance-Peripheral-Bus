class scoreboard extends uvm_scoreboard;
  uvm_analysis_imp #(seq_item, scoreboard) item_collect_export;
  seq_item item_q[$];
  `uvm_component_utils(scoreboard)
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    item_collect_export = new("item_collect_export", this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  function void write(seq_item req);
    item_q.push_back(req);
  endfunction
  task run_phase (uvm_phase phase);
    seq_item sb_item_1;
    seq_item sb_item_2;
 
    forever begin
      wait(item_q.size >= 2);
      if(item_q.size >= 2) begin
	      	sb_item_1 = item_q.pop_front();
		sb_item_2= item_q.pop_front();
 
	end
 
 
        $display("----------------------------------------------------------------------------------------------------------");
        if(sb_item_1.PWDATA == sb_item_2.PRDATA) begin
          `uvm_info(get_type_name, $sformatf("Matched:  PWDATA = %0h , PRDATA = %0h", sb_item_1.PWDATA, sb_item_2.PRDATA),UVM_LOW);
        end
        else begin
          `uvm_error(get_type_name, $sformatf("NOT Matched:  PWDATA = %0h, PRDATA = %0h", sb_item_1.PWDATA, sb_item_2.PRDATA));
        end
        $display("----------------------------------------------------------------------------------------------------------");
    end
  endtask
endclass