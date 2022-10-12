;;
;; Print string to screen buffer
;; SI :: String buffer
;; BX :: Color bytes
;;
IL_PRINT:
	push ax
	mov ah, 0Eh
.loop:
	lodsb
	cmp al, 0
	je .end
	int 10h
	jmp .loop
.end:
	pop ax
	ret

;;
;; Take input from user
;; DI :: Destination string
;;
IL_INPUT:
	mov bx, 0x0
.loop:
	mov ah, 0x0
	int 16h

	cmp al, 13
	je .returnEvent

	cmp al, 8
	je .backspaceEvent

	mov [di+bx], byte al

	push bx
	mov ah, 0Eh
	mov bx, 0x0F
	int 10h
	pop bx

	inc bx
	jmp .loop

.returnEvent:
	mov si, endl
	call print
	ret

.backspaceEvent:
	jmp .loop

.end:
	ret