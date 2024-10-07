; Main program
; Wayne Cook
; 29 February 2024
; Controls the flow of the program
; Revised: WWC 14 March 2024 Added new module
; Revised 15 March 2024 Added this comment to force a new commit.
; Revised: WWC 25 April 2024 Split out the console control into second file.
; Revised: WWC 13 September 2024 Minor updates for Fall 2024 semester.
; Revised: JB,  7 October, 2024, Added exit message
; Register names:
; Register names are NOT case sensitive eax and EAX are the same register
; x86 uses 8 registers. EAX (Extended AX register has 32 bits while AX is the right most 16 bits of EAX). AL is the right-most 8 bits.
; Writing into AX or AL effects the right most bits of EAX.
;     EAX - caller saved register - usually used for communication between caller and callee.
;     EBX - Callee saved register
;     ECX - Caller saved register - Counter register 
;     EDX - Caller Saved register - data, I use it for saving and restoring the return address
;     ESI - Callee Saved register - Source Index
;     EDI - Callee Saved register - Destination Index
;     ESP - Callee Saved register - stack pointer
;     EBP - Callee Saved register - base pointer

.386P

.model	flat
extern	_ExitProcess@4: near
extern	initialize_console: near
extern	start: near
extern  charCount:	near
extern  writeline:   near

.data  
	exitmsg 	byte	10,10,10,"Hello World!",0 ; Exit message

.code

main PROC near
_main:
	call initialize_console
	call start
	call exit
main ENDP

exit PROC near
_exit:
	; Write an exit message for the user
	push  offset exitmsg
    call  charCount
    push  eax
    push  offset exitmsg
    call  writeline

		 ; ExitProcess(uExitCode)
    push  5
    call  _ExitProcess@4
exit ENDP
END