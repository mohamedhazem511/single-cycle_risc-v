/*
   Created by : Mohamed Hazem Mamdouh
   12-08-2023
   7:30 PM
 */
//***************  Risc-v Top Module ***************//

module risc_v  
(
 input   wire                        CLK,
 input   wire                        RST,
 //////////////// for test /////////////////////////
 output  wire     [31:0]             test    

);

/***************** Internal signal ***************/

 wire      [6:0]       OP_c;
 wire                  Zero_c;
 wire      [2:0]       funct3_c;
 wire                  funct7_c;
 wire                  PCSrc_c;
 wire                  ALUSrc_c;
 wire                  RegWrite_c;
 wire                  MemWrite_c;
 wire       [1:0]      ResultSrc_c;
 wire       [2:0]      ALUControl_c;
 wire       [1:0]      ImmSrc_c;
 wire       [31:0]     PC_c;
 wire       [31:0]     PCNext_c;
 wire       [31:0]     RD2_c;
 wire       [31:0]     ImmExt_c;
 wire       [31:0]     PCPlus_c;
 wire       [31:0]     PCTargt_c;
 wire       [31:0]     ALU_Result_c;   
 wire       [31:0]     ReadData_c;        
 wire       [31:0]     Instr;
 wire       [31:0]     Result_c; 
 wire       [31:0]     RD1_c;
 wire       [31:0]     SrcB_c;


//***************  Port Mapping for Control Unit ***************//


Control_Unit U0_Control_Unit (

  
    .OP(Instr[6:0]),
    .Zero(Zero_c),
    .funct3(Instr[14:12]),
    .funct7(Instr[30]),
    .PCSrc(PCSrc_c),
    .ALUSrc(ALUSrc_c),
    .RegWrite(RegWrite_c),
    .MemWrite(MemWrite_c),
    .ResultSrc(ResultSrc_c),
    .ALUControl(ALUControl_c),
    .ImmSrc(ImmSrc_c)

);

//***************  Port Mapping for Program counter ***************//

PC U0_PC(
    .PCNext(PCNext_c),
    .CLK(CLK),
    .RST(RST),
    .PC(PC_c) 
);

//***************  Port Mapping for PCPlus4 ***************//

PCPlus4 U0_PCPlus4(
    .PC(PC_c),
    .PCPlus4(PCPlus_c)
);

//***************  Port Mapping for PCTargt ***************//

PCTargt U0_PCTargt(
    .PC(PC_c),
    .ImmExt(ImmExt_c),
    .PCTargt(PCTargt_c)
);

//***************  Port Mapping for mux 2x1 for SrcB ***************//
mux_2x1 U0_mux_2x1(
    .RD2(RD2_c),
    .ImmExt(ImmExt_c),
    .ALUSrc(ALUSrc_c),
    .SrcB(SrcB_c) 
);
//***************  Port Mapping for mux 2x1 for pc counter  ***************//
mux_2x1 U1_mux_2x1(
    .RD2(PCPlus_c),
    .ImmExt(PCTargt_c),
    .ALUSrc(PCSrc_c),
    .SrcB(PCNext_c) 
);

//***************  Port Mapping for instraction memory  ***************//

inst_mem U0_inst_mem(
    .A(PC_c),
    .RD(Instr)
);

//***************  Port Mapping for register file  ***************//

Register_File U0_Register_File( 
    .A1(Instr[19:15]),
    .A2(Instr[24:20]),
    .A3(Instr[11:7]),
    .WD3(Result_c),
    .CLK(CLK),
    .RST(RST),
    .WE3(RegWrite_c),
    .RD1(RD1_c),
    .RD2(RD2_c)   
);

//***************  Port Mapping for mux 3x1  ***************//

mux_3x1 U0_mux_3x1(
    .ALUResult(ALU_Result_c),
    .ReadData(ReadData_c),
    .PCPlus4(PCPlus_c),
    .ResultSrc(ResultSrc_c),
    .Result(Result_c)
);

//***************  Port Mapping for sign extend  ***************//

Extend U0_Extend(
    .INSTR(Instr[31:7]),
    .IMMSrc(ImmSrc_c),
    .IMMExt(ImmExt_c)
);

//***************  Port Mapping for alu  ***************//

alu  U0_alu(
    .SrcA(RD1_c),
    .SrcB(SrcB_c),
    .ALUControl(ALUControl_c),
    .ALUResult(ALU_Result_c),
    .Zero(Zero_c)
);

//***************  Port Mapping for data memory  ***************//

Data_Mem U0_Data_Mem(
    .A(ALU_Result_c),
    .WD(RD2_c),
    .CLK(CLK),
    .RST(RST),
    .WE(MemWrite_c),
    .RD(ReadData_c),
    .test(test) 
);





endmodule
