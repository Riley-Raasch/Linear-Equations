.data
    size: .word 12
    input: .float 0.0
    zero: .float 0.0
    array: .float 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0
    noSolution: .asciiz "no solution"
    x1: .asciiz "x1 = "
    x2: .asciiz "x2 = " 
    x3: .asciiz "x3 = "       
    newLine: .asciiz "\n"
.text

main:
lwc1 $f1, input

#size
la $s1, size
lw $s2, 0($s1)
la $s0, array #array in $s0

li $t1, 0 #number of inputs put in array (i)
li $t2, 12 # stores 12
lwc1 $f30, zero

inputLoop:

#read float
li $v0, 6
syscall

#save in array
swc1 $f0, 0($s0)

lwc1 $f1, 0($s0)

#increment index
addi $t1, $t1, 1 #i++

#when it takes 12 inputs stop
beq $t1, $t2, GaussianElimination
addi $s0, $s0, 4 #next element 

j inputLoop


#Gaussian Elimination
GaussianElimination:

#start with A[0]
addi $s0, $s0, -44

#put each element into a float register
lwc1 $f2, 0($s0) #(1,1) in $f2
lwc1 $f3, 4($s0) #(1,2) in $f3
lwc1 $f4, 8($s0) #(1,3) in $f4
lwc1 $f5, 12($s0) #(2,1) in $f5
lwc1 $f6, 16($s0) #(2,2) in $f6
lwc1 $f7, 20($s0) #(2,3) in $f7
lwc1 $f8, 24($s0) #(3,1) in $f8
lwc1 $f9, 28($s0) #(3,2) in $f9
lwc1 $f10, 32($s0) #(3,3) in $f10
lwc1 $f11, 36($s0) #result 1 in $f11
#skip $f12 because we need that to print later
lwc1 $f13, 40($s0) #result 2 in $f13
lwc1 $f14, 44($s0) #result 3 in $f14

#row 1
#divide each value in row 1 (including result) by row 1, column 1

    #divide (1,2)/(1,1) and store it back into (1,2)
    div.s $f3, $f3, $f2

    #divide (1,3)/(1,2)
    div.s $f4, $f4, $f2 

    #divide result 1/(1,1)
    div.s $f11, $f11, $f2     

    #finally make (1,1) 1 by dividing by itself
    div.s $f2, $f2, $f2

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30

#each row 2 value - corresponding row 1 values

    #(2,1)=(2,1)-(1,1)
    sub.s $f5, $f5, $f2

    #(2,2)-=(1,2)
    sub.s $f6, $f6, $f3
    #zero check
    c.eq.s $f6, $f30
    bc1t exception

    #(2,3)-=(1,3)
    sub.s $f7, $f7, $f4

    #result 2 -= result 1
    sub.s $f13, $f13, $f11

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30

#each row 3 value - row 1 result*corresponding row 1 value
    
    #(3,1)= (3,1) - result 1 * (1,1)
    mul.s $f31, $f11, $f2 #$f31 is tmp variable
    sub.s $f8, $f8, $f31

    #(3,2)=(3,2) - result 1 * (1,2)
    mul.s $f31, $f11, $f3
    sub.s $f9, $f9, $f31

    #(3,3)=(3,3) - result 1 * (1,3)
    mul.s $f31, $f11, $f4
    sub.s $f10, $f10, $f31
    #zero check
    c.eq.s $f10, $f30
    bc1t exception

    #result 3 = result 3 - result 1 * result 1
    mul.s $f31, $f11, $f11
    sub.s $f14, $f14, $f31

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30

#row 2
#each second row value / row 2, column 2

    #(2,1) = (2,1)/(2,2)
    div.s $f5, $f5, $f6

    #(2,3) = (2,3)/(2,2)
    div.s $f7, $f7, $f6

    #result 2 = result 2 / (2,2)
    div.s $f13, $f13, $f6

    #finally divide (2,2)/(2,2) to make it 1
    div.s $f6, $f6, $f6

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30

#each row 1 value - corresponding row 2 values

    #(1,1) = (1,1) - (2,1)
    sub.s $f2, $f2, $f5
    #zero check
    c.eq.s $f2, $f30
    bc1t exception

    #(1,2) = (1,2) - (2,2)
    sub.s $f3, $f3, $f6

    #(1,3) = (1,3) - (2,3)
    sub.s $f4, $f4, $f7

    #result 1 = result 1 - result 2
    sub.s $f11, $f11, $f13

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30

#each row 3 value - (3,2)* corresponding row 2 values

    #(3,1) = (3,1) - (3,2)*(2,1)
    mul.s $f31, $f9, $f5
    sub.s $f8, $f8, $f31

    #(3,3) = (3,3) - (3,2)*(2,3)
    mul.s $f31, $f9, $f7
    sub.s $f10, $f10, $f31
    #zero check
    c.eq.s $f10, $f30
    bc1t exception

    #result 3 = result 3 - (3,2) * result 2
    mul.s $f31, $f9, $f13
    sub.s $f14, $f14, $f31

    #(3,2) = (3,2) - (3,2)*(2,2) to make it 0 
    mul.s $f31, $f9, $f6
    sub.s $f9, $f9, $f31

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30

#row 3
#each row 3 value / (3,3)

    #(3,1)/(3,3)
    div.s $f8, $f8, $f10

    #(3,2)/(3,3)
    div.s $f9, $f9, $f10

    #result 3/(3,3)
    div.s $f14, $f14, $f10

    #(3,3)/(3,3)=1
    div.s $f10, $f10, $f10

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30

#each row 1 value - corresponding row 3 value

    #(1,1) - (3,1)
    sub.s $f2, $f2, $f8
    #zero check
    c.eq.s $f2, $f30
    bc1t exception

    #(1,2) - (3,2)
    sub.s $f3, $f3, $f9

    #(1,3) - (3,3)
    sub.s $f4, $f4, $f10

    #result 1 - result 3
    sub.s $f11, $f11, $f14

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30

#each row 2 value - row 2, column 3*corresponding row 3 value
    #(2,1) = (2,1) - (2,3)*(3,1)
    mul.s $f31, $f7, $f8
    sub.s $f5, $f5, $f31

    #(2,2) = (2,2) - (2,3)*(3,2)
    mul.s $f31, $f7, $f9
    sub.s $f6, $f6, $f31
    #zero check
    c.eq.s $f6, $f30
    bc1t exception

    #result 2 = result 2 - (2,3)* result 3
    mul.s $f31, $f7, $f14
    sub.s $f13, $f13, $f31

    #(2,3) = (2,3) - (2,3)*(3,2)=0
    mul.s $f31, $f7, $f10
    sub.s $f7, $f7, $f31

    #zero check
    c.eq.s $f10, $f30
    bc1t exception
    c.eq.s $f2, $f30
    bc1t exception
    c.eq.s $f6, $f30


print:

#print x1 = 
li $v0, 4
la $a0, x1
syscall 

#print float
li $v0, 2
mov.s $f12, $f11
syscall

#new line
li $v0, 4
la $a0, newLine
syscall

#print x2 = 
li $v0, 4
la $a0, x2
syscall

#print float
li $v0, 2
mov.s $f12, $f13
syscall

#new line
li $v0, 4
la $a0, newLine
syscall

#print x3 = 
li $v0, 4
la $a0, x3
syscall

#print float
li $v0, 2
mov.s $f12, $f14
syscall

#new line
li $v0, 4
la $a0, newLine
syscall

endProgram:
li $v0, 10      
syscall

exception:
#print no solution
li $v0, 4
la $a0, noSolution
syscall
j endProgram
