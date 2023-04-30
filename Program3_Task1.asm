# FriendlyAssembly: CS2640
# Date: 5/7/2023
# Objective:
# Write an Assembly program that will return a letter grade for each element in an array 
# - (e.g. test scores in an array of scores)

# Use the following scores array data in your program:
# int scores = [32, 56, 78, 66, 88, 90, 93, 100, 101, 82]

# Include the following in your program:
# - a main label, a looping label, and an exit label
# - a loop counter
# - a separate case for grades above 100 (i.e. prints out "A with Extra Credit")
# - your name printed out after all the grades are read (and before the program exits)

.data
intScores: .word 32, 56, 78, 66, 88, 90, 93, 100, 101, 82
prompt1: .asciiz "The grade for "
prompt2: .asciiz " is: "
separatorLine: .asciiz "\n"
userGrade: .asciiz "The grade is: "
exitPrompt: .asciiz "The program will now exit."

#letter grade values for user display
letterA: .asciiz "A"
letterB: .asciiz "B"
letterC: .asciiz "C"
letterD: .asciiz "D"
letterF: .asciiz "F"
extraCreditA: .asciiz "A with extra credit"

.text
main:
	#loading address of "array: into $s0 
	la $s0, intScores 
	
	#initializing $t7 as loop counter 
	move $t7, $zero  
	
displayInt:
	#get the current of the array
	lw $t0, 0($s0)
	
	#display prompt1 to user 
	li $v0, 4
	la $a0, prompt1
	syscall 
	
	#print $t0 to user (current element) 
	li $v0, 1
	move $a0, $t0
	syscall 
	
	#display prompt2 to user 
	li $v0, 4
	la $a0, prompt2
	syscall 

	#jump to specific label based on score
	ble $t0, 59, gradeF
	ble $t0, 69, gradeD
	ble $t0, 79, gradeC
	ble $t0, 89, gradeB
	ble $t0, 100, gradeA
	ble $10, 1000, extraCredit
	
	j increment
	
increment:
	#increment the base address by 4 (move to next element)
	addi $s0, $s0, 4 #s0 is base address so increment base address by 1 word (4bytes)
	
	#increment the loop counter 
	addi $t7, $t7, 1 
	
	#branch if loop counter is greater than number of array elements 
	beq $t7, 10, exit
	
	j displayInt
	
extraCredit:
	#print letter grade A
	li $v0, 4
	la $a0, extraCreditA
	syscall
	
	li $v0, 4
	la $a0, separatorLine
	syscall
	
	j increment
	
gradeA:
	#print letter grade A
	li $v0, 4
	la $a0, letterA
	syscall
	
	li $v0, 4
	la $a0, separatorLine
	syscall
	
	j increment
	
gradeB:
	#print letter grade B
	li $v0, 4
	la $a0, letterB
	syscall
	
	li $v0, 4
	la $a0, separatorLine
	syscall
	
	j increment
	
gradeC:
	#print letter grade C
	li $v0, 4
	la $a0, letterC
	syscall
	
	li $v0, 4
	la $a0, separatorLine
	syscall
	
	j increment
	
gradeD:
	#print letter grade D
	li $v0, 4
	la $a0, letterD
	syscall
	
	li $v0, 4
	la $a0, separatorLine
	syscall
	
	j increment
	
gradeF:
	#print letter grade F
	li $v0, 4
	la $a0, letterF
	syscall
	
	li $v0, 4
	la $a0, separatorLine
	syscall
	
	j increment

exit:
	#display exitPrompt to user 
	li $v0, 4
	la $a0, exitPrompt
	syscall 
	
	#exit program
     	li $v0, 10
     	syscall
