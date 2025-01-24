.word 0x100 15                                  # initialize n, k in data memory
.word 0x101 8

sll $sp, $imm1, $imm2, $zero, 1, 11             # set $sp = 1 << 11 = 2048
lw $a0, $imm1 ,$zero, $zero 0x100, 0            # load n
lw $a1, $imm1 ,$zero, $zero 0x101, 0            # load k
jal $ra, $zero, $zero, $imm2, 0, BIN		    # calc $v0
sw $zero, $zero, $imm2, $v0, 0, 0x102
halt $zero, $zero, $zero, $zero, 0, 0   

BIN:
    add $sp, $sp, $imm2, $zero, 0, -4		    # adjust stack for 4 items
    sw $zero, $sp, $imm2, $s0, 0, 3			    # save $s0
    sw $zero, $sp, $imm2, $ra, 0, 2			    # save return address
    sw $zero, $sp, $imm2, $a0, 0, 1
    sw $zero, $sp, $imm2, $a1, 0, 0         
    beq $zero, $a1, $zero, $imm1, BASE, 0       # base conditions
    beq $zero, $a1, $a0, $imm1, BASE, 0
    beq $zero, $zero, $zero, $imm2, 0, LOOP 

BASE:
    add $v0, $zero, $imm1, $zero, 1, 0          # Return 1
    beq $zero, $zero, $zero, $imm2, 0, EXIT     

LOOP:
    sub $a0, $a0, $imm1, $zero, 1, 0            # n-1
    sub $a1, $a1, $imm1, $zero, 1, 0            # k-1
    jal $ra, $zero, $zero, $imm1, BIN, 0
    add $s0, $v0, $imm2, $zero, 0, 0            # $s0 = binom(n-1, k)
    lw $a0, $sp, $imm2, $zero, 0, 1             # restore $a0 = n
    lw $a1, $sp, $imm2, $zero, 0, 0             # restore $a1 = k
    sub $a0, $a0, $imm1, $zero, 1, 0        
    jal $ra, $zero, $zero, $imm1, BIN, 0
    add $v0, $v0, $s0, $zero, 0, 0
    lw $a1, $sp, $imm2, $zero, 0, 0
    lw $a0, $sp, $imm2, $zero, 0, 1
    lw $ra, $sp, $imm2, $zero, 0, 2
    lw $s0, $sp, $imm2, $zero, 0, 3

EXIT:
    add $sp, $sp, $imm2, $zero, 0, 4		    # pop 4 items from stack
    beq $zero, $zero, $zero, $ra, 0, 0		    # return