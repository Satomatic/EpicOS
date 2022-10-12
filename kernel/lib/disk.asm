SIDES dw 2
SPT   dw 18

;;
;; Convert CTS to LBA
;;
logicalSectorConvert:
	push bx
	push ax

	mov bx, ax

	mov dx, 0
	div word [SPT]
	add dl, 0x01
	mov cl, dl
	mov ax, bx

	mov dx, 0
	div word [SPT]
	mov dx, 0
	div word [SIDES]
	mov dh, dl
	mov ch, al

	mov dl, 0x0

	pop ax
	pop bx

	ret

;;
;; Load file into memory
;; DI :: File name buffer
;; DX :: Memory location
;; BX :: Execute flag (0 == noexec || 1 == exec)
;;
DL_LOAD_FILE:
	; The file table is stored at the 16th sector
	mov ax, 16

	push bx 

.loadFileEntities:
	mov si, dx

	;;
	;; 4 Sectors make up the file table, this
	;; can be changed.
	;;
	push dx
	call logicalSectorConvert
	mov ah, 0x02
	mov al, 0x04
	mov bx, si
	int 13h
	pop dx

	;;
	;; AX will be used in the next section for
	;; keeping an index
	;;
	mov ax, 0x0

;;
;; Go through each entry and strcmp the filename.
;;
;; @todo This can be optimised quite a bit by checking the dircetory
;;       first then checking the filename
;;
.cycleFileEntities:
	mov bx, ax
	mov cx, ax

	add bx, dx               ; Set BX to the file table memory location
	add bx, 4                ; Move to the fourth byte (start of filename)
	mov si, bx               ; Move it so SI for string compare
	call strcmp

	cmp al, 1                ; If the file name is correct go to the next check
	je .foundFilename

	mov ax, cx
	add ax, 40               ; Move to the next entry (+40 bytes)

	cmp ax, 2040             ; If it reaches the end of the file table, file not found
	jg .eFileNotFound

	jmp .cycleFileEntities

.foundFilename:
	;;
	;; Check if the file is marked as global
	;;
	cmp [bx - 1], byte 1
	je .globalpass

	;;
	;; Check the session directory
	;;
	mov cl, byte [GLOBAL_SESSION_DIRNODEID]
	mov ch, byte [bx - 2]

	cmp cl, ch
	jne .cycleFileEntities

.globalpass:
	pop ax

	cmp ax, 0
	je .convertSector

	cmp [bx - 4], byte 1     ; Check the file is a binary file, not text or anything
	jne .eNotBinary


;;
;; @todo This is dog shit, find a new solution to this, its literally so simple just do it c*nt
;;
.convertSector:
	push ax

	mov al, byte [bx - 3]    ; Get the sector position of the file
	mov bx, 20
	mov ah, 0

.loop:
	cmp ah, al
	je .load

	inc bx
	inc ah

	jmp .loop

;;
;; Load the file into the requested memory location
;;
.load:
	mov si, dx
	push dx

	mov ax, bx
	call logicalSectorConvert

	mov ah, 0x02
	mov al, 0x01
	mov bx, si
	int 13h

	pop dx

	pop ax

	cmp ax, 0
	je .end

	call dx

	jmp .end

.eNotBinary:
	mov si, E_NOBINARY
	mov bx, 0x0C
	call print
	jmp .end

.eFileNotFound:
	pop ax                 ; pop the register pushed at the beginning so it returns correctly
	mov si, E_NOFILE
	mov bx, 0x0C
	call print

.end:
	ret

E_NOFILE   db '[!] File not found', 0x0a, 0x0d, 0
E_NOBINARY db '[!] Cannot run non-binary file', 0x0a, 0x0d, 0

;;
;; Update the global directory string
;;
DL_UPDATE_GDIR:
	ret

;;
;; Find file in directory by ID
;; AX :: File ID
;;
;; SI :: File header
;;
DL_FIND_FILE_ID:
	push ax

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

	pop ax

	mov bx, 40
	mul bx

	add si, ax

.end:
	ret
