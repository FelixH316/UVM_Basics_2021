/*
 * File: 	  Lab01_uvm_tesbench.sv
 * Brief:	  UVM Testbench demo
 * Authors: Miguel Angel Rivera Acosta
 *          Félix Armenta Aguiñaga
 * Date:    2021-11-22
*/
import uvm_pkg::*;

`include "uvm_macros.svh"

/*
	Build phase -> Run phase -> Clean up phase

	+ Build phase: prior to simulation, before applying stimulus, create objects.

  + Run phase: stimulus are applied to DUT and response are captured, since it consumes time, this phase is created as a task.

  + Clean up: used to show important messages.
*/

class driver extends uvm_driver;
  `uvm_component_utils(driver) 	// Register component to factory

  function new(input string inst, uvm_component c);
    super.new(inst, c);
  endfunction

  // Overriding superclass build_phase method
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRV", "Build Phase", UVM_NONE);
  endfunction

  // Overrding superclass connect_phase method
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("DRV", "Connect Phase", UVM_NONE);
  endfunction

  // Overriding superclass run_phase method
  virtual task run_phase(uvm_phase phase);
    `uvm_info("DRV", "Run Phase", UVM_NONE);
  endtask

  // Overriding superclass report_phase method
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("DRV", "Report Phase", UVM_NONE);
  endfunction

endclass


class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  function new(input string inst, uvm_component c);
    super.new(inst, c);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MON", "Build Phase", UVM_NONE)
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MON", "Connect Phase", UVM_NONE)
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info("MON", "Run Phase", UVM_NONE)
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("MON", "Report Phase", UVM_NONE)
  endfunction

endclass


class agent extends uvm_agent;
  `uvm_component_utils(agent)

  monitor m;
  driver d;

  function new(input string inst, uvm_component c);
    super.new(inst, c);
  endfunction

  // In the build phase, objects must be created, since agent contains monitor and driver, the monitor and driver must be generated using create method (using factory)

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT", "Build Phase", UVM_NONE)
    m = monitor::type_id::create("MON", this); // Creates object using factory
    d = driver::type_id::create("DRV", this); // Creates object using factory
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT", "Connect Phase", UVM_NONE)
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info("AGENT", "Run Phase", UVM_NONE)
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("AGENT", "Report Phase", UVM_NONE)
  endfunction

endclass


class env extends uvm_env;
  `uvm_component_utils(env)

  agent a;	// Creates handler for agent

  function new (input string inst, uvm_component c);
    super.new(inst, c);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV", "Build Phase", UVM_NONE)
    a = agent::type_id::create("AGENT", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV", "Connect Phase", UVM_NONE);
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info("ENV", "Run Phase", UVM_NONE);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("ENV", "Report Phase", UVM_NONE)
  endfunction

endclass


class test extends uvm_test;
  `uvm_component_utils(test)

  env e;	// Create handler for environment

  function new (input string inst, uvm_component c);
    super.new(inst, c);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST", "Build Phase", UVM_NONE)
    e = env::type_id::create("ENV", this);	// Creates object of environment class using factory
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    //`uvm_info("TEST", "End of Elaboration Phase", UVM_NONE)
    print();
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info("TEST", "Run Phase", UVM_NONE)
    #100
    global_stop_request();
  endtask

endclass


module tb();
  test t;

  initial begin
    t = new("TEST", null);
    run_test();
  end
endmodule
