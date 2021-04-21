// osc_tb.v

`include "osc_adj_generated.sv"

`timescale 1 ps/1 ps  // time-unit = 1 ns, precision = 10 ps

module osc_tb;

    reg a, b;
    real vss_tb, vdd_tb;
    wire out_tb;

    localparam tenish_period = 10000;  

    osc_adj DUT (.ctrl0(a), .ctrl1(b), .out(out_tb),
        .vss(vss_tb), .vdd(vdd_tb));
    
    initial // initial block executes only once
        begin

            $display("very top");
            $dumpfile("osc_adj_dump.vcd");
            $dumpvars;

            // values for a and b
            vss_tb = 0;
            vdd_tb = 1.8;
            a = 0;
            b = 0;
            #5e-9;
            $display("test1");
            #1;
            $display("test2");
            #tenish_period;

            a = 0;
            b = 1;
            #tenish_period;

            a = 1;
            b = 0;
            #tenish_period;

            a = 1;
            b = 1;
            #tenish_period;

            $display("just before finish");

            $finish;
        end


endmodule


