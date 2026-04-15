class baud_rate_test extends uart_test;
    `uvm_component_utils(baud_rate_test)

    function new(string name = "baud_rate_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        baud_rate_sequence seq;
        phase.raise_objection(this);
        seq = baud_rate_sequence::type_id::create("seq");
        seq.start(uart_env.tx_ag.tx_sqr);
        phase.drop_objection(this);
    endtask
endclass