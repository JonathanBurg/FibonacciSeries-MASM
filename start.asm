; Main Console Program
; Jonathan Burgener
; 27 September 2024
; Calculate and display the Fibonacci Series
; Revised: JB, 30 September 2024, Added loops and reference to fibSer.asm
;
; Register names:
; Register names are NOT case sensitive eax and EAX are the same register
; x86 uses 8 registers. EAX (Extended AX register has 32 bits while AX is
;	the right most 16 bits of EAX). AL is the right-most 8 bits.
; Writing into AX or AL effects the right most bits of EAX.
;		EAX - caller saved register - usually used for communication between
;				caller and callee.
;		EBX - Callee saved register
;		ECX - Caller saved register - Counter register 
;		EDX - Caller Saved register - data, I use it for saving and restoring
;				the return address
;		ESI - Callee Saved register - Source Index
;		EDI - Callee Saved register - Destination Index
;		ESP - Callee Saved register - stack pointer
;		EBP - Callee Saved register - base pointer.386P

.model flat

extern  writeline:	 near
extern  readline:	 near
extern  charCount:	 near
extern  writeNumber: near
extern  getNumber:	 near


.data

num1			DD		?		; first number for each iteration
num2			DD		?		; second number for each iteration
itr				DD		?		; iterator to make sure only 45 terms are printed
msg				byte	"Hello, World", 10, 0							; ends with line feed (10) and NULL
prompt			byte	"Fibonacci Series (First 45 terms): ", 10, 0	; ends with string terminator (NULL or 0)
endln			byte	"    ", 10, 0
results			byte	?		; buffer to print vars
numCharsToRead	dword	1024
bufferAddr		dword	?


.code

;;******************************************************************;
;; Call start()
;; Parameters:		None
;; Returns:			Nothing
;; Registers Used:	EAX
;; 
;; Library calls used for input from and output to the console
;; This is the entry procedure that does all of the testing.
;;******************************************************************;
start PROC near
_start:
	 ; Type a message for the user
	 ; WriteConsole(handle, &Prompt[0], 17, &written, 0)
	push  offset prompt
	call  charCount
	push  eax
	push  offset prompt
	call  writeline

	; Initialize variables
	mov   num1, 1
	mov   num2, 2
	
	 ; Print first two variables
	mov   eax, num1
	push  eax
	call  writeNumber
	mov   eax, num2
	push  eax
	call  writeNumber

	mov   itr, 2

	 ; loop to iterate fibonacci series
top:
	call  iterate
	cmp   itr, 45
	jl    top
	jmp   done

	 ; What to do once condition is met
done:
	call  getNumber

	 ; And it is time to exit.
exit:
	ret							; Return to the main program.
start ENDP


;;******************************************************************;
;; Call iterate()
;; Parameters:		None
;; Returns:			Nothing
;; Registers Used:	EAX, EBX (s)
;; 
;; Routine to iterate to next element in Fibonacci Series
;;******************************************************************;
iterate PROC near
_iterate:
	 ; Save EBX
	push  ebx
	 ; Try print a number
	mov   eax, num1
	add   eax, num2
	 ; Make sure numbers are not lost when EAX is overwritten in writeNumber
	mov   ebx, num2
	mov   num1, ebx
	mov   num2, eax
	push  eax
	call  writeNumber
	
	inc   itr
	 ; Restore EBX
	pop  ebx
	 ; Return to start
	ret
iterate ENDP

END