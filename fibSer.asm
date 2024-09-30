 ; Fibonacci Series
 ; Jonathan Burgener
 ; Monday, 30 September, 2024
 ; Prints the numbers in the Fibonacci Series up to a user-inputted number.

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
	numCharsToRead  dword	1024
	bufferAddr		dword	?

.code

 ; Gets number from user input and checks that it is less than 45
getNumber PROC near
_getNumber:

	; loop to make sure inputted number is less than 45
top:
	 ; Type a prompt for the user
     ; WriteConsole(handle, &Prompt[0], 17, &written, 0)
	push  offset prompt
    call  charCount
    push  eax
    push  offset prompt
    call  writeline

	 ; Read user input
	call  findInput
	mov   eax, var3

	;push eax
	;call writeNumber
	;mov eax, var3
	 ; check that the number is less than 45
	mov	 var3, eax
	cmp	 eax, 45
	jge	 top
	cmp  eax, 0
	jl	 top
	jmp	 done

	 ; Move to printing series
done:
	push eax
	call writeNumber
	call printSeries
	ret
	
	 ; Return to start
exit:
	ret

getNumber ENDP


 ; Routine to get user input and convert it to an integer
findInput PROC near
_findInput:
	 ; Read what the user inputed
	call  readLine

	; Prints input back to user
    ; writeline(&results[0], 12)
    mov   bufferAddr, eax
    push  offset results
    call  charCount
    push  eax
    push  offset results
    call  writeline
    push  numCharsToRead
    push  bufferAddr
    call  writeline

	 ; Preserve working registers
	push  ecx ; Current character
	push  ebx ; Base data
	push  edx ; Destination register

	mov  ebx, eax
atoi: ; Zero result found so far
	xor  edx, edx

top: ; Start loop to parse input
	xor   ecx, ecx 	; Clear ECX
	movzx ecx, bl 	; Get a character
	inc   ebx		; Increment base value
	cmp   cl, '0'	
	jb    fin		; Does the character precede '0'?
	cmp   cl, '9'	
	ja    fin		; Does the character follow '9'?
	sub   cl, '0'	; Cast character to number
	imul  edx, 10	; Shift saved digits to the left
	add	  edx, ecx	; Add new digit to number
	jmp   top		; Until done

	;movzx ecx, byte [edx] ; get a character
	;inc edx ; ready for next one
	;cmp ecx, '0' ; valid?
	;jb .done
	;cmp ecx, '9'
	;ja .done
	;sub ecx, '0' ; "convert" character to number
	;imul eax, 10 ; multiply "result so far" by ten
	;add eax, ecx ; add in current digit
	;jmp .top ; until done
	
fin:
	mov   var3, edx
	push  edx
	call  writeNumber
	
	 ; Restore working data
	pop  edx
	pop  ebx
	pop  ecx

	ret ; Return to getNumber

findInput ENDP


 ; Prints the Fibonacci Series
printSeries PROC near
_printSeries:
	; Type a message for the user
    ; WriteConsole(handle, &Prompt[0], 17, &written, 0)
    push  offset msg
    call  charCount
    push  eax
    push  offset msg
    call  writeline

	 ; Write first two terms
	mov  var1, 1
	mov  var2, 2

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
	ret

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
	pop	  eax
    
    inc   itr

    ; Return to printSeries
    ret                 

iterater ENDP
END 