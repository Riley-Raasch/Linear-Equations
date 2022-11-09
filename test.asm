.data
    input: .float 0.0
    array: .float 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
.text

main:
lwc1 $f1, input
la $s1, array

li $t1, 0 #number of inputs put in array
li $t2, 12 # stores 12

inputLoop:

#read float
li $v0, 6
syscall

#save in array
swci $f0, 0($s1)

#print float
li $v0, 2
add.s $f12, $f0, $f1
syscall

#increment index
addi $t1, $t1, 1 #i++

#when it takes 12 inputs stop
beq $t1, $t2, endProgram
addi $s1, $zero, 4 #next element pls

j inputLoop

endProgram:
li $v0, 10      
syscall