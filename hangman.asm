# Jarisse Escubido: CS2640
# Due Date: 05/14/2023
# Objective: Create a simple MIPS Hangman Game

.data
totoro: .asciiz "\n                         /\\_/\\  \n                        / o o \\ \n                       (       )\n"
miniRobots: .asciiz "\n\n\n         \\.-./\n [@@]  __|q p|__  [oo] \n/|__|\\   [===]   /|##|\\ \n d  b     d b     d  b\n"
welcomeMessage: .asciiz "==================Welcome to Hangman!==================\nGuess the secret word before the stick figure is hung.\n    You have 6 incorrect guesses until Game Over.\n                 Hope you enjoy!\n"

newGameMessage: .asciiz "\nWould you like to start a new game? \n(Y)Yes or (N)No: "
invalidMessage: .asciiz "\n\nInvalid input, please try again.\n"
exitMessage: .asciiz "We are FriendlyAssembly\nThank you for playing, goodbye!\n"

#random word list
word1: .asciiz "hangman"
word2: .asciiz "assembly"
word3: .asciiz "syscalls"
word4: .asciiz "computer"

words: .word word1, word2, word3, word4
sizeOfWords: .word 4

letterGuess: .asciiz "\n\nEnter a letter: "
underscore: .asciiz "_"
space: .asciiz " "
newline: .asciiz "\n"

enteredLetters: .asciiz "\nCurrent entered letters: "
letterBuffer: .space 100


initialGuessZero: .asciiz "\n  _______\n |       |\n |\n |\n |\n |\n |\n -------\n\n"
incorrectGuessOne: .asciiz "\n  _______\n |       |\n |       O\n |\n |\n |\n |\n -------\n\n"
incorrectGuessTwo: .asciiz "\n  _______\n |       |\n |       O\n |       |\n |\n |\n |\n -------\n\n"
incorrectGuessThree: .asciiz "\n  _______\n |       |\n |       O\n |      /|\n |\n |\n |\n -------\n\n"
incorrectGuessFour: .asciiz "\n  _______\n |       |\n |       O\n |      /|\\\n |\n |\n |\n -------\n\n"
incorrectGuessFive: .asciiz "\n  _______\n |       |\n |       O\n |      /|\\\n |      /\n |\n |\n -------\n\n"
incorrectGuessSix: .asciiz "\n  _______\n |       |\n |       O\n |      /|\\\n |      d b\n |\n |\n -------\n\n"
incorrectGuesses: .word 0

filename: .asciiz "assemblyWords.txt"
textBuffer: .space 1045

.text
main:
	la $t0, words
	lw $t1, 16($t0)  # load the length of the array into $t1
	subi $t1, $t1, 1  # decrement the length of the array by 1 to get the last index
	
	li $v0, 40    # load the syscall number for generating a random integer
	move $v0, $t1  # set $a0 to the upper bound (the last index of the array)
	syscall       # generate a random integer between 0 and the last index of the array, and store it in $v0
	add $t2, $t2, $t0   # add the byte offset to the base address of the array to get the address of the random word
	
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
	
	beq $t4, 'Y', startGame
	beq $t4, 'N', exit	
	
invalidInput:
	#print invalid message
	li $v0, 4
	la $a0, invalidMessage
	syscall
	
	j main
	
startGame:
	#print initial hangman
	li $v0, 4
	la $a0, initialGuessZero
	syscall
	
loop:
        lw $t3, ($t2)  # load the current character into $t3
        
        li $v0, 4     # load the syscall number for printing a character
        la $a0, underscore  # load the address of the underscore character into $a0
        syscall
        
        addi $t2, $t2, 4  # increment the pointer to the next character in the word
        
        beq $t3, $zero, startGuess  # if the current character is null, start guessing label
        	
        li $v0, 4
        la $a0, space
        syscall
        
        j loop          # jump back to the beginning of the loop
	
startGuess:
	#print guess prompt
	li $v0, 4
	la $a0, letterGuess
	syscall
	
	#get input
	li $v0, 12
	syscall
	move $t5, $v0
	
	
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
