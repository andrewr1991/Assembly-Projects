/******************************************************************************
* @file p2_afr9714.s
* @Simple program to populate an array with 10 user-inputted integers. A linear search is then used to find all instances of a particle element.
* @author Andrew Ridout
* @original code snippets by Christopher D. McMurrough
******************************************************************************/
 
.global main
.func main
   
main:
    MOV R0, #0              @ initialze index variable
    
writeloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    PUSH {R0}               @ backup iterator before procedure call
    PUSH {R2}               @ backup element address before procedure call
    PUSH {R1}
    BL _scanf             
    POP {R1}
    POP {R2}                @ restore element address
    STR R0, [R2]            @ write the address of a[i] to a[i]
    POP {R0}                @ restore iterator
    ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
    
writedone:
    MOV R0, #0              @ initialze index variable
    
readloop:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ user_input            @ exit loop if done
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
    
user_input:    
	PUSH {R1}
	BL _printf_search
	BL _scanf
	MOV R3, R0
	POP {R1}
	MOV R0, #0              @ initialze index variable
	MOV R4, #0
	
search:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ _exit            @ exit loop if done
    PUSH {R3}
    LDR R1, =a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    CMP R3, R1
    ADDEQ R4, #1
    MOVEQ R2, R1              @ move array value to R2 for printf
    MOVEQ R1, R0              @ move array index to R1 for printf
    BLEQ _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    POP {R3}
    B   search            @ branch to next loop iteration
    
_exit:
	CMP R4, #0
	BLEQ _printf_notfound
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
    
_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str    @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
       
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
_printf_search:
    PUSH {LR}               @ store the return address
    LDR R0, =search_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
_printf_notfound:
	PUSH {LR}
	LDR R0, =notfound_str
	BL printf
	POP {PC}
   
.data

.balign 4
a:              .skip       40
printf_str:     .asciz      "array_a[%d] = %d\n"
search_str:     .asciz      "ENTER A SEARCH VALUE: "
notfound_str:   .ascii      "That value does not exist in the array!\n"
format_str:    .asciz       "%d"
debug_str:
.asciz "R%-2d   0x%08X  %011d \n"
