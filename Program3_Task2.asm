# FriendlyAssembly: CS2640
# May 7, 2023
# Objective : Write a program in Assembly that takes in a programmer-defined filename
# - Take filename that you want to open from user
# - Read the filename that you entered
# - Open the file
# - If the file is not found, print error message. Otherwise, open the file
# - Use the practiceFile.txt to test your program

.data
	fileNotFound: .asciiz "File is not found.\n"
	buffer: .asciiz "practiceFile.txt"
	read_buffer: .space 1024 #for the filecontents
	
.text 

#program starts
main:
	# open the file for reading
	li $v0, 13 #open the file
	la $a0, buffer #store filename
	li $a1, 0 #read only
	li $a2, 0 #mode ignored (file permission)
	syscall
	
	# check if the file is available
	bltz $v0, notFound # jump to error message
	
	# save the file descriptor
	move $s0, $v0
	
	# read the contents of the file
	li $v0, 14 # read file 
	move $a0, $s0 # move the file content descriptor from $s0 to $a0
	la $a1, read_buffer # load the address of the read_buffer
	li $a2, 1024 # size of the read_buffer
	syscall
	
	# store the number of bytes
	move $s1, $v0
	
	# print the contents of the file
	li $v0, 4
	la $a0, read_buffer
	syscall
	
	# close the file
	li $v0, 16
	syscall
	
exit:

	# exit program
	li $v0, 10
	syscall
	
notFound:

	# print error message
	li $v0, 4
	la $a0, fileNotFound
	syscall
	
	li $v0, 10
	syscall