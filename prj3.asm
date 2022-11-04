.data
    array: .space 20 
    input: .space 20 
    exceptionMessage: .asciiz "input error!"
    x1: .asciiz "x1 = "
    x2: .asciiz "x2 = " 
    x3: .asciiz "x3 = "       
    newLine: .asciiz "\n"

.text

main:
la $s0, array #the array is in $s0

li $t1, 1 #number of inputs put in array
li $t2, 12 # stores 12

inputLoop:

#read float
lwc1 $f0, input 
li $v0, 6
syscall

#save in array
swc1 $f1 ($s0)

#increment index
addi $t1, $t1, 1 #i++

#when it takes 12 inputs stop
beq $t1, $t2, stop 

#next element in array
addi $s0, $s0, 4 

stop:
j $ra 


endProgram:
li $v0, 10      
syscall