.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    li, t0, 1
    blt a1, t0, exit_2 
    blt a2, t0, exit_2
    blt a4, t0, exit_3
    blt a5, t0, exit_3
    bne a2, a4, exit_4

    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)

    mv s0, a0
    mv s1, a1 # of rows (height) of m0
    mv s2, a2 # of columns (width) of m0
    mv s3, a3
    mv s4, a4 # of rows (height) of m1
    mv s5, a5 # of columns (width) of m1
    mv s6, a6 # pointer to the start of d

    li s7, 0

outer_loop_start:
    beq s7, s1, outer_loop_end # for every row of m0
    li s8, 0

inner_loop_start:
    beq s8, s5, inner_loop_end # for every column of m1
    addi t0, x0, 4
    mul t0, t0, s2
    mul t0, t0, s7
    add t0, t0, s0

    addi t1, x0, 4
    mul t1, t1, s8
    add t1, t1, s3

    mv a0, t0
    mv a1, t1

    # bug here
    mv a2, s2
    addi a3, x0, 1
    mv a4, s5
    
    # FUNCTION: Dot product of 2 int vectors
    # Arguments:
    #   a0 (int*) is the pointer to the start of v0
    #   a1 (int*) is the pointer to the start of v1
    #   a2 (int)  is the length of the vectors
    #   a3 (int)  is the stride of v0
    #   a4 (int)  is the stride of v1

    jal, ra, dot

    addi t2, x0, 4
    mul t2, t2, s5
    mul t2, t2, s7
    addi t3, x0, 4
    mul t3, t3, s8
    add t2, t2, t3
    add t2, t2, s6

    sw a0, 0(t2)

    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    addi s7, s7, 1
    j outer_loop_start

outer_loop_end:

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40

    ret

exit_4:
    li a1 4
    jal exit2

exit_2:
    li a1 2
    jal exit2

exit_3:
    li a1 3
    jal exit2