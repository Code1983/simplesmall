//-----------------------------------------------------
// Design Name : top
// File Name   : top.v
// Function    : Processor with following features
//                   8 bit instruction
//                   4 bit address
//                   4 registers
//                   Asynchronous Memory
//                   Only four instructions as below
//               Instructions:
//                   00 - no-op   (format 7,6 -inst, 5,0-ignore
//                   01 - read memory (7,6 -inst, 5,4 -reg, 3,0 -address) 
//                   10 - write memory (7,6 -inst, 5,4 -reg, 3,0 -address)
//                   11 - add (7,6 -inst, 5,4,3 - reg, 2,1,0 -reg)
// Coder       : Malay Das
//-----------------------------------------------------
module top (
clk      , // Clock Input
reset
);
input clk;
input reset;

  
reg [7:0] address;
reg [7:0] inst_address;
reg [7:0] data_in; 
wire [7:0] data_out; 
wire [7:0] instruction; 
reg write_en;  


// Registers
reg [7:0] cpuRegisters [0:3];
  
// definitions need to move data  
  reg [1:0] reg_address;
  reg [7:0] reg_data;
  reg reg_update;
  reg alu_update;

//Fetch: inrement instruction address at each clock cycle
always @ (posedge clk)
begin : FETCH
  if ( !reset ) begin
    inst_address <= inst_address+1;
  end else begin
    inst_address <= 8'b00;
  end
end


//Decode and ALU: Process the instruction
  always @ (instruction or reset)
begin : DECODE
  write_en = 0;
  address = 8'b0;
  data_in = 8'b0;
  reg_update = 0;
  alu_update = 0;
  reg_data = 8'b0;
  if ( !reset ) begin
    $display("inst_prefix = %h, inst = %h, reg0 = %h, reg1 = %h, reg2 = %h, reg3 = %h, ",instruction[7:6], instruction, cpuRegisters[0], cpuRegisters[1], cpuRegisters[2], cpuRegisters[3]);
    case(instruction[7:6])
      2'b01: begin                               //read memory
        address = instruction[3:0];
        reg_address = instruction[5:4];
        reg_update = 1;
        $display("MEM address = %h, data_out = %h, reg_add = %h, reg_val = %h ",address, data_out, reg_address, reg_data);
        end
      2'b10: begin                              //write memory             
        address = instruction[3:0];       
        data_in = cpuRegisters[instruction[5:4]];
        write_en = 1;
        end
      2'b11: begin                              //add
        reg_data = cpuRegisters[instruction[3:2]] + cpuRegisters[instruction[1:0]];
        reg_address = 2'b11;
        alu_update = 1;
        $display("ALU address = %h, data_out = %h, reg_add = %h, reg_val = %h ",address, data_out, reg_address, reg_data);
        end
      default: begin
        write_en = 0;
        address = 8'b0;
        data_in = 8'b0;
        reg_data = 8'b0;
        end
    endcase
  end
  else begin
    write_en = 0;
    address = 8'b0;
    data_in = 8'b0;
    reg_update = 0;
    alu_update = 0;
    reg_data = 8'b0;
  end
end

//Update registers to Get ready for next cycle clock cycle
always @ (posedge clk)
begin : REGUPDATE
  if ( !reset ) begin
    if (reg_update) begin
      cpuRegisters[reg_address] <= data_out;
      $display("mem read reg_add = %h, reg_val = %h ",reg_address, data_out);
    end
    if (alu_update) begin
      cpuRegisters[reg_address] <= reg_data;
      $display("alu update reg_add = %h, reg_val = %h ",reg_address, reg_data);
    end
  end else begin
    cpuRegisters[0] <= 8'b0;
    cpuRegisters[1] <= 8'b0;
    cpuRegisters[2] <= 8'b0;
    cpuRegisters[3] <= 8'b0;
  end
end  


//Memory declaration
asyncMem mem(
address , // Address input
data_in    , // Data 
data_out    , // Data 
inst_address, // instruction address
instruction , // instruction
write_en , // Write Enable
);  
  
endmodule