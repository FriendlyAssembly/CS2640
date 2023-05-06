#Friendly Assembly: CS2640.01
#Append to File
#still issues with generating files...

.data
filename: .space 256     # Space for the file name
filecontent: .space 1024 # Space for the file content
filenameMsg: .asciiz "Please enter the file name that you wish to create: "
filecontentMsg: .asciiz "Please enter the file content that you wish to create: "
# Read filename from user

.text
main:
   
    # File name message
    li $v0, 4
    la $a0, filenameMsg
    syscall
    
    # Read filename from user
    li $v0, 8              # Set syscall code for reading string
    la $a0, filename       # Load address of filename buffer
    li $a1, 256            # Set buffer size
    syscall                # Read filename

    # File contents message
    li $v0, 4
    la $a0, filecontentMsg
    syscall

    # Read file content from user
    li $v0, 8              # Set syscall code for reading string
    la $a0, filecontent    # Load address of filecontent buffer
    li $a1, 1024           # Set buffer size
    syscall                # Read file content

    # Open file in append mode
    li $v0, 13             # Set syscall code for opening file
    la $a0, filename       # Load address of filename buffer
    li $a1, 1              # Set file opening mode to write (1 for O_WRONLY)
    li $a2, 8              # Set flags to O_APPEND (8)
    syscall                # Open file

    # Store file descriptor
    move $s0, $v0          # Move file descriptor to $s0 for later use

    # Write content to file
    li $v0, 15             # Set syscall code for writing to file
    move $a0, $s0          # Move file descriptor to $a0
    la $a1, filecontent    # Load address of filecontent buffer
    li $a2, 1024           # Set buffer size
    syscall                # Write content to file

    # Close file
    li $v0, 16             # Set syscall code for closing file
    move $a0, $s0          # Move file descriptor to $a0
    syscall                # Close file

    # Exit program
    li $v0, 10             # Set syscall code for exiting program
    syscall                # Exit
