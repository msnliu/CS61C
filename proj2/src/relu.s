.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    li t5, 1
    blt a1, t5, exit_relu

    add t0, x0, x0 # current index / multiplier
    addi t1, x0, 4 # multiplicant
    
loop_start:
    beq t0, a1, loop_end
    mul t2, t0, t1
    # missed the line below!
    add t2, t2, a0
    lw t3, 0(t2)
    # relu decision boundary
    bgt t3, x0, loop_continue
    sub t3, t3, t3
    sw t3, 0(t2)

loop_continue:
    addi t0, t0, 1
    j loop_start

loop_end:
	ret

exit_relu: 
    li a1, 8
    jal exit2