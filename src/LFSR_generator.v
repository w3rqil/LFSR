module LFSR_generator 
(
    input wire  clk                                             ,
    input wire  i_valid                                         ,
    input wire  i_rst                                           ,               //! Reset asincrónico para fijar el valor de seed
    input wire  i_soft_reset                                    ,               //! Reset sincrónico para registrar el valor de i_seed
    input wire  [7:0] i_seed                                    ,               //! Seed inicial
    //output wire o_valid                                         ,
    output wire [7:0] o_LFSR                                                    //! Salida del LFSR
);


reg [7:0] LFSR                                                  ;
wire feedback = LFSR[7] ^ (LFSR[6:0]==7'b0000000)       ;
reg [7:0] seed = 8'b11111111                                    ;
//reg valid=0;
always @(posedge clk or posedge i_rst) begin
    if (i_rst) begin
        //! Reset asincrónico: Fijar el valor de seed
        LFSR <= seed                                            ;
    end else if (i_soft_reset) begin
        //! Reset sincrónico: Registrar el valor de i_seed
        LFSR <= i_seed                                          ;
    end else if (i_valid) begin
        //! Generar nueva secuencia solo si i_valid está activo
        LFSR[0] <= feedback                                     ;
        LFSR[1] <= LFSR[0]                                      ;
        LFSR[2] <= LFSR[1] ^ feedback                           ;
        LFSR[3] <= LFSR[2] ^ feedback                           ;
        LFSR[4] <= LFSR[3]                                      ;
        LFSR[5] <= LFSR[4]                                      ;
        LFSR[6] <= LFSR[5]                                      ;
        LFSR[7] <= LFSR[6] ^ feedback                           ;
    end
    //valid <= i_valid;
end

assign o_LFSR = LFSR                                            ;
//assign o_valid = i_valid                                        ;
/*
always @(posedge clk) begin//! muestro en la salida el valor del LFSR solo si i_valid está activo

    if (i_valid) begin
        o_LFSR <= LFSR                  ;
    end
end*/

endmodule
