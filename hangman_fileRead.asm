# Moller Myint: CS 2640.01
# May 3. 2023
# Objective: 
# read from the file "dictionary.txt" 
# read and save the words on the file 

.data
newLine: .asciiz "\n"
file: .asciiz "assemblyWords.txt"      # filename for input
buffer: .space 2731

.text
import:
	#open a file for writing
	li   $v0, 13		# system call for open file
	la   $a0, file  	# board file name
	li   $a1, 0        	# Open for reading
	li   $a2, 0
	syscall            	# open a file (file descriptor returned in $v0)
	move $s6, $v0     	# save the file descriptor

	#read from file
	li   $v0, 14       	# system call for read from file
	move $a0, $s6      	# file descriptor
	la   $a1, buffer   	# address of buffer to which to read
	li   $a2, 2731    	# hardcoded buffer length
	syscall            	# read from file

	# Close the file
	li   $v0, 16       	# system call for close file
	move $a0, $s6      	# file descriptor to close
	syscall            	# close file

	li $v0, 42	   	#system call for printing a string 
	li $a0, 0		#file descriptor for standard output 
	li $a1, 2731		#loads 1154335 (length of buffer) into $a1
	syscall

	addi $t0, $a0, 0x10010030	#used to set the starting address for reading the file 
	li $s1, '\n'		#new line character 
	li $s2, '\r'		#carriage return character 

#initialize pointer $a0
	add $a0, $t0, $zero

#find the end of each word by detecting \n or \r
findNextWord:
	lb $t1, ($t0)
	addi $t0, $t0, 1
	beq $t1, $s1, findWordEnd	#when a \n byte is encountered - word is over
	j findNextWord

findWordEnd:
	la $s3, wordToGuess
	
findEndLoop:
	lb $t1, ($t0)
	addi $t0, $t0, 1		#increment $t0 to point to next byte in memory
	beq $t1, $s2, newWordFound	#if the end of the word is found (\r) - quit
	sb $t1, ($s3)
	addi $s3, $s3, 1		#if the end of the word isn't found, add current byte to wordToGuess
	j findEndLoop			#repeat until the end of the word is found

newWordFound:
	print_str("\n")

	addi $t0, $t0, 1
	li $v0, 4
	la $a0, wordToGuess
	syscall				#print wordToGuess for debugging purposes