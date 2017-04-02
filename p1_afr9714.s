/******************************************************************************
* @file p1_afr9714.s
* @Simple calculator program that can add, subtract, multiply, or find the max of two positive ints
* @author Andrew Ridout
* @original code by Christopher D. McMurrough
******************************************************************************/
 
.global main
.func main
   
main:
	//First scanf
    BL  _scanf1             @ branch to scanf procedure with return
    MOV R6, R0              @ move return value R0 to argument register R1
    
    //Operator
    BL _getchar
    MOV R1, R0
    
    //Second scanf
    BL  _scanf2             @ branch to scanf procedure with return
    MOV R4, R0              @ move return value R0 to argument register R1
    
    BL _compareA
    
    B   _exit               @ branch to exit procedure with no return
   
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R4              @ return
    
_scanf1:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str1    @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
    
_scanf2:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str2    @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
    
_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return
    
_compareA:
    CMP R1, #'+'            @ compare against the constant char '@'
    BEQ _add				@ branch to add handler
    
_comparS:
    CMP R1, #'-'            @ compare against the constant char '@'
    
_comparM:
    CMP R1, #'*'            @ compare against the constant char '@'
    
_compareMax:
    CMP R1, #'M'            @ compare against the constant char '@'
    
_add:
	MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
	ADD R1, R4, R6
    BL printf               @ call printf
    MOV PC, R5              @ return
	

.data
format_str1:    .asciz      "%d"
format_str2:    .asciz      "%d"
printf_str:     .asciz      "The sum is: %d\n"
exit_str:       .ascii      "Terminating program.\n"
read_char:      .ascii      " "
