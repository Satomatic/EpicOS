[ORG 0x1E00]

jmp start

start:
.start_init:
	push ax

	;;
	;; Set graphics mode
	;;
	mov ah, 00h
	mov al, 12h
	mov bl, 00h
	int 10h

	;;
	;; Set color scheme
	;;
	mov ax, 1010h
	mov dh, 0
	mov ch, 11
	mov cl, 13
	mov bx, 3
	int 10h

	;;
	;; Set background color
	;;
	mov ah, 0Bh
	mov bh, 0
	mov bx, 3
	int 10h

	pop ax
	cmp ax, 0xCF
	je .init

	;;
	;; Print opening message
	;;
	mov si, ShellWelcome
	mov bx, 7
	call print

	mov si, ShellHelp
	mov bx, 13
	call print

	;;
	;; Show username prompt
	;;
	mov si, LOGIN_PRMP
	mov bx, 0x0F
	call print

	call getUserLogin
	mov bx, 0x0B
	call print

	mov si, endl
	call print

	mov si, endl
	call print

.init:
	;;
	;; Print the input prompt and set the character
	;; index to 0
	;;
	call PrintPrompt
	call GDIRUpdate
	mov bx, 0

.loop:
	mov ah, 0
	int 16h

	cmp al, 13
	je .eReturnKey

	cmp al, 8
	je .eBackspaceKey

	mov [INPUT_BUFF + bx], byte al
	call PrintBuffer

	inc bx
	jmp .loop

;;
;; Event return key
;;
.eReturnKey:
	mov si, BICMD_EXIT
	mov di, INPUT_BUFF
	call strcmp

	cmp al, 1
	je .bExit

	mov si, BICMD_CLRS
	mov di, INPUT_BUFF
	call strcmp

	cmp al, 1
	je .bClear

	mov si, endl
	call print

	;;
	;; If there is no input given we shouldn't bother trying to execute
	;;
	cmp bx, 0
	je .continue

	mov si, INPUT_BUFF
	call setArgv
	call getArgv
	
	;;
	;; The shell should always load programs into memory address 0x2000
	;; while the shell is kept in 0x1E00
	;;
	mov di, si
	mov dx, 0x2000
	call DiskLoad

	mov si, endl
	call print

.continue:
	mov si, INPUT_BUFF
	call strclr

	jmp .init

;;
;; Event backspace key
;;
.eBackspaceKey:
	cmp bx, 0
	je .loop

	dec bx
	mov [INPUT_BUFF + bx], byte 0

	call PrintBuffer

	jmp .loop

.bExit:
	mov si, endl
	call print

	mov si, ExitMessage
	mov bx, 0x0F
	call print
	ret

.bClear:
	mov si, INPUT_BUFF
	call strclr

	mov ax, 0xCF
	jmp .start_init

;;
;; Print the prompt before the inputted text
;;
PrintPrompt:
	pusha
	call getDirectoryName
	mov bx, 0x0D
	call print

	mov si, COMMD_PREF
	mov bx, 0x0C
	call print
	popa

	ret

;;
;; Print the input buffer
;;
PrintBuffer:
	pusha
	mov ah, 0Eh
	mov al, 0x0d
	int 10h

	call PrintPrompt

	mov si, INPUT_BUFF
	mov bx, 0x0F
	call print

	mov ah, 0Eh
	mov al, ' '
	int 10h
	popa

	ret

ShellWelcome db 'EpicOS command line interface v4.0', 0x0a, 0x0d, 0
ShellHelp    db 'type "help" for more information', 0x0a, 0x0d, 0x0a, 0
ExitMessage  db '[@] Exiting shell...', 0x0a, 0x0d, 0

INPUT_BUFF times 20 db 0
DIREC_BUFF times 20 db 0
COMMD_PREF db ' @ >> ', 0
LOGIN_PRMP db 'Session :: logged in as @', 0

BICMD_CLRS db 'clear', 0
BICMD_EXIT db 'exit', 0

%include "kernel/api.asm"