.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    # Prologue
    li t6, 1
    blt a2, t6, exit_5
    blt a3, t6, exit_6
    blt a4, t6, exit_6

    add t0, x0, x0 # dot product
    add t1, x0, x0 # index

    slli a3, a3, 2 # stride of a3
    slli a4, a4, 2 # stride of a4

loop_start:
    beq t1, a2, loop_end
    mul t2, a3, t1
    add t2, t2, a0
    mul t3, a4, t1
    add t3, t3, a1

    lw t2, 0(t2)  
    lw t3, 0(t3)
    mul t2, t2, t3

    add t0, t0, t2
    addi t1, t1, 1

    j loop_start

loop_end:
    # Epilogue
    add a0, t0, x0
    ret

exit_5:
    li a1, 5
    jal exit2

exit_6:
    li a1, 6
    jal exit2