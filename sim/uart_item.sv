`ifndef UART_ITEM_SV
`define UART_ITEM_SV
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "baud_rate_type.svh" // Inclui a definição do tipo de baud rate

class uart_item extends uvm_sequence_item;
    `uvm_object_utils(uart_item)

    rand bit [7:0] data;
   // rand uart_baud_rate_t baud; // Usa o tipo de baud rate definido em baud_rate_type.sv
    rand bit [4:0] baud; // Enumeração de baud rate (5 bits para representar até 32 valores)

    function new(string name = "uart_item");
        super.new(name);
    endfunction : new
    
endclass : uart_item

`endif // UART_ITEM_SV
