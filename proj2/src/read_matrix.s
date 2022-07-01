.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp) # the pointer to string representing the filename
    sw s1, 4(sp) # the number of rows
    sw s2, 8(sp) # the number of columns
    sw s3, 12(sp) # pointer to the matrix in memory
    sw s4, 16(sp) # file descriptor
    sw s5, 20(sp) # number of entries in the matrix
    sw ra, 24(sp)
	
    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    
    # fopen arguments loading
    mv a1, s0
    li a2, 0
    # call fopen
    jal fopen
    # check if fopen fails
    li t0, -1
    beq a0, t0, exit_50
    # file descriptor returned by fopen
    mv s4, a0

    # read the number of rows
    mv a1, s4
    # a2 (pointer) read the bytes from the file into
    mv a2, s1
    li a3, 4
    # call fread
    jal fread
    # check if fread fails
    bne a0, a3, exit_51
    # read the number of cols
    mv a1, s4
    mv a2, s2
    li a3, 4
    jal fread
    bne a0, a3, exit_51

    # allocate memory for the matrix
    lw t0, 0(s1) # num of rows
    lw t1, 0(s2) # num of cols
    mul a0, t0, t1
    li t0, 4
    mul a0, a0, t0
    mv s5, a0
    jal malloc
    beq a0, x0, exit_48

    # save the returned pointer for future return
    mv s3, a0

    # read the matrix
    # read consecutive entries automatically 
    mv a1, s4
    mv a2, s3
    mv a3, s5
    jal fread
    bne a0, s5, exit_51

    # fclose
    mv a1, s4
    jal fclose
    li t0, -1
    beq a0, t0, exit_52

    # return 
    mv a0, s3

    # Epilogue
    lw s0, 0(sp) 
    lw s1, 4(sp) 
    lw s2, 8(sp) 
    lw s3, 12(sp) 
    lw s4, 16(sp) 
    lw s5, 20(sp) 
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

exit_48:
    li a1, 48
    jal exit2

exit_50:
    li a1, 50
    jal exit2

exit_51:
    li a1, 51
    jal exit2

exit_52:
    li a1, 52
    jal exit2

