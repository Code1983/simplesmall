//-----------------------------------------------------
// Design Name : mem_tb
// File Name   : mem_tb.v
// Function    : test memory
// Coder       : Malay Das
//-----------------------------------------------------
module mem_tb;
 reg [7:0] address;
 reg [7:0] inst_address;
 reg write_en;
 reg clk;
 wire [7:0] data_in; 
 wire [7:0] data_out; 
 wire [7:0] instruction;  
 reg [7:0] data;
 integer i;
 integer memfile;
  
always begin
   #2  clk =  ! clk;
end 
  
assign data_in = data; 
  
 initial begin
   clk = 0;
   data = 0;
   address = 0;
   inst_address =0;
   write_en = 0;
   #10 $monitor ("address = %h, data_in = %h, data_out = %h, write_en = %b | Inst_address = %h, instruction = %h", address, data_in, data_out, write_en, inst_address, instruction);
   
   memfile = $fopen ("memout.list","w");
   $dumpfile("varout.list");
   
   for (i = 0; i <8; i = i +1 )begin
     #4 address = i; 
     inst_address =7-i;
     #4 data = i;
     write_en = 1;
     #4 write_en = 0;
   end
   #4 $display("=================END SIMULATION=========================\n");
   for (i = 0; i <8; i = i +1 )begin
    #4 address = i;
    #4 $fwrite (memfile,"%b\n",data_out);
   end  
   $dumpvars(0,U);
   
   #4$finish;
    
 end
  
  
  
asyncMem U(
address , // Address input
data_in    , // Data 
data_out    , // Data 
inst_address, // instruction address
instruction , // instruction
write_en , // Write Enable
);

endmodule 