;;
;; Compare to string buffers
;; SI :: String A
;; DI :: String B
;;
;; AL :: Return status (1 == pass ~ 0 == fail)
;;
SL_STRING_CMP:
	push bx
	mov bx, 0 
.loop:
	mov al, [si + bx]
	mov ah, [di + bx]
	
	cmp al, ah
	jne .fail

	cmp al, byte 0
	je .pass

	inc bx
	jmp .loop

.fail:
	mov al, 0
	jmp .end

.pass:
	mov al, 1

.end:
	pop bx
	ret

;;
;; Clear a string buffer
;; SI :: String to clear
;;
SL_STRING_CLR:
	pusha
	mov bx, 0
.loop:
	mov al, [si+bx]
	cmp al, byte 0
	je .end
	mov [si+bx], byte 0
	inc bx
	jmp .loop
.end:
	popa
	ret

;;
;; Copy a string to a memory address
;; SI :: String to copy
;; DI :: Location to copy to
;;
;; @note This function will automatically null
;;       terminate the string.
;;
SL_STRING_CPY:
	pusha
	mov bx, 0
.loop:
	cmp [si+bx], byte 0
	je .end
	mov al, byte [si+bx]
	mov [di+bx], al
	inc bx
	jmp .loop
.end:
	mov [di+bx], byte 0
	popa
	ret