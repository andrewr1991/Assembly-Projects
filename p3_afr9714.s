/******************************************************************************
* @file p3_afr9714
* @Partitions algorithm program
*
* @author Christopher D. McMurrough
* @modified by Andrew Ridout
******************************************************************************/
 
.global main
.func main
   
main:
	loop:
    BL  _scanf              @ branch to scanf procedure with return
    PUSH {R0}
    BL _scanf
    POP {R1}
    MOV R2, R0
    MOV R4, R1
    MOV R5, R2
    BL num_partitions
    MOV R1, R0
    MOV R2, R4
    MOV R3, R5
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    BL loop
    B   _exit               @ branch to exit procedure with no return
    
num_partitions:
	PUSH {LR}
	CMP R1, #0
	MOVEQ R0, #1
	POPEQ {PC}
	CMP R1, #0
	MOVLT R0, #0
	POPLT {PC}
	CMP R2, #0
	MOVEQ R0, #0
	POPEQ {PC}

	PUSH {R1}
	PUSH {R2}
	SUB R2, R2, #1
	BL num_partitions
	POP {R2}
	POP {R1}
	PUSH {R0}				@value returned from BL num_partitions
	SUB R1, R1, R2
	BL num_partitions
	POP {R3}
	ADD R0, R0, R3
	POP {PC}
	
_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
    
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

.data
format_str:     .asciz      "%d"
printf_str:     .asciz      "There are %d partitions of %d using integers up to %d\n"
