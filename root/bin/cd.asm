[ORG 0x2000]

start:
	call getArgv
	mov ax, 1
	call arrayGet

	cmp [si + 1], byte '.'
	je .backDirectory

	mov di, si

	mov ax, 16
	call DiskLBAConv

	mov si, 0x2200
	mov bx, si
	mov ah, 0x02
	mov al, 0x04
	int 13h

	add si, 40

.loop:
	mov al, byte [si+5]
	cmp al, byte 0
	je .end

	;;
	;; Check filename
	;;
	add si, 4
	call strcmp
	sub si, 4

	cmp al, 1
	jne .nextEntry

	;;
	;; Check if item is in current directory
	;;
	call getDirectory
	mov ah, byte [si + 2]
	cmp ah, byte al
	jne .nextEntry

	call setDircetoryStor

	mov al, [si + 1]
	call getDirectoryName
	call setDirectory

.dirNameLoop:
	lodsb
	cmp al, byte 0
	je .dirNameCopy
	jmp .dirNameLoop

.dirNameCopy:
	sub si, 1
	mov di, si
	call getArgv
	mov ax, 1
	call arrayGet
	call strcpy

	mov si, di

.dirCharLoop:
	lodsb
	cmp al, byte 0
	je .dirEnd
	jmp .dirCharLoop

.dirEnd:
	sub si, 1
	mov [si], byte '/'
	mov [si + 1], byte 0
	ret

.nextEntry:
	add si, 40
	jmp .loop

.backDirectory:
	call getDirectory
	call DiskFileByID

	mov al, [si + 2]
	call getDirectoryName
	call setDirectory

	mov di, si
	mov ah, 0

.backCharLoop:
	lodsb
	cmp al, byte 0
	je .backCharLoopB
	jmp .backCharLoop

.backCharLoopB:
	dec si
	cmp [si], byte '/'
	je .backCharAdd
	jmp .backCharLoopB

.backCharAdd:
	cmp ah, 1
	je .backCharLoopEnd
	inc ah
	jmp .backCharLoopB

.backCharLoopEnd:
	mov [si + 1], byte 0

.end:
	ret

%include "kernel/api.asm"