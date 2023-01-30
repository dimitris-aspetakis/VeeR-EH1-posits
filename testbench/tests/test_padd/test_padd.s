#include "defines.h"

#define STDOUT 0xd0580000


// Code to execute
.section .text
.global _start
_start:

    // Load posit 0.125 to register pr1
    la x3, posit_0dot125
    nop
    nop
    nop
    //      |----im----||-x3|010|pr1|0001011
    .word 0b00000000000000011010000010001011
    //lw x1, 0(x3)    // Equivalent lw to the plw

    // Load posit 0.875 to register pr2
    la x3, posit_0dot875
    nop
    nop
    nop
    //      |----im----||-x3|010|pr2|0001011
    .word 0b00000000000000011010000100001011
    //lw x2, 0(x3)    // Equivalent lw to the plw
    nop
    nop
    nop
    nop
    nop

    // Add pr1 and pr2, storing it in pr3
    //      |--im-||pr2||pr1|000|prd|1011011
    .word 0b00000000001000001000000111011011

    // Store register pr3 to result
    la x4, result
    nop
    nop
    nop
    nop
    nop
    nop
    //      |-im--||pr3||-x4|010|-im|0101011
    .word 0b00000000001100100010000000101011
    //sw x3, 0(x4)    // Equivalent sw to the psw

    // Load result (which came from the posit addition) to register x5
    lw x5, 0(x4)

    // Load posit 1.0 (which came directly from memory) to register x6
    la x3, posit_1dot0
    lw x6, 0(x3)

    // Check if x5 == x6
    beq x5, x6, equal

    // The test is unsuccessful
    li x2, STDOUT
    addi x1, x0, 1
    sb x1, 0(x2)
    j _finish

    // Write 0 to STDOUT if we passed the test
equal:
    li x2, STDOUT
    sb x0, 0(x2)

    // Write 0xff to STDOUT for TB to terminate test.
_finish:
    addi x7, x0, 0xff
    sb x7, 0(x2)

.data
posit_0dot125:
    .word 0b00101000000000000000000000000000
posit_0dot875:
    .word 0b00111110000000000000000000000000
posit_1dot0:
    .word 0b01000000000000000000000000000000
result:
    .align 4
    .space 4
