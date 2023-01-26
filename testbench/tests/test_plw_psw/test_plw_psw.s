#include "defines.h"

#define STDOUT 0xd0580000


// Code to execute
.section .text
.global main
main:

    // Load posit 0.125 to register pr1
    la x3, posit_0dot125
    //      |----im----||-x3|010|pr1|0001011
    .word 0b00000000000000011010000010001011

    // Store register pr1 to result
    la x4, result
    //      |-im--||pr1||-x4|010|im|0101011
    .word 0b0000000000010010001000000101011

    // Load result (which came from the posit rf) to register x5
    lw x5, 0(x4)

    // Load posit 0.125 (which came directly from memory) to register x6
    lw x6, 0(x3)

    // Check if x5 == x6
    beq x5, x6, equal

    // The test is unsuccessful
    li x2, STDOUT
    addi x1, x0, 1
    sb x1, 0(x2)
    j finish

    // Write 0 to STDOUT if we passed the test
equal:
    li x2, STDOUT
    sb x0, 0(x2)

    // Write 0xff to STDOUT for TB to terminate test.
finish:
    addi x7, x0, 0xff
    sb x7, 0(x2)

.data
posit_0dot125:
    .word 0b00101000000000000000000000000000
result:
    .align 4
    .space 4
