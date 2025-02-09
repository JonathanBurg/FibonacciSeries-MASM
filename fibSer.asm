 ; Fibonacci Series
 ; Jonathan Burgener
 ; Monday, 30 September, 2024
 ; Prints the numbers in the Fibonacci Series up to a user-inputted number.
 ; 
 ; Revised: JB,  7 October, 2024 - Finally got a reliable way to convert a string to an int; Removed debug messages
 ; Revised: JB, 16 October, 2024 - Updated headers and added final statement to user
 ; Revised: JB, 20 Octover, 2024 - Changed output formatting and added final line of output, added routine to print an ordinal number.

.model  flat

extern  charCount:	 near
extern  readline:	 near
extern  writeline:	 near
extern  writeNumber: near
extern	writeln:	 near
extern	readInt:	 near
extern	writeNum:	 near


.data

	var1			DD		? ; first number to add
	var2			DD		? ; second number to add
	var3			DD		? ; term to stop at: From user input
	itr				DD		? ; current term of the series
	temp			byte	? ; temporarily store a byte
	prompt			byte	"Please enter max number (<45): ", 0	; ends with string terminator (NULL or 0)
	error			byte	"Error, Invalid Number",10,0
	msg				byte	10,"Fibonacci Series: ", 10, 0			; ends with string terminator (NULL or 0)
	results			byte	10,"You typed: ", 0
	termBuffer		byte	", ",0
	input			dword	?
	numCharsToRead	dword	1024
	bufferAddr		dword	?

	 ; Byte strings for final line of output
	final			byte	10,10,"The value of the ",0				; First part of last line
	finalb			byte	" term is ",0							; Third part of last line
	 ; st, nd, rd work for numbers that dont have a 1 in the tens place
	stOrd			byte	"st",0									; Ordinal suffix for numbers that end in "1"
	ndOrd			byte	"nd",0									; Ordinal suffix for numbers that end in "2"
	rdOrd			byte	"rd",0									; Ordinal suffix for numbers that end in "3"
	thOrd			byte	"th",0									; Ordinal suffix for numbers that end in a "0", "4" - "9"


.code

;;******************************************************************;
;; Call getNumber()
;; Parameters:		None
;; Returns:			nothing
;; Registers Used:	EAX
;; 
;; Controller for finding the Fibonacci Series
;;		to the user defined n-th term
;;******************************************************************;
getNumber PROC near
_getNumber:
	call writeln
	call writeln

 ; loop to make sure inputted number is less than 45
top:
	 ; Read user input
	push  offset prompt			; Prompt string for user input
	call  readInt				; Get user input as an integer
	mov   var3, eax				; Store input number in var3

	 ; check that the number is less than 45
	cmp   eax, 45
	jg    invalidInput			; Is EAX greater than 45?
	cmp   eax, 0
	jl    invalidInput			; Is EAX less than 0?
	jmp   done
	
 ; Move to printing series
done:
	call  printSeries			; Write the Fibonacci series
	pop   var2					; Pop the final value into var2
	
	cmp   var3, 0				; Is the term limit less than or equal to zero?
	jle   exit					; Jump to exit

	 ; Print "The value of the <nth> term is <value>"
	push  offset final
	call  writeline				; Write first part of final outpu

	push  var3
	call  writeOrdinal			; Write series length with ordinal suffix

	push  offset finalb
	call  writeline				; Write third part of final output

	push  var2
	call  writeNumber			; Write last number in series
	
 ; Return to start
exit:
	ret
	
 ; Type an error for the user
invalidInput:
	;push  offset error
	;call  charCount
	;push  eax
	push  offset error
	call  writeline
	jp    top
getNumber ENDP


;;******************************************************************;
;; Call printSeries()
;; Parameters:	none
;; Returns:		EAX  - Value of n-th term (var2)
;; Registers Used:	EAX, EDX
;; 
;; Prints the Fibonacci Series to the user defined n-th term
;;******************************************************************;
printSeries PROC near
_printSeries:
	cmp   var3, 0				; Check that the term limit is valid
	jl    invalidlimit			; Is the term limit less than zero?
	je    exit					; Is the term limit zero?
	cmp   var3, 45
	jg    invalidlimit			; Is the term limit higher than the hard limit
	mov   eax, var3

 ; Print the initial set in the series
print:
	; Type a message for the user
	push  offset msg
	call  writeline

	 ; Write first two terms
	mov   var1, 1
	mov   var2, 2

	mov   eax, var1
	push  eax
	call  writeNum				; Write the first "1"
	cmp	  var3, 1				; Check if the limit on the series length is less then or equal to 1
	jle	  exit					;		If so, jump to exit

	push  offset termBuffer
	call  writeline				; Write comma and space

	mov	  eax, var2
	push  eax
	call  writeNum				; Write the first "2"
	cmp   var3, 2				; Check if the limit on the series length is less then or equal to 2
	jle	  exit					;		If so, jump to exit

	mov	  itr, 2				; Set initial term number to 2 since the first two terms have been written

 ; Loop to print series
top:
	call  iterater				; Get the next term in the series
	mov	  eax, var3
	cmp	  itr, eax				; Check if the term number reached the limit
	jge	  exit					; Has the term index reached the set amount?

	cmp   itr, 45				; Check if the term number reached the hard limit
	jge   exit					; Has the term index reached the limit?
	jmp	  top					; Until done

exit:
	mov   eax, var2
	pop   edx					; Store return address in EDX
	push  eax					; Save EAX
	push  edx					; Restore return address
	ret

invalidlimit:
	mov var3, 45
	jp print
printSeries ENDP


;;******************************************************************;
;; Call iterater(var1, var2, itr)
;; Parameters:	var1 - value of previous term	(called from memory)
;;				var2 - value of latest term		(called from memory)
;;				itr  - current term				(called from memory)
;; Returns:		Nothing
;; Registers Used:	EAX (s), EBX (s)
;; 
;; Routine to iterate to next element in Fibonacci Series
;;******************************************************************;
iterater PROC near
_iterater:
	push  ebx					; Store EBX
	push  eax					; Store EAX

	push  offset termBuffer
	call  writeline				; Write comma and space
	 ; Try to print a number
	mov   eax, var1
	add   eax, var2
	mov   ebx, var2				; Make sure numbers are not lost 
	mov   var1, ebx				; when EAX is overwritten in
	mov   var2, eax				; writeNumber
	push  eax
	call  writeNum
	
	inc   itr
	pop   eax					; Restore EAX
	pop   ebx					; Restore EBX
	 ; Return to printSeries
	ret
iterater ENDP


;;******************************************************************;
;; Call writeOrdinal(num)
;; Parameters:		num - Number to print with suffix
;; Returns:			Nothing
;; Registers Used:	EAX, ECX (s), EDX
;; 
;; Starts the program and transfers control to start
;;******************************************************************;
writeOrdinal PROC near
_writeOrdinal:
	pop   edx					; Pop return address from the stack into EDX
	pop   eax					; Pop the number into EAX
	push  edx					; Restore return address to the stack
	push  ecx					; Store ECX

	 ; Print the number
	push  eax
	push  eax
	call  writeNum
	pop   eax

	 ; Check if number is 11, 12, or 13, because numbers that have a "1"
	 ;		in the tens place dont follow the pattern of ordinal numbers
	cmp   eax, 11
	je    fourth
	cmp   eax, 12
	je    fourth
	cmp   eax, 13
	je    fourth

	 ; Get the least significant digit
	mov   ecx, 10				; Set the divider to 10
	mov   edx, 0				; Clear EDX for remainder
	div   ecx					; Do the division
	
	 ; Check what remainder is
	cmp   edx, 1				; If the number ends with a "first"
	je    first					; Go to first
	cmp   edx, 2				; If the number ends with a "second"
	je    second				; Go to second
	cmp   edx, 3				; If the number ends with a "third"
	je    third					; Go to third
	jmp   fourth				; If the number ends with a "-th", go to fourth

 ; If last digit is a 1, add a "st"
first:
	push  offset stOrd
	call  writeline
	jmp   endSuf
 ; If last digit is a 2, add a "nd"
second:
	push  offset ndOrd
	call  writeline
	jmp   endSuf
 ; If last digit is a 3, add a "rd"
third:
	push  offset rdOrd
	call  writeline
	jmp   endSuf
 ; If the last digit is not 1, 2, or 3, add a "th"
fourth:
	push  offset thOrd
	call  writeline
	jmp   endSuf
 ; Time to return
endSuf:
	pop ecx						; Restore ECX
	ret
writeOrdinal ENDP

END 