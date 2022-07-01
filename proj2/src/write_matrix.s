.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0, 0(sp)  # pointer to string representing the filename
    sw s1, 4(sp)  # pointer to the start of the matrix in memory
    sw s2, 8(sp)  # number of rows 
    sw s3, 12(sp) # number of columns
    sw s4, 16(sp) # file descriptor
    sw ra, 20(sp)

    # assign variables
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    # open the file
    mv a1, s0
    li a2, 1
    jal fopen
    # check if fopen fails
    li t0, -1
    beq a0, t0, exit_53

    # saves the file descriptor
    mv s4, a0

    # write the row
    li a0, 4
    jal malloc
    sw s2, 0(a0)
    mv a1, s4
    mv a2, a0
    li a3, 1
    li a4, 4
    jal fwrite
    bne a0, a3, exit_54

    # write the col
    li a0, 4
    jal malloc
    sw s3, 0(a0)
    mv a1, s4
    mv a2, a0
    li a3, 1
    li a4, 4
    jal fwrite
    bne a0, a3, exit_54

    # write the entries
    mv a1, s4
    mv a2, s1
    mul t0, s2, s3
    mv a3, t0
    li a4, 4
    jal fwrite
    bne a0, a3, exit_54

    # close the file
    mv a1, s4
    jal fclose
    li t0, -1
    beq a0, t0, exit_55

    # Epilogue
    lw s0, 0(sp)  
    lw s1, 4(sp)  
    lw s2, 8(sp)  
    lw s3, 12(sp) 
    lw s4, 16(sp) 
    lw ra, 20(sp)
    addi sp, sp, 24

    ret

exit_53:
    li a1, 53
    jal exit2

exit_54:
    li a1, 54
    jal exit2

exit_55:
    li a1, 55
    jal exit2