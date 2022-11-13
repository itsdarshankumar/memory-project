`include "project.v"
`include "defines.v"

module testbench;
  reg clk, rst;
  cache_module uut(clk, reset,hit_cnt);
  always #5 clk=~clk;
  initial
  begin
    clk=0; rst=1;//writeORread=0;inbyte=7'd9;dataBlock=256'h123456;pa=32'h9876ABC0;
    #((5*`trace_lines)/2 -1) rst=0;
    #((5*`trace_lines)/2) $finish;
  end
endmodule