`ifndef RX_MONITOR_SV
`define RX_MONITOR_SV
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class rx_monitor extends uvm_monitor;
    `uvm_component_utils(rx_monitor)

    virtual uart_bfm bfm_uart0;
    virtual reg_if_bfm bfm_reg0;

    uvm_analysis_port#(bit [7:0]) ap_command;
    uvm_analysis_port#(bit [7:0]) ap_result;

    function new(string name = "rx_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_command = new("ap_command", this);
        ap_result  = new("ap_result", this);
        
        if (!uvm_config_db#(virtual uart_bfm)::get(this, "", "bfm_uart0", bfm_uart0))
            `uvm_fatal(get_full_name(), "Virtual Interface uart_bfm nao encontrada");
        if (!uvm_config_db#(virtual reg_if_bfm)::get(this, "", "bfm_reg0", bfm_reg0))
            `uvm_fatal(get_full_name(), "Virtual Interface reg_if_bfm nao encontrada");
    endfunction : build_phase

    function real get_actual_baud(bit [4:0] idx);
        case(idx)
            5'd0:  return 50.0;      
            5'd1:  return 75.0;      
            5'd2:  return 110.0;
            5'd3:  return 134.0;     
            5'd4:  return 150.0;     
            5'd5:  return 200.0;
            5'd6:  return 300.0;     
            5'd7:  return 600.0;     
            5'd8:  return 1200.0;
            5'd9:  return 1800.0;    
            5'd10: return 2400.0;    
            5'd11: return 4800.0;
            5'd12: return 9600.0;    
            5'd13: return 14400.0;   
            5'd14: return 19200.0;
            5'd15: return 28800.0;   
            5'd16: return 31250.0;   
            5'd17: return 38400.0;
            5'd18: return 56000.0;   
            5'd19: return 57600.0;   
            5'd20: return 76800.0;
            5'd21: return 115200.0;  
            5'd22: return 128000.0;  
            5'd23: return 153600.0;
            5'd24: return 230400.0;  
            5'd25: return 256000.0;  
            5'd26: return 460800.0;
            5'd27: return 500000.0;  
            5'd28: return 921600.0;  
            5'd29: return 1000000.0;
            default: return 9600.0;
        endcase
    endfunction

    task command_monitor_task();
        bit [7:0] data_read;
        bit [4:0] b_idx;

        forever begin
            if (!uvm_config_db#(bit [4:0])::get(this, "", "CURRENT_BAUD", b_idx)) begin
                b_idx = 5'd12; 
            end

            bfm_uart0.receive_rx(data_read, 8, get_actual_baud(b_idx), "none");
            ap_command.write(data_read);
        end
    endtask

    task result_monitor_task();
        bit [7:0] data_read;
        forever begin
            bfm_reg0.uart_receive(data_read);
            ap_result.write(data_read);
        end
    endtask

    task run_phase(uvm_phase phase);
        fork
            command_monitor_task();
            result_monitor_task();
        join
    endtask : run_phase

endclass : rx_monitor

`endif