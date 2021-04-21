/********************************************************************
filename: oscillator.sv
Description: 
Adjustable oscillator.
Assumptions:
Todo:
********************************************************************/


$$#$${
$$#import os
$$#from dave.common.misc import *
$$#def_file = os.path.join(os.environ['DAVE_INST_DIR'], 'dave/mgenero/api_mgenero.py')
$$#api_fullpath = get_abspath(def_file, True, None)
$$#api_dir = get_dirname(api_fullpath)
$$#api_base = os.path.splitext(get_basename(api_fullpath))[0]
$$#
$$#import sys
$$#if not api_fullpath in sys.path:
$$#  import sys
$$#  sys.path.append(api_dir)
$$#from api_mgenero import *
$$#
$$#}$$

`timescale 1 ps / 1 ps

module $$(Module.name()) #(
  $$(Module.parameters())
) (
  $$(Module.pins())
);



$$Pin.print_map() $$# map between user pin names and generic ones
$$PWL.declare_optional_analog_pins_in_real()
$$PWL.instantiate_pwl2real_optional_analog_pins(['vss'] if Pin.is_exist('vss') else [])
// Declare parameters
real frequency;

$${
# sensitivity list of always @ statement
# sensitivity = ['v_icm_r', 'vdd_r', 'wakeup'] + get_sensitivity_list() 
sensitivity = ['wakeup'] + get_sensitivity_list() 

# model parameter mapping for back-annotation
# { testname : { test output : Verilog variable being mapped to } }
model_param_map = { 'test1': {'frequency': 'frequency'} }

}$$

$${
iv_map = {}
}$$

always @(*) begin
$$annotate_modelparam(model_param_map, iv_map)
end


real period;

always @(*) begin
    period = 1 / frequency * 1e12;
end

always @(posedge out) begin
    out <= #(period/2 * 1.0) 1'b0;
end

always @(negedge out) begin
    out <= #(period/2 * 1.0) 1'b1;
end

initial begin
    out <= 1'b0;
    #(period / 2 * 1.0)
    out <= 1'b1;
end

endmodule

