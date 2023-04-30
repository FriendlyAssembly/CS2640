# Friendly Assembly: CS 2640.01
# May 7, 2023
# Objective:
# Write a program in Assembly that takes in a programmer-defined filename 
# - use practiceFile.txt

.data
fileInput: .asciiz "practiceFile.txt" 
buffer: .space 512

.text
main: 
	#open a file (for reading) that exists
	li $v0, 13
	la $a0, fileInput
	li $a1, 0	#read from file 
	li $a2, 0	#ignored
	syscall
	move $s0, $v0	#store file descriptor in $s0
	
	#read gradedItems.txt contents 
	li $v0, 14
	move $a0, $s0	#load file descriptor into $s0
	la $a1, buffer
	li $a2, 512	#does it need to be exact num of characters 
	syscall
	move $s1, $v0
	
	#print contents of practiceFile.txt to user
	li $v0, 4 
	la $a0, buffer
	syscall 
	
	#close the file
	li $v0, 16
	move $a0, $s0
	
exit:
	li $v0, 10
	syscall
	
	
