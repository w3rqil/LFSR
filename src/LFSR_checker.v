
module LFSR_checker
(
    input wire          clk                                                         , //!clock de la máquina de estados
    input wire          i_reset                                                     , //!reset_n de la máquina de estados
    input wire          i_valid                                                     , //! booleano para empezar la comparación
    input wire [7:0]    i_LFSR                                                      , //!LFSR que se va a comparar con el generado

    output wire [7:0]   o_LFSR_checker                                              ,
    output wire          o_lock                                                       //!lock que se activa cuando se detecta la secuencia    

);



reg [2:0]   valid_counter                                                           ;
reg [2:0]   invalid_counter                                                         ;
reg [7:0]   LFSR                                                                    ;
wire        feedback                                                                ;   
reg [7:0]   next_LFSR                                                               ;

reg         aux_lock                                                                ;
reg         first_flag                                                              ;



always @(posedge clk or posedge i_reset) 
begin
    if(i_reset)
    begin 
        
        valid_counter   <= 0                                                        ;
        invalid_counter <= 0                                                        ;
        aux_lock        <= 0                                                        ;          //! Desbloquear en reset_n 
        first_flag      <= 1                                                        ; 

    end else begin
        //if()
        if(i_valid && first_flag) begin
            LFSR[0] <= feedback                                                     ;
            LFSR[1] <= i_LFSR[0]                                                    ;
            LFSR[2] <= i_LFSR[1] ^ feedback                                         ;
            LFSR[3] <= i_LFSR[2] ^ feedback                                         ;
            LFSR[4] <= i_LFSR[3]                                                    ;
            LFSR[5] <= i_LFSR[4]                                                    ;
            LFSR[6] <= i_LFSR[5]                                                    ;
            LFSR[7] <= i_LFSR[6] ^ feedback                                         ;


            first_flag <= 0                                                         ;
        end else if(i_valid) begin
            //! generates LFSR sequence
            
            LFSR[0] <= feedback                                                     ;
            LFSR[1] <= LFSR[0]                                                      ;
            LFSR[2] <= LFSR[1] ^ feedback                                           ;
            LFSR[3] <= LFSR[2] ^ feedback                                           ;
            LFSR[4] <= LFSR[3]                                                      ;
            LFSR[5] <= LFSR[4]                                                      ;
            LFSR[6] <= LFSR[5]                                                      ;
            LFSR[7] <= LFSR[6] ^ feedback                                           ;

            next_LFSR <= LFSR                                                       ;  

            if(i_LFSR == LFSR) 
            begin //valid
                
                valid_counter <= valid_counter + 1                                  ;
                invalid_counter <= 0                                                ;
                if(valid_counter>= 5) begin         
                    aux_lock <= 1                                                   ;
                    valid_counter <= 0                                              ;
                end

            end else if (i_LFSR != next_LFSR) 
            begin //invalid
                
                invalid_counter <= invalid_counter + 1                              ;
                valid_counter <= 0                                                  ;
                if(invalid_counter>=3) begin            
                    aux_lock=0                                                      ;
                    invalid_counter <= 0                                            ;    
                end
            end
        end

    end
    
end

assign feedback = first_flag ? i_LFSR[7] : LFSR[7] ^ (LFSR[6:0]==7'b0000000)        ;
assign o_LFSR_checker = LFSR                                                        ;
assign o_lock =aux_lock                                                             ;


endmodule
