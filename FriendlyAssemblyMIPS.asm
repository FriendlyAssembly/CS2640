#Friendly Assembly: CS2640.01
	#Jarisse Escubido
	#Moller Myint
	#Dayoung Kim
	#Vanisa Suadprathon
#Date: April 2, 2023
#Objective: 
#Task 1: User Input and Output
	# - Get user input
	# - move input to registers
	# - print input back to user
#Task 2: Arithmetic Operation Practice
	# - Add two values using "add" instruction
	# - Add two values using "add" instruction
	# - Add two values using "add" instruction
	# - Add two values using "add" instruction
	# - Output arithmetic results in "RUN I/O"
#Task 3: Conditions
	# - If inputs are equal, output "User inputs are the same"
	# - If inputs are not equal, output "User inputs are different"

.data
getFirstInt: .asciiz "Enter a number: "
getSecondInt: .asciiz "\nEnter another number: "

output1: .asciiz "\nThe first number you entered is: "
output2: .asciiz "\nThe second number you entered is: "

addOutput: .asciiz "\nThe sum is: "
subOutput: .asciiz "\nThe difference is: "
mulOutput: .asciiz "\nThe product is: "
divQuotient: .asciiz "\nThe quotient is: "
divRemainder: .asciiz "	Remainder: "
divideByZero: .asciiz "\nThe quotient is: underfined; divided by zero"

sameNumbers: .asciiz "\nUser inputs are the same"
diffNumbers: .asciiz "\nUser inputs are different"

.text
main:

	#Beginning of Task 1
	#print getFirstInt
	li $v0, 4
	la $a0, getFirstInt
	syscall
	
	#read integer and save value
	li $v0, 5
	syscall
	move $s0, $v0 #user value 1
	
	#print getSecondInt
	li $v0, 4
	la $a0, getSecondInt
	syscall
	
	#read integer and save value
	li $v0, 5
	syscall
	move $s1, $v0 #user input 2
	
	#print output1
	li $v0, 4
	la $a0, output1
	syscall
	
	# print first number
	li $v0, 1
	move $a0, $s0
	syscall
	
	#print output2
	li $v0, 4
	la $a0, output2
	syscall
	
	#print second number
	li $v0, 1
	move $a0, $s1
	syscall
	#End of Task 1
	
	
	#Beginning of Task 2
	#add two values
	add $t0, $s0, $s1
	
	#print result
	li $v0, 4
	la $a0, addOutput
	syscall
	
	li $v0, 1
	move $a0 $t0
	syscall
	
	#subtract two values
	sub $t1, $s0, $s1
	
	#print result
	li $v0, 4
	la $a0, subOutput
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	#multiply two values
	mul $t2, $s0, $s1
	
	#print result
	li $v0, 4
	la $a0, mulOutput
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	#divide two values
	beq $s1, $zero, divideError #Checks if second input is zero
	div $t3, $s0, $s1
	j divideOperation
	
divideError:
	li $v0, 4
	la $a0, divideByZero
	syscall
	j task3
	
divideOperation: 
	#print quotient
	li $v0, 4
	la $a0, divQuotient
	syscall
	
	li $v0, 1
	mflo $a0
	syscall
	
	#print remainder
	li $v0, 4
	la $a0, divRemainder
	syscall
	
	li $v0, 1
	mfhi $a0
	syscall
	#End of Task 2
	
task3: #Beginning of Task 3
	beq $s0, $s1, yes #Check if inputs are the same
	j no #jump to output of diffNumbers if not equal
	
yes: #if numbers are the same, jump here
	li $v0, 4
	la, $a0, sameNumbers
	syscall
	j exit
	
no: #if numbers are different, jump here
	li $v0, 4
	la $a0, diffNumbers
	syscall
	#End of Task 3
	
exit: #exit program
	li $v0, 10
	syscall 
