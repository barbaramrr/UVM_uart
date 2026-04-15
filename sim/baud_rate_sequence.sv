`ifndef BAUD_RATE_SEQUENCE_SV
`define BAUD_RATE_SEQUENCE_SV
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class baud_rate_sequence extends uvm_sequence #(uart_item);
    `uvm_object_utils(baud_rate_sequence) 

    function new(string name = "baud_rate_sequence");
        super.new(name);
    endfunction : new

    task body();
        uart_item item;
        item = uart_item::type_id::create("item");

        repeat (10) begin
            start_item(item);
            
            if(!item.randomize()) `uvm_error("SEQ", "Fail")
            
            uvm_config_db#(bit [4:0])::set(null, "*", "CURRENT_BAUD", item.baud);

            finish_item(item); 
        end
    endtask : body
endclass : baud_rate_sequence 

`endif
