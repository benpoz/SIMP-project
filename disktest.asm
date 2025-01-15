# Move contents of first 8 sectors one sector forward

# Initialize disk command registers
add $a0, $zero, $zero, $imm1, 7 , 0                     # Set $a0=7                 000
out $zero, $imm1, $zero, $imm2, 16 , 100                # Set buffer address

Loop_Read:
    blt $zero, $a0, $zero, $imm1, end, 0                 # if $a0<0 end loop         002
    in $a1, $imm1, $zero, $zero, 17, 0                  # Read status
    beq $zero, $a1, $imm1, $imm2, 1, Loop_Read          # Wait until not busy
    out $zero, $imm1, $zero, $a0, 15, 1                 # set sector index as $a0  
    out $zero, $imm1, $zero, $imm2, 14, 1               # set disk to read mode
    add $t0, $a0, $zero, $imm1, 1, 0                    # Set $t0= $a0 +1

Loop_write:
    in $a1, $imm1, $zero, $zero, 17, 0                  # Read status               008
    beq $zero, $a1, $imm1, $imm2, 1, Loop_write         # Wait until not busy
    out $zero, $imm1, $zero, $t0, 15, 1                 # set sector index as $a0+1  
    out $zero, $imm1, $zero, $imm2, 14, 2               # set disk to write mode
    sub $a0, $a0, $zero, $imm1, 1, 0                    # a0--
    beq $zero, $zero, $zero, $imm1, Loop_Read, 0        # return to read_loop

end:
    in $a1, $imm1, $zero, $zero, 17, 0                  # Read status               00E
    beq $zero, $a1, $imm1, $imm2, 1, end                # Wait until not busy
    out $zero, $imm1, $zero, $imm2, 14, 0               # set disk to write mode
    halt $zero ,$zero ,$zero ,$zero , 0, 0              # finish
