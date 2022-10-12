; IO library
jmp long IL_PRINT
jmp long IL_INPUT

; Disk library
jmp long DL_LOAD_FILE
jmp long DL_FIND_FILE_ID
jmp long DL_UPDATE_GDIR
jmp long logicalSectorConvert

; String library
jmp long SL_STRING_CMP
jmp long SL_STRING_CLR
jmp long SL_STRING_CPY

; Session globals
jmp long G_GLOBAL_DIR
jmp long G_GLOBAL_DIRNAME
jmp long G_GLOBAL_USR
jmp long G_GLOBAL_STO

jmp long S_GLOBAL_DIR
jmp long S_GLOBAL_DIR
jmp long S_GLOBAL_STO

; Array library
jmp long AL_NULL_AT_CHAR
jmp long AL_SEEK_INDEX

; Shell library
jmp long SH_GET_ARGUMENTS
jmp long SH_SET_ARGUMENTS