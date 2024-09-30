 ; Fibonacci Series
 ; Jonathan Burgener
 ; Monday, 30 September, 2024
 ; Prints the numbers in the Fibonacci Series up to a user-inputted number.
 ; 
 ; Registers Used:
 ;		EAX - Store current number to push to console
 ;		EDX - Temporarily store number for moving data

.model flat

extern charCount:	near
extern readline:	near
extern writeline:   near
extern writeNumber: near

.data

	var1			DD	 ? ; first number to add
	var2			DD	 ? ; second number to add
	var3			DD	 ? ; term to stop at: From user input
	itr				DD	 ? ; current term of the series
	temp			byte ? ; temporarily store a byte
	prompt			byte "Please enter max number (<45): ", 0 ; ends with string terminator (NULL or 0)
	results         byte  10,"You typed: ", 0
	numCharsToRead  dword 1024
	bufferAddr		dword ?

.code

 ; Gets number from user input and checks that it is less than 45
getNumber PROC near
_getNumber:

	; loop to make sure inputted number is less than 45
top:
	 ; Type a prompt for the user
     ; WriteConsole(handle, &Prompt[0], 17, &written, 0)
	push offset prompt
    call charCount
    push eax
    push offset prompt
    call writeline

	 ; Read user input
	call findInput
	mov eax, var3
	 ; If input is 0, return
	cmp  eax, 0
	jle  exit
	 ; check that the number is less than 45
	mov	 var3, eax
	sub	 eax, 45
	cmp	 eax, 0
	jle	 done
	jmp	 top

	 ; Move to printing series
done:
	call printSeries
	ret
	
	 ; Return to start
exit:
	ret

getNumber ENDP

 ; Prints the Fibonacci Series
printSeries PROC near
_printSeries:
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
	je	  exit
	jmp	  top

exit:
	ret

printSeries ENDP

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

	push ecx ; Preserve working registers
	push edx

	xor ecx, ecx
	mov edx, eax
atoi: ; Zero result found so far
	xor eax, eax

top: ; Start loop to parse input
	mov cl, dl ; Get a character
	inc  edx
	cmp  ecx, '0'
	jb   fin
	cmp  ecx, '9'
	ja   fin
	sub  ecx, '9'
	ja   fin
	sub  ecx, '0' ; Cast character to number
	imul eax, 10
	add	 eax, ecx 
	jmp  top ; Until done

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
	pop edx
	pop ecx
	mov var3, eax
	push eax
	call writeNumber
	ret ; Return to getNumber

findInput ENDP

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