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
hiddenCharacter: .asciiz "_"
space: .asciiz " "

enteredLetters: .asciiz "\nCurrent entered letters: "
letterBuffer: .space 100


initialGuessZero: .asciiz "\n  _______\n |       |\n |\n |\n |\n |\n |\n -------\n"
incorrectGuessOne: .asciiz "\n  _______\n |       |\n |       O\n |\n |\n |\n |\n -------\n"
incorrectGuessTwo: .asciiz "\n  _______\n |       |\n |       O\n |       |\n |\n |\n |\n -------\n"
incorrectGuessThree: .asciiz "\n  _______\n |       |\n |       O\n |      /|\n |\n |\n |\n -------\n"
incorrectGuessFour: .asciiz "\n  _______\n |       |\n |       O\n |      /|\\\n |\n |\n |\n -------\n"
incorrectGuessFive: .asciiz "\n  _______\n |       |\n |       O\n |      /|\\\n |      /\n |\n |\n -------\n"
incorrectGuessSix: .asciiz "\n  _______\n |       |\n |       O\n |      /|\\\n |      d b\n |\n |\n -------\n"
incorrectGuesses: .word 0

filename: .asciiz "assemblyWords.txt"
textBuffer: .space 1045

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
	


guessWord:
	#get user input
	li $v0, 12
	syscall
	move $t0, $v0
	
	beq $t0, 'Y', startGame
	beq $t0, 'N', exit
	
	
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
	
	#print alphabet
	li $v0, 4
	la $a0, enteredLetters
	syscall
	
	
	
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
