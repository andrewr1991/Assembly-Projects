/******************************************************************************
* @file p1_afr9714.s
* @Simple calculator program that can add, subtract, multiply, or find the max of two pos. ints
* @author Andrew Ridout
* @original code by Christopher D. McMurrough
******************************************************************************/
 
.global main
.func main
   
main:
    LDR R0,=print_str   @ store string address in R0
    BL printf           @ call printf
    B   _exit           @ branch to exit procedure with no return
   
_exit:   
	MOV R7, #1          @ terminate syscall, 1
	SWI 0               @ execute syscall

.data
print_str:  .asciz "2312 calculator program\n"
