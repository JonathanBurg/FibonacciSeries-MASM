 ; Fibonacci Series
 ; Jonathan Burgener
 ; Monday, 30 September, 2024
 ; Prints the numbers in the Fibonacci Series up to a user-inputted number.
 ;
 ; Revised: JB, 7 October, 2024 - Finally got a reliable way to convert a string to an int

.model  flat

extern  charCount:	near
extern  readline:	near
extern  writeline:   near
extern  writeNumber: near

.data

	var1			DD  	? ; first number to add
	var2			DD  	? ; second number to add
	var3			DD  	? ; term to stop at: From user input
	itr				DD  	? ; current term of the series
	temp			byte	? ; temporarily store a byte
	prompt			byte	10,"Please enter max number (<45): ", 0 ; ends with string terminator (NULL or 0)
	msg				byte	10,"Fibonacci Series: ", 10, 0 ; ends with string terminator (NULL or 0)
	results         byte	10,"You typed: ", 0
	input			dword	?
	numCharsToRead  dword	1024
	bufferAddr		dword	?

.code

 ; Gets number from user input and checks that it is less than 45
getNumber PROC near
_getNumber:

	; loop to make sure inputted number is less than 45
top:
	 ; Read user input
	call  findInput

	;mov eax, var3
	;push eax
	;call writeNumber
	;push eax
	;call writeNumber
	;mov eax, var3
	 ; check that the number is less than 45
	mov	 eax, var3
	cmp	 eax, 45
	jg	 top
	cmp  eax, 0
	jl	 top
	jmp	 done

	 ; Move to printing series
done:
	call printSeries
	
	 ; Return to start
exit:
	ret

getNumber ENDP


 ; Routine to get user input and convert it to an integer
findInput PROC near
_findInput:
	 ;	Source of delay in completion, was struggling to find a way to
	 ;		reliably convert a string to an integer
	 ; Store working registers
	push  eax
	push  ebx
	push  ecx
	push  edx
	xor   eax, eax
	xor   ebx, ebx
	xor   ecx, ecx
	xor   edx, edx

	; Type a prompt for the user
     ; WriteConsole(handle, &Prompt[0], 17, &written, 0)
	push  offset prompt
    call  charCount
    push  eax
    push  offset prompt
    call  writeline

	call  readline
	mov   ecx, eax

 ; Take what was read and convert to a number
    mov   eax, 0                ; Initialize the number
    mov   ebx, 0                ; Make sure upper bits are all zero.
    
findNumberLoop:
    mov   bl, [ecx]      ; Load the low byte of the EBX reg with the next ASCII character.
    cmp   bl, '9'               ; Make sure it is not too high
    jg   endNumberLoop
    sub   bl, '0'               
    cmp   bl, 0                 ; or too low
    jl    endNumberLoop
    mov   edx, 10              ; save multiplier for later need
    mul   edx
    add   eax, ebx
    inc   ecx                   ; Go to next location in number
    jmp   findNumberLoop

 endNumberLoop:
	 ; var3 has the new integer when the code completes. And ) if no digits found.
	mov var3, eax

	; Restore working registers
	pop edx
	pop ecx
	pop ebx
	pop eax

	; Return to getNumber
	ret
findInput ENDP


 ; Prints the Fibonacci Series
printSeries PROC near
_printSeries:
	cmp   var3, 0
	jl    invalidlimit
	je    exit
	cmp   var3, 45
	jg    invalidlimit
	mov   eax, var3
	;push eax
	;call writeNumber
print:

	; Type a message for the user
    ; WriteConsole(handle, &Prompt[0], 17, &written, 0)
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
	;push itr
	;call writeNumber
	;push var3
	;call writeNumber
	ret

invalidlimit:
	mov var3, 45
	jp print

printSeries ENDP


; Routine to iterate to next element in Fibonacci Series
iterater PROC near
_iterater:
    ; Try print a number
    mov   eax, var1
    add   eax, var2
    mov   ebx, var2   ; Make sure numbers are not lost 
    mov   var1, ebx   ; when EAX is overwritten in
    mov   var2, eax   ; writeNumber
    push  eax
    call  writeNumber
    
    inc   itr

    ; Return to printSeries
    ret                 

iterater ENDP
END 