// testbench.v - Fixed Version
module testbench;

    reg clk;
    reg rst;

    // Debug signals from processor
    wire [31:0] debug_pc;
    wire [31:0] debug_instr;
    wire [31:0] debug_reg_x5;
    wire [31:0] debug_reg_x7;
    wire [31:0] debug_alu_result;
    wire        debug_zero;
    wire [31:0] debug_mem_data;

    // Instantiate the processor
    riscv_top dut (
        .clk(clk),
        .rst(rst),
        .debug_pc(debug_pc),
        .debug_instr(debug_instr),
        .debug_reg_x5(debug_reg_x5),
        .debug_reg_x7(debug_reg_x7),
        .debug_alu_result(debug_alu_result),
        .debug_zero(debug_zero),           // Fixed port name
        .debug_mem_data(debug_mem_data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz clock
    end

    initial begin
        $display("=== RISC-V Single Cycle Processor Simulation Started ===");
        $display("Time\tPC\t\tInstr\t\tx5\t\tx7\t\tALU\t\tZero");

        $monitor("t=%0d | PC=%h | Instr=%h | x5=%h | x7=%h | ALU=%h | Zero=%b | Mem=%h",
                 $time, debug_pc, debug_instr, debug_reg_x5, debug_reg_x7, 
                 debug_alu_result, debug_zero, debug_mem_data);

        rst = 1;
        #12 rst = 0;     // Release reset after some time

        #500;            // Run simulation long enough

        $display("\n=== Simulation Finished Successfully! ===");
        $finish;
    end

    // Generate VCD waveform file
    initial begin
        $dumpfile("riscv_wave.vcd");
        $dumpvars(0, testbench);
    end

endmodule
