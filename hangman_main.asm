#macro that prints out specified string variable
.macro printPrompt(%x)
	li $v0, 4
	la $a0, %x
	syscall
.end_macro 

#macro that prints out specified text
.macro 	printString (%str)  
	.data
	string:	.asciiz %str
	numIncorrectGuesses: .word 0

	.text
	li $v0, 4
	la $a0, string
	syscall
.end_macro

.data
totoro: .asciiz "\n                         /\\_/\\  \n                        / o o \\ \n                       (       )\n"
welcomePrompt: .asciiz "==================Welcome to Hangcat!==================\nGuess the secret word before the our cat friend is hung!\n    You have 6 incorrect guesses until Game Over.\n                 Hope you enjoy!\n"
miniRobots: .asciiz "\n\n\n         \\.-./\n [@@]  __|q p|__  [oo] \n/|__|\\   [===]   /|##|\\ \n d  b     d b     d  b\n"

numIncorrectGuesses: .word 0
wordLength: .word 0
numLettersGuessed: .word 0
wordToGuess: .asciiz "                                    "
prevGuessed: .asciiz "                                    "
guessedLetters: .asciiz "                          "
numCorrectGuesses: .word 0
correctAnswer: .asciiz "\nThe correct word was: "
file: .asciiz "dictionary.txt"      # filename for input
buffer: .space 10000

.text
#################################################################################################################################################################
#																				#
############################################################### BEGIN HANGCAT IMAGE PRINTING ####################################################################
printImage:	#prints out hangman image for user display 
.macro print_img

	top:
		#Unchanging strings
		printString("\n            		\n")
		printString("          +-----o		\n")
		printString("          |     |		\n")

	#Prints different parts of image based on # of incorrect guesses
	#################################### ^o.o^ ############################################
		lw $a0, numIncorrectGuesses
		# 0 incorrect guesses
		beq $a0, 1, g1
		beq $a0, 2, g2
		beq $a0, 3, g3
		beq $a0, 4, g4
		beq $a0, 5, g5
		beq $a0, 6, g6
		printString("  ^---^   |		\n")  
		printString(" (o v o)  |		\n")	
		printString(" (>    )>P|		\n")	
		printString(" _V___V___|___		\n")	
		j bottom
	
		# 1 incorrect guess
	g1:	printString("          |    ^-^		\n")
		printString("   ^---^  |   (0.0)	\n")
		printString("  (o v o) |		\n")
		printString("  (>    )>|		\n")
		printString("  _V___V__|___		\n")
		j bottom
	
		#2 incorrect guesses
	g2:	printString("   ^---^  |    ^-^		\n")
		printString("  (o v o) |   (0.0)	\n")
		printString("  (>    )>|   <   		\n")
		printString("  _V___V__|___		\n")
		j bottom
	
		#3 incorrect guesses
	g3:	printString("   ^---^  |    ^-^		\n")
		printString("  (o v o) |   (0.0)	\n")
		printString("  (>    )>|   < . >	\n")
		printString("   V___V__|___		\n")
		j bottom
		#4 incorrect guesses
	g4:	printString("          |    ^-^		\n")
		printString("   ^---^  |   (0.0)	\n")
		printString("  (o v o) |   < . >	\n")
		printString("  (>    )>|    v   	\n")
		printString("   V___V__|___		\n")
		j bottom
	
		#5 incorrect guesses
	g5:	printString("          |    ^-^		\n")
		printString("   ^---^  |   (0.0) 	\n")
		printString("  (o v o) |   < . >	\n")
		printString("  (>    )>|    v v		\n")
		printString("   V___V__|___     	\n")
		j bottom
	
		#6 incorrect guesses
	g6:	printString("          |    ^-^		\n")
		printString("   ^---^  |   (x.x)	\n")
		printString("  (o v o) |   < . >	\n")
		printString("  (>    )>|    v v		\n")
		printString("   V___V__|___ 		\n")
		j bottom
		
	bottom:
		printString("\n")

	#################################### ^o.o^ ############################################

.end_macro

#################################################################### END HANGCAT IMAGE PRINTING #########################################################################
#																					#
####################################################################### WELCOME PROMPT ##################################################################################
welcome:
	printPrompt(totoro)
	printPrompt(welcomePrompt)
	
####################################################################### END WELCOME PROMPT ##############################################################################
#																					#
################################################################## BEGIN DICTIONARY OPERATIONS ##########################################################################

#open/reads/closes data from dictionary.txt files 
dictionary:	
	#open a file for writing
	li   $v0, 13		# system call for open file
	la   $a0, file  	# board file name
	li   $a1, 0        	# Open for reading
	li   $a2, 0
	syscall    
	        		# open a file (file descriptor returned in $v0)
	move $s6, $v0     	# save the file descriptor

	#read from file
	li   $v0, 14       	# system call for read from file
	move $a0, $s6      	# file descriptor
	la   $a1, buffer   	# address of buffer to which to read
	li   $a2, 10000    	# hardcoded buffer length
	syscall            	# read from file

	# Close the file
	li   $v0, 16       	# system call for close file
	move $a0, $s6      	# file descriptor to close
	syscall            	# close file

	li $v0, 42	   	#system call for printing a string 
	li $a0, 0		#file descriptor for standard output 
	li $a1, 10000		#loads 10000 (length of buffer) into $a1
	syscall

	addi $t0, $a0, 0x10010030	#used to set the starting address for reading the file 
	li $s1, '\n'			#new line character 
	li $s2, '\r'			#carriage return character 

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
	printString("\n")

	addi $t0, $t0, 1
	printPrompt(wordToGuess)	#print wordToGuess for debugging purposes

#################################################################### END DICTIONARY OPERATIONS ############################################################################
#																					  #
#################################################################### BEGIN MAIN GAME PROCEDURE ############################################################################

#initialize stack 
main:
	addi $s3, $zero, 1 		#set $s3 to 1 for use later
	add $s4, $sp, $zero		#sets array value $s4 to the current value of the stack pointer ($sp)
	addi $s5, $sp, 4		#sets register $s5 to the current value of the stack pointer ($sp), offset by 4.
	la $t0, wordToGuess		#loads the address of the wordToGuess string into register $t0
	lb $s2, numIncorrectGuesses 	#sets $s2 to null bit (-1)
	addi $s1, $zero, -1		#set string length to -2 (to get correct value later)
	sw $s1, wordLength		#stores the value -1 in the memory location wordLength
					#initializes wordLength to a value that is different from zero 
					#so that it can be used later in the code to detect whether 
					#the string length has been properly initialized

	#list of registers: $s0 = 2, $s1 = nothing, $s2 = null, $s3 = 1, $s4 = $sp, $s5 = $sp (used to move up and down array), $s6 used in generateWord can be used in other things, $s7 = used to store imported char
	#		    $t0 = address of wordToGuess, $t1 = used in printChar, $t2 = used in checkForMatch
	#stack is used for the array - should that be changed?

#	li $v0, 4
#	la $a0, stringInput
#	syscall		#prompt user for input
#	li $v0, 8
#	la $a0, wordToGuess
#	li $a1, 256
#	syscall #loads a string into memory at string's address (max 256 chars)

	la $t0, wordToGuess		#sets up the stack by looping through each character in the string variable wordToGuess 
	li $t7, ' '

###########################################################################################################################################################################
#																					  #
################################################################## BEGIN BEGIN INITIALIZING STACK #########################################################################

#adds each character onto the stack 
stackSetup:
	lb $a0, ($t0)
	jal addToStack			#adds onto stack
	addi $t0, $t0, 1
	bne $a0, $t7, stackSetup	#loops until a space is encountered

	addi $s0, $s0, 2		#increments the value of $s0 by 2
	sw $s0, ($sp)			#stores it in memory at the current stack pointer
	add $sp, $sp, -4		#decrements the stack pointer by 4
	addi $sp, $sp, 24		#increments the stack pointer by 24

	#Word inputed and store in memory; stack set up as array	
	
################################################################ END INITIALIZING STACK ###################################################################################
#																					  #
######################################################### BEGIN LOAD CHARS OF PREVIOUSLY GUESSES LETTERS ONTO STACK #######################################################
loop:
	printString("\n=======================================================\n")

	la $t6, prevGuessed		#loads the address of the variable prevGuessed into register $t6.
	lw $t5, numLettersGuessed	#loads the value of the variable numLettersGuessed into register $t5
	add $t4, $zero, $zero		#sets register $t4 to zero.

	# Print letters already guessed
	printString("Guessed letters: ")

	add $s5, $s4, $zero		#set $s5 to beginning of array 

	addi $s3, $zero, 1		#sets register $s3 to the value 1
	jal generateWord

	print_img 			#sets $a1 to numIncorrectGuesses
	printString("\n")

	lw $t3, numIncorrectGuesses	#loads the value of the variable numIncorrectGuesses into register $t3
	beq $t3, 6, failure		#jumps to the failure label if the value of $t3 is equal to 6

	# Print number of incorrect guesses
	printString("Incorrect guesses: ")	
	li $v0, 1				#set register $v0 to 1
	lw $a0, numIncorrectGuesses		#load the value of the variable numIncorrectGuesses into register $a0
	syscall					#print the value in $a0 to the console
	printString("\n")

	# Add guessed letter
	printString("Guess a letter: ")		#read a single character from the console
	li $v0, 12
	syscall	#inputs a character
	add $s7, $v0, $zero			#sets register $s7 to the value that was read from the console.

	# Add guess
	add $a0, $v0, $zero			# set register $a0 to the value that was read from the console 
	jal addGuess				#jump to the addGuess function
	beq $v0, 1, loop2 			# Continue if the add was valid

	# Otherwise, error
	printString("Letter already guessed.\n")
	j loop

loop2:
	add $s5, $s4, $zero			#copies the value of $s4 to $s5
	jal checkForMatch
	add $t2, $zero, $zero			#sets the value of register $t2 to 0 

	lw $t3, wordLength			#loads the value of the variable wordLength from memory into register $t3
	lw $t4, numLettersGuessed		#loads the value of the variable numLettersGuessed from memory into register $t4
	beq $t3, $t4, success			#branches to the success label if the values in registers $t3 and $t4 are equal

	j loop

checkForMatch:
	la $t3, wordToGuess			#loads the address of the wordToGuess string into register $t3
	
	#calculate the address of the current character in the wordToGuess string 
	#$s5- current loop index
	#$t3- base address of string
	sub $t1, $s5, $s4			#$s5 - $s4 is 
	div  $t1, $t1, 4			#divided by 4 (characters in the string are 4 bytes each)
	add $a1, $t3, $t1			#esult is added to $t3 to get the address of the current character
	
	lb $a0, ($a1)				#loads the value of the current character from memory into register $a0
	addi $s5, $s5, 4			#increments the loop index in $s5 by 4 to move to the next character in the wordToGuess string
	beq $a0, $s7, checkIfAlreadyGuessed	#checks if the current character is equal to the character being guessed (stored in $s7)
						#branches to the checkIfAlreadyGuessed label to see if the character has already been guessed before
						
	beq $s2, $a0, matchCompleted		#when a null byte is encountered - word is over
	j checkForMatch

#set up a loop to check if the current character has already been guessed before
checkIfAlreadyGuessed:
	la $t6, prevGuessed			#address of the prevGuessed array is loaded into $t6
	lw $t5, numLettersGuessed		#numLettersGuessed thus far is loaded into $t5
	add $t4, $zero, $zero			#loop counter is set to 0 in $t4

#calculate the address of the next character in the prevGuessed array
#$t4- loop counter
#$t6- base address
checkIfAlreadyGuessedLoop:
	add $s6, $t4, $t6
	lb $t0, ($s6)
	beq $t4, $t5, storeSetup	#if all previously guessed chars have been examined
					#--> branch storeSetup label to set up for storing the current character as a previously guessed character
					
	beq $t0, $a0, checkForMatch	#if a char has already been guessed, go back to checkForMatch
	addi $t4, $t4, 1		#increment loop counter 
	j checkIfAlreadyGuessedLoop	#jumps to beginning of loop till all chars have been checked 

#sets up to store the current character as a previously guessed character
storeSetup:
	addi $a3, $zero, 2		#sets the value of register $a3 to 2
	j matchFound

#stores the current character as a previously guessed character
storeInPrev:
	add $t4, $t5, $t6		#adds the values in registers $t5 and $t6, and stores the result in register $t4
	sb $a0, ($t4)			#stores the value in register $a0 into memory at the address stored in register $t4
	j soundGood			#jumps to soundGood to output and the sound if correct letter is guessed
	
#executes if a match is found
matchFound:
	sw $s2, ($s5)			#stores the value in register $s2 into memory at the address stored in register $s5
	add $t2, $zero, 2		#sets the value of register $t2 to 2--> used in finished to see if a char matched
	lw $t7, numLettersGuessed	#oads the value stored in memory at the address labeled numLettersGuessed into register $t7
	addi $t7, $t7, 1		#adds 1 to the value in register $t7
	sw $t7, numLettersGuessed	#stores the value in register $t7 into memory at the address labeled numLettersGuessed
	j checkForMatch

#executed when a letter guess has been made
#the program is determining whether or not the guess matches a letter in the word being guessed
matchCompleted:
	bne $t2, 2, incrementGuessesNum		#if the letter guessed was not in the word--> ncorrectguessess++
						#checks if $t2 (a register that is set to 2 when a match is found) is not equal to 2
						
	beq $a3, 2, storeInPrev			#if the letter guess is in the word --> store letter in previously guess letter array 
						#checks if $a3 (a register that is set to 2 when a match is found) is equal to 2
	
	j soundGood
	#jr $ra	#otherwise go back to loop

#if the letter guessed was not in the word, then incorrectguessess++
incrementGuessesNum:			
	lw $t3, numIncorrectGuesses		#loads the value stored in numIncorrectGuesses into $t3
	add $t3, $t3, 1				#increments $t3 by 1
	sw $t3, numIncorrectGuesses		#stores the updated value in numIncorrectGuesses
	j soundBad				#play sound for incorrect guess
	#jr $ra
	
######################################################### END LOAD CHARS OF PREVIOUSLY GUESSES LETTERS ONTO STACK #########################################################
#																					  #
############################################################## BEGIN LOAD CHARS OF WORD TO GUESS ONTO STACK ###############################################################

#make a word with _ and letters
#generates a string that shows the current state of the word being guessed
#$s6- value of the current character in the word to guess
#$s3- value 95, which corresponds to the ASCII code for the underscore character ()
#$s2- value 32, which corresponds to the ASCII code for the space character
generateWord:				
	lb $s6, 4($s5)				#loads the value at memory location 4($s5) into $s6
	beq $s6, $s3, print_
	beq $s6, $s2, printChar
	jr $ra					

#if value in array is 1, then an underscore is printed
print_:		
	printString("_ ")
	addi $s5, $s5, 4			#adds 4 to $s5 (to move to the next memory location containing a character value)
	j generateWord

#if value in array is 0, then the character from that spot is printed
printChar:	
	la $t3, wordToGuess			#Load the address of the wordToGuess variable into register $t3
	sub $t1, $s5, $s4			#store byte offset in $t1
	div  $t1, $t1, 4			#Divide the byte offset by 4 (since each array element is 4 bytes long)
	add $a1, $t3, $t1			#Add the word address $t3 to the byte offset $t1 to get the address of the current array element
	lb $a0, ($a1)				#Load the byte at the memory address pointed to by $a1 into register $a0
	li $v0, 11				#Load the system call code for printing a character into register $v0
	syscall

	addi $s5, $s5, 4			#Increment the index $s5 by 4 (since each array element is 4 bytes long)
	printString(" ")
	j generateWord				#Jump back to the generateWord label to print the next character or underscore

addToStack:
	lw $s1, wordLength			#Load the value of wordLength into register $s1
	addi $s1, $s1, 1			#Add 1 to wordLength and store the result back in $s1
	sw $s1, wordLength			#Store the updated wordLength value back in memory
	add $sp, $sp, 4				#Add 4 bytes to the stack pointer $sp to allocate space for a new value on the stack
	sw $s3, ($sp)				#Store the value of $s3 (the current letter guess) onto the top of the stack
	jr $ra
######################################################## END LOAD CHARS OF WORD TO GUESS ONTO STACK #####################################################################
#																					#
################################################################# START FAIL/SUCCESS/SOUND ##############################################################################
#reached from end of main loop
failure: 
	printString("\nYou have made too many incorrect guesses. GAME OVER!!!")
	#insert sound for losing the game
	j exit

#reached from end of main loop
success:	
	printString("\n\nYou have guessed all of the letters in the word. YOU WIN!!!\n")
	printString("CONGRADULATIONS YOU SMARTICLE PARTICLE")
	printPrompt(miniRobots)
	#insert sounds for winning the game
	j exit

soundBad:
	li $v0, 33	#Number for syscall
	li $a0, 40	#Pitch
	li $a1, 1000	#Duration
	li $a2, 56	#Instrument
	li $a3, 127	#Volume
	syscall

	jr $ra

soundGood:
	li $v0, 33	#Number for syscall
	li $a0, 62	#Pitch
	li $a1, 250	#Duration
	li $a2, 0	#Instrument
	li $a3, 127	#Volume
	syscall

	li $v0, 33	#Number for syscall
	li $a0, 67	#Pitch
	li $a1, 1000	#Duration
	li $a2, 0	#Instrument
	li $a3, 127	#Volume
	syscall

	jr $ra

################################################################# END FAIL/SUCCESS/SOUND ################################################################################
#																					#
######################################################## START UPDATING GUESSED LETTERS ARRAY/STACK #####################################################################

#loads space constant, int 0, and the address of array 'guessedLetters'
addGuess:
	# Load our constants
	li $t0, ' '     		# Load ASCII space character into $t0
	li $t1, 0       		# Load integer 0 into $t1
	la $t2, guessedLetters  	# Load address of the array 'guessedLetters' into $t2

#loop that iterates through each character of 'guessedLetters"
addGuessLoop:
	subi $sp, $sp, 20  		# Reserve space on the stack by subtracting 20 from the stack pointer
	sw $t0, 0($sp)     		# Store the space character in the current stack frame
	sw $t1, 4($sp)     		# Store the integer 0 in the current stack frame
	sw $t2, 8($sp)     		# Store the address of 'guessedLetters' in the current stack frame
	sw $t3, 12($sp)    		# Store $t3 in the current stack frame
	sw $t4, 16($sp)    		# Store $t4 in the current stack frame
	addi $sp, $sp, 20  		# Increment the stack pointer by 20 to move to the next stack frame
	
	# checks if first char in array is space
	add $t3, $t1, $t2   		# Compute the address of the current character to check
	lbu $t4, ($t3)      		# Load the current character into $t4
	beq $t0, $t4, doAddGuess  	# If the current character is a space, jump to the 'doAddGuess' label

	beq $a0, $t4, cantAddGuess  	# If the character to add already exists in the array, jump to 'cantAddGuess' label

	addi $t1, $t1, 1   		# Increment the index to check the next character in 'guessedLetters'
	j addGuessLoop      		# Jump to the beginning of the loop to check the next character

#adds the guessed letter to the array
doAddGuess:
	sb $a0, ($t3)      		# Store the character to add in the current location in the array
	li $v0, 1           		# Load 1 into $v0 to indicate success
	j endAddGuess       		# Jump to 'endAddGuess' to clean up the stack and return

cantAddGuess:
	li $v0, 0           		# Load 0 into $v0 to indicate failure
	j endAddGuess       		# Jump to 'endAddGuess' to clean up the stack and return

#cleans up stack and stores all chars in array
endAddGuess:
	subi $sp, $sp, 20   		# Decrement the stack pointer by 20 to move back to the previous stack frame
	lw $t0, 0($sp)      		# Load $t0 from the previous stack frame
	lw $t1, 4($sp)      		# Load $t1 from the previous stack frame
	lw $t2, 8($sp)      		# Load $t2 from the previous stack frame
	lw $t3, 12($sp)     		# Load $t3 from the previous stack frame
	lw $t4, 16($sp)     		# Load $t4 from the previous stack frame
	addi $sp, $sp, 20   		# Increment the stack pointer by 20 to move back to the caller's stack frame
	
	jr $ra              		# Return to the caller
################################################################# END UPDATING GUESSED LETTERS ARRAY ####################################################################
#																					#
######################################################################### EXIT PROGRAM ^o.o^ ############################################################################
exit:	
	#prints out the correctAnswer prompt
	printPrompt(correctAnswer)
	
	#prints out the correct word
	printPrompt(wordToGuess)

	li $v0, 10
	syscall
