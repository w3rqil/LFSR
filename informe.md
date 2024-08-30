


# Actividad 1

Para empezar, luego de instalar el software *"wine"* para poder ejecutar el  archivo 'LFSRTestbench.exe', se probaron distintas combinaciones hasta llegar a la combinación con el patrón más grande.

IMAGEN ACA

Luego de obtener de la aplicación la combinación, y el código, a utilizar durante las siguientes actividades. Se plantea el código sencillo [LFSR_generator.v](/src/LFSR_generator.v) que cumple con la actividad propiesta 1.

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


A continuación un diagrama de flujos para entender el funcionamiento del mismo.

![Flowchart Diagram](/img/LFSRGeneratorFlowChart.png)



# Actividad 2

## Resultados
A continuación una captura de la simulación en vivado donde se puede ver la similitud en la secuencia generada por el código y la que genera [LFSRtestbench.exe](LFSRTestbench.exe).

![actv2Image](/img/lfsr_secquence_first_aproach.png)

## Tener en cuenta
1) la secuencia se genera de forma "inversa" a la mostrada por la aplicación

2) Como el valor *i_valid* se genera con una instrucción $random, el bucle for no necesariamente va a generar la secuencia completa con un el valor **i < 256**

# Actividad 3

## Resultados

### CHECK_PERIODICITY

A continuación una captura de la simulación en vivado:

![checkPeriodicity](/img/lfsr_check_periodicity.png)


### CHECK_PERIODICITY_RANDOM_SEED

A continuación se presenta una captura de la simulación en vivado:

![periodicityRandomSeed](/img/lfsr_check_periodicity_random.jpeg)

Se puede ver que se cumple el ciclo y vuelve a encontrar el valaor inicial.
- Para generar una seed random se utilizó: *i_seed= $random % 256 ;* y luego se activa el soft_reset para que se pueda cargar el valor de seed. 

# LFSR_checker

## idea
El módulo debe tomar el valor de salida del módulo lfsr_generate, generar un nuevo shifteo tomando éste como seed, ahora ya sé cuál es el próximo valor que debería recibir de entrada.

Debido a lo explicado previamente, el primer valor que el generador le envíe será considerado com invalido, ya que el módulo LFSR_checker no va a tener con qué comparar.

A continuación una primer prueba donde se enviaron 5 valores válidos, y se puede ver que la salida **o_lock** pasa a ser un valor positivo, seguido de éstos se envían 4 valores negativos y se puede observar el cambio de estado en la salida.

![lfsrchecker1](/img/first_aproach_LFSRchecker.png)

## Resultados


## TEST1
 ![checkerTEST1](/img/LFSR_checker_TEST1log.png)

## TEST2

Hacer un test en donde 4 datos sean válidos y 1 invalido.
Verificar que nunca se lockee.
Para este test se pide enviar 4 datos validos y uno invalido y verificar que no cambie la salida o_lock
A continuación muestro el log por consola donde se ve que el valor oo_lock no cambia durante el test:

![checkerTEST122](/img/LFSR_checker_TEST2log.png)

## TEST3

En este test se envían 5 ciclos válidos y 3 ciclos invalidos. Se puede ver en el waveform que la salida o_lock comienza en 0, luego del primer ciclo válido cambia a 1 durante el resto de los ciclos válidos. Finalmente luego de sus primeros 3 valores inválidos cambia a 0 hasta el final de la simulación.

![checkerTEST3](/img/LFSR_checker_TEST3waveform.png)

**Console log: Actv. 5 TEST3.**
``` 

run all
 VALID value detected
 input LFSR value: 00000001
 LFSR value: 00000010
 NEXT LFSR value: 00000001
 valid_counter: 1
 VALID value detected
 input LFSR value: 00000010
 LFSR value: 00000100
 NEXT LFSR value: 00000010
 valid_counter: 2
 VALID value detected
 input LFSR value: 00000100
 LFSR value: 00001000
 NEXT LFSR value: 00000100
 valid_counter: 3
 VALID value detected
 input LFSR value: 00001000
 LFSR value: 00010000
 NEXT LFSR value: 00001000
 valid_counter: 4
 VALID value detected
 input LFSR value: 00010000
 LFSR value: 00100000
 NEXT LFSR value: 00010000
 valid_counter: 5
--------------------
Output LOCK: 1
--------------------
 VALID value detected
 input LFSR value: 00100000
 LFSR value: 01000000
 NEXT LFSR value: 00100000
 valid_counter: 1
 VALID value detected
 input LFSR value: 01000000
 LFSR value: 10000000
 NEXT LFSR value: 01000000
 valid_counter: 2
 VALID value detected
 input LFSR value: 10000000
 LFSR value: 00000000
 NEXT LFSR value: 10000000
 valid_counter: 3
 VALID value detected
 input LFSR value: 00000000
 LFSR value: 10001101
 NEXT LFSR value: 00000000
 valid_counter: 4
 VALID value detected
 input LFSR value: 10001101
 LFSR value: 10010111
 NEXT LFSR value: 10001101
 valid_counter: 5
--------------------
Output LOCK: 1
--------------------
 VALID value detected
 input LFSR value: 10010111
 LFSR value: 10100011
 NEXT LFSR value: 10010111
 valid_counter: 1
 VALID value detected
 input LFSR value: 10100011
 LFSR value: 11001011
 NEXT LFSR value: 10100011
 valid_counter: 2
 VALID value detected
 input LFSR value: 11001011
 LFSR value: 00011011
 NEXT LFSR value: 11001011
 valid_counter: 3
 VALID value detected
 input LFSR value: 00011011
 LFSR value: 00110110
 NEXT LFSR value: 00011011
 valid_counter: 4
 VALID value detected
 input LFSR value: 00110110
 LFSR value: 01101100
 NEXT LFSR value: 00110110
 valid_counter: 5
--------------------
Output LOCK: 1
--------------------
 VALID value detected
 input LFSR value: 01101100
 LFSR value: 11011000
 NEXT LFSR value: 01101100
 valid_counter: 1
 VALID value detected
 input LFSR value: 11011000
 LFSR value: 00111101
 NEXT LFSR value: 11011000
 valid_counter: 2
 VALID value detected
 input LFSR value: 00111101
 LFSR value: 01111010
 NEXT LFSR value: 00111101
 valid_counter: 3
 VALID value detected
 input LFSR value: 01111010
 LFSR value: 11110100
 NEXT LFSR value: 01111010
 valid_counter: 4
 VALID value detected
 input LFSR value: 11110100
 LFSR value: 01100101
 NEXT LFSR value: 11110100
 valid_counter: 5
--------------------
Output LOCK: 1
--------------------
 VALID value detected
 input LFSR value: 01100101
 LFSR value: 11001010
 NEXT LFSR value: 01100101
 valid_counter: 1
 VALID value detected
 input LFSR value: 11001010
 LFSR value: 00011001
 NEXT LFSR value: 11001010
 valid_counter: 2
 VALID value detected
 input LFSR value: 00011001
 LFSR value: 00110010
 NEXT LFSR value: 00011001
 valid_counter: 3
 VALID value detected
 input LFSR value: 00110010
 LFSR value: 01100100
 NEXT LFSR value: 00110010
 valid_counter: 4
 VALID value detected
 input LFSR value: 01100100
 LFSR value: 11001000
 NEXT LFSR value: 01100100
 valid_counter: 5
--------------------
Output LOCK: 1
--------------------
NOT valid value detected
 input LFSR value: 01100100
 LFSR value: 00011101
 NEXT LFSR value: 11001000
 invalid_counter: 1
NOT valid value detected
 input LFSR value: 11001001
 LFSR value: 00111010
 NEXT LFSR value: 00011101
 invalid_counter: 2
NOT valid value detected
 input LFSR value: 00011100
 LFSR value: 01110100
 NEXT LFSR value: 00111010
 invalid_counter: 3
--------------------
Output LOCK: 0
--------------------
NOT valid value detected
 input LFSR value: 00111011
 LFSR value: 11101000
 NEXT LFSR value: 01110100
 invalid_counter: 4
--------------------
Output LOCK: 0
--------------------
NOT valid value detected
 input LFSR value: 01110101
 LFSR value: 01011101
 NEXT LFSR value: 11101000
 invalid_counter: 5
--------------------
Output LOCK: 0
--------------------
NOT valid value detected
 input LFSR value: 11101001
 LFSR value: 10111010
 NEXT LFSR value: 01011101
 invalid_counter: 6
--------------------
Output LOCK: 0
--------------------
NOT valid value detected
 input LFSR value: 01011100
 LFSR value: 11111001
 NEXT LFSR value: 10111010
 invalid_counter: 7
--------------------
Output LOCK: 0
--------------------
NOT valid value detected
 input LFSR value: 10111011
 LFSR value: 01111111
 NEXT LFSR value: 11111001
 invalid_counter: 0
NOT valid value detected
 input LFSR value: 11111000
 LFSR value: 11111110
 NEXT LFSR value: 01111111
 invalid_counter: 1
NOT valid value detected
 input LFSR value: 01111110
 LFSR value: 01110001
 NEXT LFSR value: 11111110
 invalid_counter: 2
NOT valid value detected
 input LFSR value: 11111111
 LFSR value: 11100010
 NEXT LFSR value: 01110001
 invalid_counter: 3
--------------------
Output LOCK: 0
--------------------
$finish called at time : 5950 ns : File "/home/leonel/Desktop/vivado_projects/lfsr_project/lfsr_project.srcs/sim_1/new/tb_LFSR_generator.v" Line 117

```