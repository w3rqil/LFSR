
# Entity: LFSR_generator 
- **File**: LFSR_generator.v

## Diagram
![Diagram](LFSR_generator.svg "Diagram")
## Ports

| Port name    | Direction | Type       | Description                                        |
| ------------ | --------- | ---------- | -------------------------------------------------- |
| clk          | input     | wire       |                                                    |
| i_valid      | input     | wire       |                                                    |
| i_rst        | input     | wire       | Reset asincrónico para fijar el valor de seed      |
| i_soft_reset | input     | wire       | Reset sincrónico para registrar el valor de i_seed |
| i_seed       | input     | wire [7:0] | Seed inicial                                       |
| o_LFSR       | output    | reg [7:0]  | Salida del LFSR                                    |

## Signals

| Name               | Type      | Description |
| ------------------ | --------- | ----------- |
| feedback = LFSR[7] | wire      |             |
| LFSR               | reg [7:0] |             |
| seed               | reg [7:0] |             |

## Processes
- unnamed: ( @(posedge clk or posedge i_rst) )
  - **Type:** always
- unnamed: ( @(posedge clk) )
  - **Type:** always
  - **Description**
 muestro en la salida el valor del LFSR solo si i_valid está activo 
