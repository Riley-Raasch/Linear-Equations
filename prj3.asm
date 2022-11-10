.data
    size: .word 12
    input: .float 0.0
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

inputLoop:

#read float
li $v0, 6
syscall

#save in array
swc1 $f0, 0($s1)

lwc1 $f1, 0($s1)

#increment index
addi $t1, $t1, 1 #i++

#when it takes 12 inputs stop
beq $t1, $t2, GaussianElimination
addi $s0, $s0, 4 #next element pls

j inputLoop


#Gaussian Elimination
GaussianElimination:
#row 1
#divide each value in row 1 (including result) by row 1, column 1
    
    #store row 1, column 1
    lwc1 $t0, 0($s0)
    #divide
    div $t1, $t0, $t0 #r1, c1 = 1
    swc1 $t1, 0($s0) #store back into array

    #increment index
    addi $s0, $s0, 4

    lwc1 $t2, 0($s0) #r1, c2
    div $t2, $t2, $t0 # (r1, c2)/(r1, c1)
    swc1 $t2, 0($s0)

    #increment index
    addi $s0, $s0, 4

    lwc1 $t3, 0($s0) #r1, c3
    div $t3, $t3, $t0 #(r1, c3)/(r1, c1)
    swc1 $t3, 0($s0)


#each row 2 value - corresponding row 1 values
    
    

#each row 3 value - row 1 result*corresponding row 1 value

#row 2
#each second row value / row 2, column 2
#each row 1 value - corresponding row 2 values
#each row 3 value - row 3, column 2* corresponding row 2 values

#row 3
#each row 3 value / row 3, column 3
#each row 1 value - corresponding row 3 value
#each row 2 value - row 2, column 3*corresponding row 3 value



print:
#start with first result index (i=9)
addi $s0, $s0, -8

#print x1 = 
li $v0, 4
la $a0, x1
syscall 

#print float
li $v0, 2
l.s $f12, 0($s0)
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
l.s $f12, 4($s0)
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
l.s $f12, 8($s0)
syscall

#new line
li $v0, 4
la $a0, newLine
syscall

endProgram:
li $v0, 10      
syscall