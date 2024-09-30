; Fibonacci Series - Version 1
; Jonathan Burgener
; Monday, September 23, 2024
; Calculate the Fibonacci Series

.386P

.model flat

extern _GetStdHandle@4:near
extern _ExitProcess@4: near
extern _WriteConsoleA@20:near
extern _ReadConsoleA@20:near

.data

endmsg byte 'Hello World!', 10,0
prompt byte 'How many iterations would you like: ',0


; Codes
outputHandle    dword ?           ; Output handle reading from console. uninitslized
inputHandle     dword ?           ; Input handle writing to console. uninitslized
written         dword ?
INPUT_FLAG      equ   -10
OUTPUT_FLAG     equ   -11

.code

main PROC near
_main:

   ; handle = GetStdHandle(-11)
   push -11
   call _GetStdHandle@4
   mov    outflag, eax
   ; WriteConsole(handle, msg[0], 14, written, 0)
   push 0
   push offset written
   push 13
   push offset msg
   mov eax, offset msg
   push outflag
   call _WriteConsoleA@20


   ; WriteConsole(handle, msg[0], 14, written, 0)
   push 0
   push offset written
   push 0
   push outflag
   call _WriteConsoleA@20

   push 0
   push offset written
   push 13
   push offset msg
   push outflag
   call _WriteConsoleA@20

   push 0
   call _ExitProcess@4

main ENDP
END


; In this assignment, you are given three sample '.asm' files that work well together. 
; All x86 programs start at main. This one is a program that calls different procedures 
; in readwrite.asm. It starts with a call from main to start.asm. Please look at the 
; comment headers and try to duplicate them when you write your assembly code. Modify, 
; where needed, to make the comments accurate. I lay out my use of registers at the top. 
; This usage is a bit easier that the "official" use of registers for calls. We will cover
; that in a later lesson.
;
; Notice on the extern statements and the actual calls to system functions in the code,
; the external calls end in @#, like @20. An example would be:
;
; extern _ExitProcess@4: near
;
; The @4 is used as a "mangled" address name that states the number of byte arguments 
; the call expects. 


; Assignment
; 
; Use start.asm as an example. You probably do not need to modify readwrite.asm, just 
; familiarize yourself with the code so you can use it example. Write a Fibonacci 
; Sequence for 45 terms, starting with the numbers 1 and 2. Modify main.asm so it calls 
; your code. Submit all three files.
;
; The Fibonacci Series is a sequence where the last two numbers are added together to 
; calculate the next number. Normally, it starts with 0 and 1. However, for this program 
; I request that you start with 1 and 2.
; 
; Create a routine in a new file that creates and prints the sequence. Have the call to
; this routine accept a number less than 45. Have the routine print all of the Fibonacci 
; Sequence to that term. Be sure to leave a space between each term. The challenge may be 
; converting an integer into something than can be printed. This would be a good discussion 
; where you can help each other come up with an algorithm to print numbers.