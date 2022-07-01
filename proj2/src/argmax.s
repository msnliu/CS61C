.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    # Prologue
    li t6, 1
    blt a1, t6, exit_argmax
    
    add t0, x0, x0 # multiplier
    addi t1, x0, 4 # multiplicant
    lw t2, 0(a0) # keep track of max / a0[0]
    add t3, x0, x0 # keep track of return index

loop_start:
    beq t0, a1, loop_end
    mul t4, t0, t1
    add t4, t4, a0
    lw t5, 0(t4)
    ble t5, t2, loop_continue
    mv t2, t5 # update max
    mv t3, t0 # update index

loop_continue:
    addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
    mv a0, t3
    ret

exit_argmax:
    li a1, 7
    jal exit2