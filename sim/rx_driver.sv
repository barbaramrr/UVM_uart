`ifndef RX_DRIVER_SV
`define RX_DRIVER_SV
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "uart_item.sv"

class rx_driver extends uvm_driver #(uart_item);
    `uvm_component_utils(rx_driver)

    virtual uart_bfm bfm_uart0;

    function new(string name = "rx_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual uart_bfm)::get(this, "", "bfm_uart0", bfm_uart0))
            `uvm_fatal(get_full_name(), "BFM not set via uvm_config_db");
    endfunction : build_phase
// Alteração: Função de conversão de enumeração de baud rate para valor real (em bps)
    function real baud_conv (input bit [4:0] baud_enum);
        case (baud_enum)
            5'd0 : baud_conv = 50.0;
            5'd1 : baud_conv = 75.0;
            5'd2 : baud_conv = 110.0;
            5'd3 : baud_conv = 134.0;
            5'd4 : baud_conv = 150.0;
            5'd5 : baud_conv = 200.0;
            5'd6 : baud_conv = 300.0;
            5'd7 : baud_conv = 600.0;
            5'd8 : baud_conv = 1200.0;
            5'd9 : baud_conv = 1800.0;
            5'd10: baud_conv = 2400.0;
            5'd11: baud_conv = 4800.0;
            5'd12: baud_conv = 9600.0;
            5'd13: baud_conv = 14400.0;
            5'd14: baud_conv = 19200.0;
            5'd15: baud_conv = 28800.0;
            5'd16: baud_conv = 31250.0;
            5'd17: baud_conv = 38400.0;
            5'd18: baud_conv = 56000.0;
            5'd19: baud_conv = 57600.0;
            5'd20: baud_conv = 76800.0;
            5'd21: baud_conv = 115200.0;
            5'd22: baud_conv = 128000.0;
            5'd23: baud_conv = 153600.0;
            5'd24: baud_conv = 230400.0;
            5'd25: baud_conv = 256000.0;
            5'd26: baud_conv = 460800.0;
            5'd27: baud_conv = 500000.0;
            5'd28: baud_conv = 576000.0;
            5'd29: baud_conv = 921600.0;
            default: baud_conv = 115200.0; // Valor padrão
        endcase
        
    endfunction

    task run_phase(uvm_phase phase);
        uart_item command;
    
        fork
            bfm_uart0.generate_clock(100_000_000, 0, 0);
            bfm_uart0.reset_pulse(1, 5, "Sync", 1);
        join_any

        forever begin
            seq_item_port.get_next_item(command);
            `uvm_info(get_full_name(), $sformatf("Enviando bit-stream para RX da DUT. Baud: %0f", 
                      baud_conv(command.baud)), UVM_MEDIUM)
            bfm_uart0.send(command.data, 8, baud_conv(command.baud), "none", 0); // Alteração: Passa a velocidade convertida para o BFM
            seq_item_port.item_done();
        end
    endtask : run_phase

endclass : rx_driver

`endif // RX_DRIVER_SV
