;[ORG 0x1E00]
[ORG 0X2000]

;;
;; @~> login
;; Login to a different user
;;

start:
.init:
	mov bx, 0x0F

	;;
	;; Get username input 
	;;
	mov si, u_string
	call print

	mov di, u_buffer
	call input

	;;
	;; Get password input
	;;
	mov bx, 0x0F
	mov si, p_string
	call print

	mov di, p_buffer
	call input

	;;
	;; Load user login information
	;;
	mov di, u_filename
	mov dx, 0x3000
	mov bx, 0
	call DiskLoad

	mov si, 0x3000
	mov al, byte ':'
	call arraySplit

	mov ax, 0           ; Current index
	mov bx, bx          ; Max index

.loop:
	cmp ax, bx          ; If current index is last
	je .fail

	mov si, 0x3000      ; Get user login array
	call arrayGet       ; Get the current index

	mov di, temp_buffer ; Move data to temp buffer for second split
	call strcpy

	;;
	;;
	;;
	pusha
	mov si, temp_buffer
	mov al, byte '@'
	call arraySplit

	;;
	;; Check username
	;;
	mov si, temp_buffer ; Compare username against user input
	mov di, u_buffer
	call strcmp


	cmp al, 1           ; If not correct, error
	jne .continue

	mov si, temp_buffer
	mov ax, 1
	call arrayGet
	mov di, p_buffer
	call strcmp

	cmp al, 1
	je .login

.continue:
	popa

	inc ax

	jmp .loop

.fail:
	mov si, u_buffer
	call strclr

	mov si, p_buffer
	call strclr

	mov si, e_badlog
	mov bx, 0x0F
	call print

	jmp .init

.login:
	popa

	call getUserLogin
	mov di, si
	mov si, u_buffer
	call strcpy

	mov si, s_success
	mov bx, 0x0F
	call print

	mov si, u_buffer
	mov bx, 0x0B
	call print

	mov si, endl
	call print

.end:
	ret

u_string db "User >> ", 0
p_string db "Pass >> ", 0

e_badlog db 'Invalid username or password', 0x0a, 0x0d, 0
s_success db 0x0a, 0x0d, 'Now logged in as @', 0

u_filename db 'usr.txt', 0

u_buffer times 10 db 0
p_buffer times 10 db 0

temp_buffer times 25 db 0

%include "kernel/api.asm"