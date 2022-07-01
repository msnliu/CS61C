.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    addi sp, sp, -8
    # pass in those memory addresses as arguments
    addi t0, sp, 0
    addi t1, sp, 4

    mv a1, t0
    mv a2, t1

    la a0, file_path

    jal read_matrix

    # Print out elements of matrix
    lw a1, 0(sp)
    lw a2, 4(sp)
    jal print_int_array

    # Terminate the program
    addi sp, sp, 8
    jal exit