 ; Fibonacci Series
 ; Jonathan Burgener
 ; Monday, 30 September, 2024
 ; Prints the numbers in the Fibonacci Series up to a user-inputted number.
 ; 
 ; Revised: JB,  7 October, 2024 - Finally got a reliable way to convert a string to an int; Removed debug messages
 ; Revised: JB, 16 October, 2024 - Updated headers and added final statement to user

.model  flat

extern  charCount:	 near
extern  readline:	 near
extern  writeline:	 near
extern  writeNumber: near
extern	writeln:	 near
extern	readInt:	 near

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
	input			dword	?
	numCharsToRead	dword	1024
	bufferAddr		dword	?

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
	;call  findInput
	push  offset prompt
	call  readInt
	mov   var3, eax

	 ; check that the number is less than 45
	mov	 eax, var3
	cmp	 eax, 45
	jg	 invalidInput
	cmp  eax, 0
	jl	 invalidInput
	jmp	 done
	
 ; Move to printing series
done:
	call printSeries
	
 ; Return to start
exit:
	ret
	
 ; Type an error for the user
invalidInput:
	push  offset error
	call  charCount
	push  eax
	push  offset error
	call  writeline
	jp    top
getNumber ENDP


;;******************************************************************;
;; Call findInput(var3)
;; Parameters:	var3 - User input integer, series length
;; Returns:		EAX  - Value of n-th term (var2)
;; Registers Used:	EAX
;; 
;; Prints the Fibonacci Series to the user defined n-th term
;;******************************************************************;
printSeries PROC near
_printSeries:
	cmp   var3, 0
	jl    invalidlimit
	je    exit
	cmp   var3, 45
	jg    invalidlimit
	mov   eax, var3

print:
	; Type a message for the user
	push  offset msg
	call  charCount
	push  eax
	push  offset msg
	call  writeline

	 ; Write first two terms
	mov   var1, 1
	mov   var2, 2

	mov   eax, var1
	push  eax
	call  writeNumber
	cmp	  var3, 1
	je	  exit

	mov	  eax, var2
	push  eax
	call  writeNumber
	cmp   var3, 2
	je	  exit

	mov	  itr, 2

	 ; Loop to print series
top:
	call  iterater
	mov	  eax, var3
	cmp	  itr, eax
	jge	  exit	; Has the term index reached the set amount?

	cmp   itr, 45
	jge   exit	; Has the term index reached the limit?
	jmp	  top	; Until done

exit:
	mov eax, var2
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
;; Registers Used:	EAX, EBX
;; 
;; Routine to iterate to next element in Fibonacci Series
;;******************************************************************;
iterater PROC near
_iterater:
	 ; Try to print a number
	mov   eax, var1
	add   eax, var2
	mov   ebx, var2		; Make sure numbers are not lost 
	mov   var1, ebx		; when EAX is overwritten in
	mov   var2, eax		; writeNumber
	push  eax
	call  writeNumber
	
	inc   itr

	 ; Return to printSeries
	ret
iterater ENDP
END 