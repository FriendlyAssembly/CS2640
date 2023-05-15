# FriendlyAssembly: CS2640
# Due Date: 05/14/2023
# Objective: Create a simple MIPS Hangman Game

.data
totoro: 		.asciiz "\n                         /\\_/\\  \n                        / o o \\ \n                       (       )\n"
miniRobots: 		.asciiz "\n\n\n         \\.-./\n [@@]  __|q p|__  [oo] \n/|__|\\   [===]   /|##|\\ \n d  b     d b     d  b\n"
welcomeMessage: 	.asciiz "==================Welcome to Hangman!==================\nGuess the secret word before the stick figure is hung.\n    You have 6 incorrect guesses until Game Over.\n                 Hope you enjoy!\n"

newGameMessage: 	.asciiz "\nWould you like to start a new game? \n(Y)Yes or (N)No: "
invalidMessage: 	.asciiz "\n\nInvalid input, please try again.\n"
exitMessage: 		.asciiz "We are FriendlyAssembly\nThank you for playing, goodbye!\n"
incorrectMessage:	.asciiz "\nIncorrect letter."
correctMessage:		.asciiz "\nYou guessed a correct letter!"
loseMessage:		.asciiz	"\nSorry, you lost!"
winMessage:		.asciiz	"\nHurray! You found the secret word!"

#hangman parts
top: 		.asciiz "\n            	\n    +-----o	\n    |     |	\n"
emptyPole: 	.asciiz "    |		\n    |		\n    |		\n ___|___		\n"
head: 		.asciiz "    |    ^-^	\n    |   (0.0)	\n    |		\n    |		\n ___|___		\n"
leftArm: 	.asciiz "    |    ^-^	\n    |   (0.0)	\n    |   <   	\n ___|___		\n"
rightArm: 	.asciiz "    |    ^-^	\n    |   (0.0)	\n    |   < . >	\n ___|___		\n"
leftFoot: 	.asciiz "    |    ^-^	\n    |   (0.0)	\n    |   < . >	\n    |    v   	\n ___|___		\n"
rightFoot: 	.asciiz "    |    ^-^	\n    |   (0.0) \n    |   < . >	\n    |    v v	\n ___|___     	\n"
deadman: 	.asciiz "    |    ^-^	\n    |   (x.x)	\n    |   < . >	\n    |    v v	\n ___|___ 		\n"

#random word list
word1: .asciiz "language"
word2: .asciiz "assembly"
word3: .asciiz "syscalls"
word4: .asciiz "computer"
word5: .asciiz "binaries"

words: .word word1, word2, word3, word4, word5


letterGuess: .asciiz "\n\nEnter a letter: "
underscore: .asciiz "_"
space: .asciiz " "
newline: .asciiz "\n"
asterisk: .asciiz "*"

enteredLetters: .asciiz "\nCurrent entered letters: "

.text
main:
	li $v0, 4
	la $a0, totoro
	syscall
	
	#print welcome message
	li $v0, 4
	la $a0, welcomeMessage
	syscall
	
	#ask for user input
	li $v0, 4
	la $a0, newGameMessage
	syscall
	
	#get user input
	li $v0, 12
	syscall
	move $t4, $v0
	
	#print newline
	li $v0, 4
	la $a0, newline
	syscall
	
	beq $t4, 'Y', chooseWord
	beq $t4, 'N', exit	
	
invalidInput:
	#print invalid message
	li $v0, 4
	la $a0, invalidMessage
	syscall
	
	j main

chooseWord:
	#print newline
	li $v0, 4
	la $a0, newline
	syscall
	
	la $t0, words	#load words array
	li $t1, 0	#keep track of current address
	li $t2, 0	#indicate whether guessed letter is found
	lw $t2, 0($t0)	#load word selected from array into $t2
	
	#initialize $t6 as incorrect guess counter
	move $t6, $zero
	
	#initialize #t7 as correct guess counter
initialGuess:
	li $v0, 4
	la $a0, top
	syscall
	
	li $v0, 4
	la $a0, emptyPole
	syscall
	
	j startGuess
	
oneIncorrect:
	li $v0, 4
	la $a0, top
	syscall
	
	li $v0, 4
	la $a0, head
	syscall
	
	j startGuess
	
twoIncorrect:
	li $v0, 4
	la $a0, top
	syscall
	
	li $v0, 4
	la $a0, leftArm
	syscall
	
	j startGuess

threeIncorrect:
	li $v0, 4
	la $a0, top
	syscall
	
	li $v0, 4
	la $a0, rightArm
	syscall
	
	j startGuess
	
fourIncorrect:
	li $v0, 4
	la $a0, top
	syscall
	
	li $v0, 4
	la $a0, leftFoot
	syscall
	
	j startGuess
fiveIncorrect:
	li $v0, 4
	la $a0, top
	syscall
	
	li $v0, 4
	la $a0, rightFoot
	syscall
	
	j startGuess
sixIncorrect:
	li $v0, 4
	la $a0, top
	syscall
	
	li $v0, 4
	la $a0, deadman
	syscall
	
	j lose
	
startGuess:
	#print guess prompt
	li $v0, 4
	la $a0, letterGuess
	syscall
	
	#get input
	li $v0, 12
	syscall
	move $t4, $v0
	
	li $v0, 4
	la $a0, newline
	syscall
	
loop:
	lb $t3, ($t0)	#load single character from selected word into $t3
		
	beq $t3, $zero, done  # if the current character is the null terminator, begin guessing word
	beq $t3, $t4, foundLetter
		
	#print asterisk
	li $v0, 4
	la $a0, asterisk
	syscall               
	
	addi $t0, $t0, 1	#increment the address to point to the next character
	addi $t1, $t1, 1	#increment current index counter
	
	j loop 
	
foundLetter:
	# if the current character is equal to the guessed letter, print the letter
	li $v0, 11            	# syscall code for printing a character
	move $a0, $t5         	# move the character into $a0
	syscall               	# print the character

	addi $t0, $t0, 1      	# increment the address to point to the next character
	addi $t1, $t1, 1      	# increment the counter to keep track of the current character index
	li $t2, 1             	# set the flag to indicate that the guessed letter was found
	j loop                	# jump back to the beginning of the loop
	
done:
	beq $t2, $zero, incorrectGuess  	# if the flag is 0, the guessed letter was not found, jump to the "lose" label
	beq $t2, 1, correctGuess		#if flag is 1, prompt user to "win" label
	
incorrectGuess:
	li $v0, 4
	la $a0, incorrectMessage
	syscall
	
	addi $t6, $t6, 1
	
	beq $t6, 1, oneIncorrect
	beq $t6, 2, twoIncorrect
	beq $t6, 3, threeIncorrect
	beq $t6, 4, fourIncorrect
	beq $t6, 5, fiveIncorrect
	beq $t6, 6, sixIncorrect
	
	j startGuess
	
correctGuess:
	li $v0, 4
	la $a0, correctMessage
	syscall
	
	beq $t7, 7, win
	
	j startGuess
	
lose:
	li $v0, 4
	la $a0, loseMessage
	syscall
	
	j exit
	
win:
	li $v0, 4
	la $a0, winMessage
	syscall
	
	j exit
	
exit:
	#print mini robots
	li $v0, 4
	la $a0, miniRobots
	syscall
	
	#print exit message
	li $v0, 4
	la $a0, exitMessage
	syscall
	
	#exit program
	li $v0, 10
	syscall