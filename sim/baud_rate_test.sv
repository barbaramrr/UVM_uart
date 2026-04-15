`ifndef BAUD_RATE_TEST_SV
`define BAUD_RATE_TEST_SV
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "environment.sv"

class baud_rate_test extends uart_test;
    `uvm_component_utils(baud_rate_test)

    function new(string name = "baud_rate_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
 function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "uart_env.rx_ag", "is_active", UVM_ACTIVE);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "uart_env.tx_ag", "is_active", UVM_ACTIVE);
        uart_env = uart_environment::type_id::create("uart_env", this);
    endfunction : build_phase
    
    task run_phase(uvm_phase phase);
        baud_rate_sequence seq;
        phase.raise_objection(this);
        seq = baud_rate_sequence::type_id::create("seq");
        seq.start(uart_env.tx_ag.tx_sqr);
        phase.drop_objection(this);
    endtask
endclass

`endif // BAUD_RATE_TEST_SV