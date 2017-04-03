/******************************************************************************
* @file p1_afr9714.s
* @Simple calculator program that can add, subtract, multiply, or find the max of, two positive ints
* @author Andrew Ridout
* @original code by Christopher D. McMurrough
******************************************************************************/
 
.global main
.func main
   
main:
loop:
	//First scanf
    BL  _scanf1             @ branch to scanf procedure with return
    MOV R6, R0              @ move return value R0 to argument register R1
    
    //Operator
    BL _getchar
    MOV R7, R0
    
    //Second scanf
    BL  _scanf2             @ branch to scanf procedure with return
    MOV R4, R0              @ move return value R0 to argument register R1
    
    //Conditionals
    //MOV R1, R2
    BL _compare
    
    B loop
    
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
    
_compare:

	//Add
    CMP R7, #'+'            @ compare against the constant char '+'
    BEQ _add				@ branch to add handler
    
    //Subtract
    CMP R7, #'-'
    BEQ _subtract
    
    //Multiply
    CMP R7, #'*'
    BEQ _multiply
    
    //Max
    CMP R7, #'M'
    BEQ _max
    
_add:
	MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
	ADD R1, R6, R4
    BL printf               @ call printf
    MOV PC, R5              @ return
    
_subtract:
	MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
	SUB R1, R6, R4
    BL printf               @ call printf
    MOV PC, R5              @ return
    
_multiply:
	MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MUL R1, R6, R4          @ compute R1 = R6 * R4
    BL printf               @ call printf
    MOV PC, R5              @ return
    
_max:
	CMP R6, R4
	BGT _printf_max1
	BLT _printf_max2
    
_printf_max1:
	MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =printf_max     @ R0 contains formatted string address
    MOV R1, R6          
    BL printf               @ call printf
    MOV PC, R5              @ return
        
_printf_max2:
	MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =printf_max     @ R0 contains formatted string address
    MOV R1, R4          
    BL printf               @ call printf
    MOV PC, R5              @ return

.data
format_str1:    .asciz      "%d"
format_str2:    .asciz      "%d"
printf_str:     .asciz      "The sum is: %d\n"
printf_max:     .asciz      "The max is: %d\n"
exit_str:       .ascii      "Terminating program.\n"
read_char:      .ascii      " "
