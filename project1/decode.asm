global _start
section .text
_start:
	jmp DecodeFinal
Decode_Start:
	pop edx
	dec edx
	xor ecx,ecx
	mov cl,0xf0
Decode_loop:
	xor byte [edx+ecx],0xce
	loop Decode_loop
	jmp DecodeEnd
DecodeFinal:
	call Decode_Start
DecodeEnd:

;---------------------printf-------------------------------------
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx
	xor edx,edx
	push eax
	push byte 0x0a
	push 0x21776f4e
	push 0x206e7552
	push 0x202c746e
	push 0x7548206e
	push 0x61687445
	mov ecx,esp
	mov al, 4
        mov dl, 21
        int 0x80
;------------------------sleep 2 minutes--------------------------
;int nanosleep(const struct timespec *req, struct timespec *rem);
;-----------------------------------------------------------------

	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx	
	
	; push 0x00000000 on the stack 
	push eax
	push eax
	push byte 0x0a  ;req->tv_sec 0x78 = 120

	mov ebx,esp
	mov al, 0xa2 ; nanosleep = 162, or 0xa2
	int 0x80 ; nanosleep(ebx, ecx)
	
;------------------------delete the file--------------------------
;int execve(const char *filename, char *const argv[], char *const envp[]);
;-----------------------------------------------------------------
	;push 0x00000000 on the Stack because the end of string

	xor eax, eax
	push eax
	
	;push //bin/rm in reverse i.e. mr/nib//
	
	push 0x6d722f6e
	push 0x69622f2f

	mov ebx,esp

	;push 0x00000000 on the Stack because the end of string 

	push eax
	mov edx, esp

	;push "text" in reverse
	
	push word 0x6578
	push 0x652e656c
	push 0x62697373
	push 0x6f706d69
	push 0x5f6e6f69
	push 0x7373696d

	mov esi,esp
	
	;push 0x00000000 on the Stack because the end of string 

	push eax

	;push the address of "mission_impossible.exe" on the stack
	
	push esi

	;push the address of "//bin/rm" on the stack
	
	push ebx	
	mov ecx,esp

	mov al,11
	int 0x80
	mov al,1
	xor ebx,ebx
	int 0x80

