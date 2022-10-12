; IO library
print            equ 2
input            equ 8

; Disk library
DiskLoad         equ 14
DiskFileByID     equ 20
GDIRUpdate       equ 26
DiskLBAConv      equ 32

; String library
strcmp           equ 38
strclr           equ 44
strcpy           equ 50

; Session globals
getDirectory     equ 56
getDirectoryName equ 62
getUserLogin     equ 68
getDirectoryStor equ 74

setDirectory     equ 80
setDirectoryName equ 86

setDircetoryStor equ 92

; Array library
arraySplit       equ 98
arrayGet         equ 104

; Shell library
getArgv          equ 110
setArgv          equ 116

endl db 0x0a, 0x0d, 0