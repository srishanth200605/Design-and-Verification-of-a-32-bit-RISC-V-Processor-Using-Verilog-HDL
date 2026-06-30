// riscv_top.v - Fixed Version with Debug Outputs
module riscv_top (
    input  clk,
    input  rst,
    // Debug Outputs for Simulation / FPGA
    output [31:0] debug_pc,
    output [31:0] debug_instr,
    output [31:0] debug_reg_x5,   // t0
    output [31:0] debug_reg_x7,   // t2
    output [31:0] debug_alu_result,
    output        debug_zero,
    output [31:0] debug_mem_data
);

    // Internal wires
    wire [31:0] pc_out, instr, rs1_data, rs2_data, imm_ext, alu_result, mem_rd, wb_data;
    wire [3:0] alu_ctrl;
    wire zero, pc_src, reg_write, alu_src, mem_to_reg, mem_read, mem_write, branch;
    wire [1:0] alu_op;

    // ============== Core Datapath ==============
    pc program_counter (
        .clk(clk), 
        .rst(rst), 
        .next_pc(pc_src ? (pc_out + imm_ext) : (pc_out + 32'd4)), 
        .pc(pc_out)
    );

    instr_mem imem (.addr(pc_out), .instr(instr));

    reg_file rf (
        .clk(clk), 
        .rst(rst), 
        .reg_write(reg_write),
        .rs1(instr[19:15]), 
        .rs2(instr[24:20]), 
        .rd(instr[11:7]),
        .wd(wb_data), 
        .rd1(rs1_data), 
        .rd2(rs2_data)
    );

    imm_gen ig (.instr(instr), .imm(imm_ext));

    control_unit cu (
        .opcode(instr[6:0]),
        .reg_write(reg_write), .alu_src(alu_src), .mem_to_reg(mem_to_reg),
        .mem_read(mem_read), .mem_write(mem_write), .branch(branch), .alu_op(alu_op)
    );

    alu_control ac (
        .alu_op(alu_op), 
        .funct7(instr[31:25]), 
        .funct3(instr[14:12]), 
        .alu_ctrl(alu_ctrl)
    );

    alu alu_unit (
        .a(rs1_data), 
        .b(alu_src ? imm_ext : rs2_data),
        .alu_ctrl(alu_ctrl), 
        .result(alu_result), 
        .zero(zero)
    );

    data_mem dmem (
        .clk(clk), 
        .mem_read(mem_read), 
        .mem_write(mem_write),
        .addr(alu_result), 
        .wd(rs2_data), 
        .rd(mem_rd)
    );

    assign wb_data = mem_to_reg ? mem_rd : alu_result;
    assign pc_src  = branch & zero;

    // ============== Debug Outputs (Fixed) ==============
    assign debug_pc         = pc_out;
    assign debug_instr      = instr;
    assign debug_alu_result = alu_result;
    assign debug_zero       = zero;
    assign debug_mem_data   = mem_rd;

    // Fixed: Expose registers through reg_file outputs (we will modify reg_file)
    assign debug_reg_x5 = rf.debug_x5;   // Will be added in reg_file
    assign debug_reg_x7 = rf.debug_x7;

endmodule
