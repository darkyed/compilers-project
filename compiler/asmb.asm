.data

.text
li $t8,268500992
li $t0, 10
sw $t0,24($t8)

li $t0, 0
sw $t0,12($t8)

li $t0, 1
sw $t0,16($t8)

li $t0, 2
sw $t0,28($t8)

li $t0, 1
sw $t0,32($t8)

LabStartWhile0:lw $t0, 28($t8)
lw $t1, 24($t8)

bge $t0, $t1, NextPart0
lw $t0, 16($t8)
sw $t0,20($t8)

lw $t0, 12($t8)
lw $t1, 16($t8)
add $t0, $t0, $t1
sw $t0,16($t8)

lw $t0, 20($t8)
sw $t0,12($t8)

lw $t0, 32($t8)
lw $t1, 16($t8)
add $t0, $t0, $t1
sw $t0,32($t8)

lw $t0, 28($t8)
li $t1, 1
add $t0, $t0, $t1
sw $t0,28($t8)

j LabStartWhile0
NextPart0:
lw $t0, 32($t8)
li $t1, 0
add $t0, $t0, $t1
sw $t0,32($t8)


li $v0,1
move $a0,$t0
syscall
