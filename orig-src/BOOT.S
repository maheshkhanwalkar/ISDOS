BITS 16

start:
mov ah, 0Fh
int 10h

mov ah, 00h
int 10h

;call lchvid_mode_640_480_resl_16_color

mov ax, 07C0h
add ax, 288
mov ss, ax
mov sp, 4096

mov ax, 07C0h
mov ds, ax 

mov cx, 0607h
mov ah, 01h

int 10h

;call lprintk_col_blue

mov si, init_text
call lprintk_str

;call lprintk_col_white

mov si, copy_text
call lprintk_str 
call lprintk_new

;call lprintk_col_green

mov si, notice_text1
call lprintk_str 

mov si, notice_text2
call lprintk_str

mov si, notice_text3
call lprintk_str

mov si, thanks_text
call lprintk_str

call lprintk_new

mov si, istext_edit
call lprintk_str

mov dl, 0
mov dh, 09h

user_type:
mov ah, 00h
int 16h

cmp al, 08h
je user_backspace

cmp al, 0Dh
je user_enter

cmp al, 09h
je user_tab

continue:
mov ah, 0Ah
mov bh, 00h
mov cx, 0001h
int 10h

mov ah, 02h
mov bh, 00h
;mov dh, 07h
add dl, 01h

int 10h
jmp user_type

user_backspace:
mov ah, 02h
mov bh, 00h
cmp dl, 00h
je user_back_new

sub dl, 01h
int 10h

mov ah, 0Ah
mov al, 20h
mov bh, 00h
mov cx, 0001h
int 10h



int 10h
jmp user_type

user_enter:
mov ah, 02h
mov bh, 00h
add dh, 01h
mov dl, 00h

int 10h
jmp user_type

user_back_new:
mov ah, 02h
mov bh, 00h
mov dl, 4Fh
sub dh, 01h

int 10h
jmp user_type

user_tab:
mov ah, 02h
mov bh, 00h
add dl, 06h

int 10h
jmp user_type

;call lwait_nohang removed as it is also cpu intensive 
;jmp $ deprecated as it is cpu intensive

call lwait_nohang1 ;the cpu-friendly os hanger :)!

;====||||||START DATA SECTION||||||====;

init_text db 'Inix Software Disk Operating System (ISDOS)', 0
copy_text db 'Copyright (c) Inix Software', 0

notice_text1 db 'Note:', 0
notice_text2 db 'The terms of use of ISDOS is stated in the Inix Software General License', 0
notice_text3 db 'To access the license, please go to http://www.inixsoftware.com/', 0
thanks_text db 'Thank you.', 0
istext_edit db 'Inix Software Text Editor v1.1 Started', 0

;====||||||END DATA SECTION||||||====;

;lchvid_mode_640_480_resl_16_color: 
 ;  mov ax, 0x0012
  ; int 10h
   ;ret


lwait_nohang1:
  cli
  hlt

lprintk_new: 
   mov al, 0
   stosb

   mov ah, 0Eh
   mov al, 0Dh
   int 10h
   mov al, 0Ah 
   int 10h
   ret


lprintk_str:
   mov ah, 0Eh

.repeat:
   lodsb
   cmp al, 0
   je .done
   int 10h

   jmp .repeat

.done:
   call lprintk_new
   ret

times 510-($-$$) db 0
dw 0xAA55
