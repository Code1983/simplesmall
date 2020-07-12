//-----------------------------------------------------
// Design Name : top_tb
// File Name   : top_tb.v
// Function    : test processor
// Coder       : Malay Das
//-----------------------------------------------------
module top_tb;

 reg clk;
 reg reset;
  
always begin
   #2  clk =  ! clk;
end 
   
  
 initial begin
   clk = 0;
   reset = 1;
   //#10 $monitor ("clk = %h, reset = %h", clk, reset);
   #4 reset=0;
   
   #60$finish;
    
 end
  
  
  
top cpu(
clk      , // Clock Input
reset
);

endmodule 