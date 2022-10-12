[BITS 16]
[ORG 0x2000]

;;
;; Quick and dirty LS command ported from an old project
;; Version 1.0.0
;;

main:
	mov si, OpenMsg
	mov bx, 0x0F
	call print
	call getDirectoryName
	call print
	mov si, endl
	call print

	;
	; Read filesystem object index
	;
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

	; save si in di
	mov di, si

	;;
	;; Check if item is in current directory
	;;
	call getDirectory
	mov si, di
	mov ah, byte [si + 2]
	cmp ah, byte al
	jne .nextEntry

	mov al, byte [si + 3]
	cmp al, 1
	je .globalPass

	push ax
	mov ah, 0Eh
	mov al, byte ' '
	int 10h
	pop ax

.globalContinue:
	mov al, byte [si]

	cmp al, 0x0
	je .directory

	cmp al, 0x1
	je .binary

	cmp al, 0x2
	je .krn

	cmp al, 0x3
	je .txt

.txt:
	mov si, TypeTxt
	jmp .continue

.directory:
	mov si, TypeDir
	jmp .continue

.krn:
	mov si, TypeKrn
	jmp .continue

.binary:
	mov si, TypeBin

.continue:
	mov bx, 0x0A
	call print

	mov si, di

	; print filename
	add si, 4
	mov bx, 0x0F
	call print
	
	; new line
	mov si, endl
	call print

.nextEntry:	
	; move di back into si
	mov si, di

	add si, 40

	jmp .loop

.end:
	ret

.globalPass:
	pusha
	mov ah, 0Eh
	mov al, byte '@'
	mov bx, 0x0B
	int 10h
	popa
	jmp .globalContinue

TypeDir db ' [ DIR ] ', 0x0
TypeBin db ' [ BIN ] ', 0x0
TypeTxt db ' [ TXT ] ', 0x0
TypeKrn db ' [ KRN ] ', 0x0
OpenMsg db 'Directory listing of: ', 0

%include "kernel/api.asm"
