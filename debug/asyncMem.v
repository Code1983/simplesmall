//-----------------------------------------------------
// Design Name : asyncMem
// File Name   : asyncMem.v
// Function    : Asynchronous read write memory , also reads instruction.
// Coder       : Deepak Kumar Tala
//-----------------------------------------------------
module asyncMem (
address     , // Address Input
data_in     , // data in
data_out    , // data out
inst_address, // instruction address
instruction , // instruction
we          , // Write Enable
);          

//--------------Input Ports----------------------- 
input [7:0] address ;
input [7:0] inst_address ;
input we;
input [7:0]  data_in       ;

//--------------Inout Ports----------------------- 
//inout [DATA_WIDTH-1:0]  data       ;
output [7:0]  data_out       ;
output [7:0]  instruction       ;

//--------------Internal variables---------------- 
reg [7:0]   data_out ;
reg [7:0]  instruction       ;
reg [7:0] mem [0:255];

//--------------Code Starts Here------------------ 

// Tri-State Buffer control 
// output : When we = 0, oe = 1, 
//assign data = (oe && !we) ? data_out : 8'bz; 

// Memory Write Block 
// Write Operation : When we = 1
  always @ (address or data_in or we)
begin : MEM_WRITE
  if ( we ) begin
    mem[address] = data_in;
    $display("MEM_WRITE mem_add = %h, mem_val = %h ",address, data_in);
  end
end

// Memory Read Block 
always @ (address or we)
begin : MEM_READ
    data_out = mem[address];
  $display("MEM_READ mem_add = %h, mem_val = %h ",address, data_out);
end

// Instruction Read Block 
  always @ (inst_address or we)
begin : INST_READ
    instruction = mem[inst_address];
end

initial begin
  $readmemb("memory.list",mem);
end

endmodule