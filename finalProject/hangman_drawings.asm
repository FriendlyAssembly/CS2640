# Jarisse Escubido: CS2640
# Due Date: 05/14/2023
# Objective: Create a simple MIPS Hangman Game

.data
.macro print(%strings)
    li $v0, 4
    .data
    string: .asciiz %strings
    incorrectGuesses: .word 0
    .text
    la $a0, string
    syscall
.end_macro

.macro displayArt
    lw $a0, incorrectGuesses
    beq $a0, 1, oneIncorrect
    beq $a0, 2, twoIncorrect
    beq $a0, 3, threeIncorrect
    beq $a0, 4, fourIncorrect
    beq $a0, 5, fiveIncorrect
    beq $a0, 6, sixIncorrect
    beq $a0, 7, sevenIncorrect

oneIncorrect:
    print("  _______\n")
    print(" |       |\n")
    print(" |\n")
    print(" |\n")
    print(" |\n")
    print(" |\n")
    print(" |\n")
    print(" -------")

twoIncorrect:
    print("  _______\n")
    print(" |       |\n")
    print(" |       O\n")
    print(" |\n")
    print(" |\n")
    print(" |\n")
    print(" |\n")
    print(" -------")

threeIncorrect:
    print("  _______\n")
    print(" |       |\n")
    print(" |       O\n")
    print(" |       |\n")
    print(" |\n")
    print(" |\n")
    print(" |\n")
    print(" -------")

fourIncorrect:
    print("  _______\n")
    print(" |       |\n")
    print(" |       O\n")
    print(" |      /|\n")
    print(" |\n")
    print(" |\n")
    print(" |\n")
    print(" -------")
    
fiveIncorrect:
    print("  _______\n")
    print(" |       |\n")
    print(" |       O\n")
    print(" |      /|\\\n")
    print(" |\n")
    print(" |\n")
    print(" |\n")
    print(" -------")

sixIncorrect:
    print("  _______\n")
    print(" |       |\n")
    print(" |       O\n")
    print(" |      /|\\\n")
    print(" |      d\n")
    print(" |\n")
    print(" |\n")
    print(" -------")
    
sevenIncorrect:
    print("  _______\n")
    print(" |       |\n")
    print(" |       O\n")
    print(" |      /|\\\n")
    print(" |      d b\n")
    print(" |\n")
    print(" |\n")
    print(" -------")
.end_macro