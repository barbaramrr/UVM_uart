`ifndef TX_MONITOR_SV
`define TX_MONITOR_SV
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class tx_monitor extends uvm_monitor;
    `uvm_component_utils(tx_monitor)

    virtual uart_bfm bfm_uart0;
    virtual reg_if_bfm bfm_reg0;

    uvm_analysis_port#(bit [7:0]) ap_command;
    uvm_analysis_port#(bit [7:0]) ap_result;

    function new(string name = "tx_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap_command = new("ap_command", this);
        ap_result  = new("ap_result", this);
        
        if (!uvm_config_db#(virtual uart_bfm)::get(this, "", "bfm_uart0", bfm_uart0))
            `uvm_fatal(get_full_name(), "BFM not set via uvm_config_db");
        if (!uvm_config_db#(virtual reg_if_bfm)::get(this, "", "bfm_reg0", bfm_reg0))
            `uvm_fatal(get_full_name(), "Register Interface BFM not set via uvm_config_db");
    endfunction : build_phase
// Alteração: Função de conversão de enumeração de baud rate para valor real 
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
            default: baud_conv = 115200.0; 
        endcase
    endfunction

    // task for sampling command interface
    task command_monitor_task();
        bit [7:0] data_read;
        forever begin
            bfm_reg0.get_if_write01(data_read);
            ap_command.write(data_read);
            @(posedge bfm_reg0.clk); 
        end
    endtask

    // task for sampling result interface
    task result_monitor_task();
        bit [7:0] data_read; // Dado lido da linha TX
        bit [31:0] csr_reg; // Registrador de controle e status para ler a configuração atual
        bit [4:0] current_baud; // baud rate atual para conversão
        forever begin
            bfm_reg0.read_register(csr_reg, 2'b00); // Lê o CSR para obter a configuração atual, incluindo o baud rate 
            current_baud = csr_reg[11:7]; // Extrai o código de baud rate dos bits 11:7    
            bfm_uart0.receive_tx(data_read,8, baud_conv(current_baud),"none",0); // Recebe o dado da linha TX usando a velocidade correta
            ap_result.write(data_read);
        end
    endtask

    task run_phase(uvm_phase phase);
        fork
            command_monitor_task();
            result_monitor_task();
        join_none
    endtask : run_phase

endclass : tx_monitor

`endif // TX_MONITOR_SV
