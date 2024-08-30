`timescale 1ns / 1ps

module tb_TOP_LFSR;

    reg clk;
    reg i_rst;
    reg i_soft_reset;
    reg i_valid;
    reg i_corrupt;
    reg [7:0] i_seed;
    wire o_lock;

    // Instanciación del módulo TOP_LFSR
    TOP_LFSR uut (
        .clk(clk),
        .i_rst(i_rst),
        .i_soft_reset(i_soft_reset),
        .i_valid(i_valid),
        .i_seed(i_seed),
        .i_corrupt(i_corrupt),
        .o_lock(o_lock)
    );

    // Generación de clock a 100 MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 5 ns para 100 MHz
    end

    initial begin
        // Inicialización de señales
        i_rst = 1;
        i_soft_reset = 0;
        i_valid = 0;
        i_seed = 8'hFF;
        i_corrupt = 0;
        
        // Liberar reset después de 200 ns
        #200;
        i_rst = 0;
        
        // Aplicar soft reset
        #100;
        i_soft_reset = 1;
        #10;
        i_soft_reset = 0;
        
        // Generar una secuencia válida
        i_valid = 1;
        #500;
        i_valid = 0;

        // Corromper la secuencia
        i_corrupt = 1;
        i_valid = 1;
        #500;
        i_valid = 0;

        // Finalizar simulación
        #200;
        $finish;
    end

endmodule
