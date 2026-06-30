// instr_mem.v
module instr_mem (
    input  [31:0] addr,
    output [31:0] instr
);
    reg [31:0] mem [0:63];

    initial begin
        // === Test Program demonstrating multiple operations ===

        // 1. Arithmetic I-type
        mem[0]  = 32'h00500293;  // addi x5, x0, 5     ? x5 = 5
        mem[1]  = 32'h00a00313;  // addi x6, x0, 10    ? x6 = 10

        // 2. R-type operations
        mem[2]  = 32'h006283b3;  // add  x7, x5, x6    ? x7 = 15
        mem[3]  = 32'h406283b3;  // sub  x7, x5, x6    ? x7 = -5 (two's complement)
        mem[4]  = 32'h0062a3b3;  // slt  x7, x5, x6    ? x7 = 1 (true)

        // 3. Logical operations
        mem[5]  = 32'h0062f3b3;  // and  x7, x5, x6
        mem[6]  = 32'h0062e3b3;  // or   x7, x5, x6
        mem[7]  = 32'h0062c3b3;  // xor  x7, x5, x6

        // 4. Memory operations (LW / SW)
        mem[8]  = 32'h00002403;  // lw   x8, 0(x0)     ? Load from address 0 (initially 0)
        mem[9]  = 32'h00702423;  // sw   x7, 4(x0)     ? Store x7 to address 4

        // 5. Branch (simple loop/backward)
        mem[10] = 32'hfe0008e3;  // beq  x0, x0, -4    ? Infinite loop (for observation)

        // Fill rest with NOP (addi x0, x0, 0)
        mem[11] = 32'h00000013;
        // ... (rest remain 0)
    end

    assign instr = mem[addr[9:2]];  // Word aligned

endmodule
