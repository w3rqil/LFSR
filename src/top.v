module top
(
    input wire clk                                                                                  ,         // Clock input (100 MHz)
    input wire i_rst                                                                                ,         // Asynchronous reset
    input wire i_soft_reset                                                                         ,         // Synchronous reset
    input wire i_valid                                                                              ,         // Validation signal
    input wire [7:0] i_seed                                                                         ,         // Seed input
    input wire i_corrupt                                                                            ,         // Corruption signal
    output wire o_lock                                                                                        // Lock output
);

    wire [7:0] LFSR_output                                                                          ;       // Output of LFSR_generator
    wire [7:0] corrupted_LFSR                                                                       ;       // Corrupted LFSR sequence

    // Instancia del LFSR_generator
    LFSR_generator U1_LFSR_generator 
    (
        .clk(clk)                                                                                   ,
        .i_valid(i_valid)                                                                           ,
        .i_rst(i_rst)                                                                               ,
        .i_soft_reset(i_soft_reset)                                                                 ,
        .i_seed(i_seed)                                                                             ,
        .o_LFSR(LFSR_output)
    );

    // Corromper el bit 0 de la secuencia si i_corrupt está activo
    assign corrupted_LFSR = i_corrupt ? {LFSR_output[7:1], ~LFSR_output[0]} : LFSR_output           ;

    // Instancia del LFSR_checker
    LFSR_checker U2_LFSR_checker 
    (
        .clk(clk)                                                                                   ,
        .reset(i_rst)                                                                               ,
        .i_valid(i_valid)                                                                           ,
        //.i_soft_reset(i_soft_reset)                                                                 ,
        //.i_seed(i_seed)                                                                             ,
        .i_LFSR(corrupted_LFSR)                                                                     ,
        .o_lock(o_lock)
    );

endmodule
