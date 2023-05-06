# FridnelyAssembly: CS2640
# May 7, 2023
# Objective : Write a program in Assembly that takes practiceFile.txt file and appends to it
# - For the extra point, file name and content is taken from user input (+1 point)
# - Ask user to enter the file name and read the input
# - Store the file name and contents entered by user
# - Open the specified file in writing mode
# - Append the file to the user

.data
filename: .space 256     # Space for the file name
filecontent: .space 1024 # Space for the file content
filenameMsg: .asciiz "Please enter the file name that you wish to create: "
filecontentMsg: .asciiz "Please enter the file content that you wish to create: " 

.text
main:
   
    # show file name message
    li $v0, 4
    la $a0, filenameMsg
    syscall
    
    # read filename from user
    li $v0, 8             
    la $a0, filename       #load address of filename buffer
    li $a1, 256            #buffer size
    syscall                

    # show file contents message
    li $v0, 4
    la $a0, filecontentMsg
    syscall

    # read file content from user
    li $v0, 8             
    la $a0, filecontent    #load address of filecontent buffer
    li $a1, 1024           #buffer size
    syscall          

    # open file in writing mode
    li $v0, 13            
    la $a0, filename       #load address of filename buffer
    li $a1, 1              #flag 1 : writing with creating
    li $a2, 0              #mode : ignored
    syscall              

    # store file descriptor
    move $s0, $v0          #$s0 for later use

    # write content to file
    li $v0, 15            
    move $a0, $s0       
    la $a1, filecontent    #load address of filecontent buffer
    li $a2, 1024           #buffer size
    syscall             

    # close file
    li $v0, 16          
    move $a0, $s0       
    syscall           

    # exit program
    li $v0, 10          
    syscall             
