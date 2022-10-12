;;
;; Split string by adding null at character
;; SI :: String buffer
;; AL :: Character
;;
AL_NULL_AT_CHAR:
	mov bx, 0
.loop:
	cmp [si+bx], byte 0
	je .end
	cmp [si+bx], al
	jne .next
	mov [si+bx], byte 0
.next:
	inc bx
	jmp .loop

.end:
	ret

;;
;; Go through some split data and return at index
;; SI :: String buffer
;; AX :: Index
;;
AL_SEEK_INDEX:
	push bx
	mov bx, ax
	mov cx, ax

	cmp ax, 0
	je .found

.loop:
	lodsb
	cmp al, byte 0
	jne .loop
	sub bx, 1
	cmp bx, 0
	je .found
	jmp .loop
.found:
	pop bx
	mov ax, cx
	ret