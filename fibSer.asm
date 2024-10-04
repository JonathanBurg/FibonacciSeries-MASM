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
	input			dword	?
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

	mov eax, var3
	push eax
	call writeNumber
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
	call printSeries
	
	 ; Return to start
exit:
	ret

getNumber ENDP


 ; Routine to get user input and convert it to an integer
findInput PROC near
_findInput:
	 ; Store working registers
	push  eax
	push  ebx
	push  ecx
	push  edx
	push  esi
	xor   eax, eax
	xor   ebx, ebx
	xor   ecx, ecx
	xor   edx, edx
	xor   esi, esi

	 ; Read what the user inputed
top:
	call  readLine
	mov input, eax
	
	; Print input back to user
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

	; Check length of input
	mov   eax, offset input
	push  eax
	call  charCount
	cmp   eax, 3
	jg	  top

	; Convert string to an integer
	

	mov esi, offset input
	cmp byte ptr [esi],'-'

	je negative		;if input ='s a - then jump to negative.
	mov ch, 0		;ch=0, a flag for positive
	jmp convert		; if positive then jump to convert.

negative:
	mov ch,1		;ch =1, a flag for negative
	inc esi			; esi -> the first digit char
	convert:
	mov al,[esi]	;al = first digit char
	sub al,48		; subtracts al by 48 first digit
	movzx eax,al	;al=>eax, unsigned
	mov ebx,10		;ebx=>10, the multiplier

next:
	inc esi					;what's next?
	cmp byte ptr [esi], '0'	;end of string
	jl fin					; if finished store result in var3
	cmp byte ptr [esi], '9' 
	jg fin

	mul ebx					;else, eax*ebx==>edx eax
	mov dl,[esi]			;dl = next byte
	sub dl,48				;dl=next digit
	movzx edx,dl			;dl => edx, unsigned
	add eax,edx
	jmp next

fin:
	cmp ch, 1				; a negative number?
	je changeToNeg
	jmp storeResult

changeToNeg:
	neg eax
storeResult:
	mov var3,eax

	 ; Restore working registers
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret 		; Return to getNumber
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
	push itr
	call writeNumber
	push var3
	call writeNumber
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
    
    inc   itr

    ; Return to printSeries
    ret                 

iterater ENDP
END 