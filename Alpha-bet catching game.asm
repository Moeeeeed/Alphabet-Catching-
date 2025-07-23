[org 0x0100]
jmp Main

oldisr8: dd 0
oldisr9 dd 0
string1: db '(a)PRESS M FOR MULTIPLAYER  (M)'
string2: db '(b)PRESS S FOR SINGLE PLAYER GAME  (S)'
string3: db '(Catch Alphabet Game)'
string4: db '(MULTIPLAYER LEVEL) !'
string5: db '(SINGLE PLAYER LEVEL) !'
string8: db 'GAME ENDED!'
string9: db '-'
string10: db'TIME: '
string11: db'Score: '
string12: db'Dropped: '
string13: db 'You Lost'
string14: db 'You WON'
string15: db 'PRESS T TO TERMINATE AND  S TO PLAY AGAIN'
string16:db'GAME IS ENDED'
lenght16:dw 13


lenght1:dw 31
lenght2:dw 38
lenght3:dw 21
lenght4:dw 21
lenght5:dw 23
lenght8:dw 11
lenght10:dw 6
lenght11:dw 7
lenght12 :dw 9
lenght13: dw 8
lenght14: dw 7
lenght15: dw 41
Maxoffset: dw 4000
CheckIfEscape: db 0
charatlocation: db 0,0,0,0,0
charoffsets: dw 0,0,0,0,0,0
chartimes: dw 1,2,3,2,1
charcolors: db 01h,02h,03h,04h,05h
BoxLocation:dw 3920
SleepOffset: dw 0x7777

Isleft2activiated :dw 0
Isright2activated :dw 0
Isright1activated :dw 0
IsLeft1activated :dw 0
IsShiftIspressed :dw 0
Timer:dw 0
Score:dw 0
Miss :dw 0
ValueForMovingBox: dw 2 
rand: dw 0
randnum: dw 0
BoxLocation2:dw 3900

WinningScore:dw 0
IsMultiplayer: dw 0
IsSinglePlayer:dw 0

ClearTheScreen:
pushf
pusha
mov cx, 2000
mov di, 0
cld
push 0xb800
pop es
mov ax, 0xF120
L1:
stosw
loop L1
popa
popf
ret

PrintNameOfTheGAME:
push ax
push bx
push cx
push dx
push si
push bp
mov bp, sp
push 0xb800
pop es
push 3
push 7
xor ax, ax
mov al, 80
mul byte[bp-2]
mov dl, [bp-4]
add al, dl
shl ax, 1
mov di, ax
mov ah, 0x70
mov al, 'C'
mov si, di
mov cx, 8
l2:
mov [es:di], ax
add di, 160
loop l2
mov cx, 8
l3:
mov [es:di], ax
add di, 2
loop l3
mov di, si
mov al, 'C'
mov cx, 8
l4:
mov [es:di], ax
add di, 2
loop l4
add si, 28
mov di, si
mov cx, 9
l5:
mov [es:di], ax
add di, 160
loop l5
mov di, si
mov cx, 9
l6:
mov [es:di], ax
add di, 2
loop l6
mov cx, 9
l7:
mov [es:di], ax
add di, 160
loop l7
mov di, si
add di, 640
add di, 4
mov cx, 5
l8:
mov [es:di], ax
add di, 2
loop l8
add sp, 4
pop bp
pop si
pop dx
pop cx
pop bx
pop ax
ret

DisplayStaticPage:
pusha
pushf
mov ah, 0x10
mov al, 0x03
mov bl, 01
int 0x10
mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x74
mov dx, 0x120A
mov cx, [lenght1]
push cs
pop es
mov bp, string1
int 0x10
mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x74
mov dx, 0x140A
mov cx, [lenght2]
push cs
pop es
mov bp, string2
int 0x10
mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0x74
mov dx, 0xB22
mov cx, [lenght3]
push cs
pop es
mov bp, string3
int 0x10
popf
popa
ret

Sleep:
push cx
mov cx,[SleepOffset]
hi4:
loop hi4
pop cx
ret

Charstartfalling:
pusha
pushf
sub sp, 2
push 100
call randG
pop cx
add cx, 100

push 0xb800
pop es

l20:

mov al, [CheckIfEscape]
cmp al, '1'
je terminate


mov ah,0x03
mov al,0xDC

mov si,[IsMultiplayer]
cmp si,0
je noMultiplayer
mov di,[BoxLocation2]
mov [es:di],ax

noMultiplayer:
mov di,[BoxLocation]
mov [es:di],ax

char1down:


Start1:
mov al, [charatlocation+0]
cmp al, 0
jne movourchar1
sub sp, 2
push 14
call randG
pop dx
add dl, 0x41
mov [charatlocation+0], dl
sub sp, 2
push 79
call randG
pop dx
xor ax, ax
mov ax, dx
shl ax, 1
mov [charoffsets+0], ax

movourchar1:
mov bx, [Maxoffset]
mov cx, [chartimes+0]
mov dx,[BoxLocation]
down1:
mov di, [charoffsets+0]
mov ax, 0x0720
mov [es:di], ax
mov ah, [charcolors+0]
mov al, [charatlocation+0]
add di, 160
mov word si,[IsMultiplayer]
cmp si,0
je noMultiplayer1
mov si,[BoxLocation2]
cmp di,si
je incscore1
dec di
cmp di,si
je incscore1
dec di
cmp di,si
je incscore1
add di,2
inc di
cmp di,si
je incscore1
inc di
cmp di,si
je incscore1
sub di,2




noMultiplayer1:
cmp di,dx
je incscore1
dec di
cmp di,dx
je incscore1
dec di
cmp di,dx
je incscore1
add di,2
inc di
cmp di,dx
je incscore1
inc di
cmp di,dx
je incscore1
sub di,2
cmp di, bx
jg locationup1
mov [es:di], ax
call Sleep
call Sleep
call Sleep
call Sleep
mov [charoffsets+0], di
loop down1

jmp dontchangeit1

incscore1:
inc word [cs:Score]
mov si,[cs:Score]
mov di,[WinningScore]
cmp si,di
je terminate
cmp si,8
jbe changethechar1
increasespeed1:
mov cx,0x4444
mov [SleepOffset],cx
jmp changethechar1

locationup1:
inc word [cs:Miss]
mov si,[cs:Miss]
cmp si,10
je terminate


changethechar1:
mov di, 0
mov [charoffsets+0], di
mov dl, 0
mov byte [charatlocation+0], dl
jmp Start1



dontchangeit1:


char2down:
mov ah,0x09
mov al,0xDC

mov di,[BoxLocation]
mov [es:di],ax


Start2:
mov al, [charatlocation+1]
cmp al, 0
jne movourchar2
sub sp, 2
push 14
call randG
pop dx
add dl, 0x41
mov [charatlocation+1], dl
sub sp, 2
push 79
call randG
pop dx
xor ax, ax
mov ax, dx
shl ax, 1
mov [charoffsets+2], ax

movourchar2:
mov bx, [Maxoffset]
mov cx, [chartimes+2]
mov dx,[BoxLocation]
down2:
mov di, [charoffsets+2]
mov ax, 0x0720
mov [es:di], ax
mov ah, [charcolors+1]
mov al, [charatlocation+1]
add di, 160
mov word si,[IsMultiplayer]
cmp si,0
je noMultiplayer2
mov si,[BoxLocation2]
cmp di,si
je incscore2
dec di
cmp di,si
je incscore2
dec di
cmp di,si
je incscore2
add di,2
inc di
cmp di,si
je incscore2
inc di
cmp di,si
je incscore2
sub di,2
noMultiplayer2:
cmp di,dx
je incscore2
dec di
cmp di,dx
je incscore2
dec di
cmp di,dx
je incscore2
add di,2
inc di
cmp di,dx
je incscore2
inc di
cmp di,dx
je incscore2
sub di,2
cmp di, bx
jge locationup2
mov [es:di], ax
call Sleep
call Sleep
call Sleep
call Sleep
mov [charoffsets+2], di
loop down2

jmp dontchangeit2

incscore2:
inc word [cs:Score]
mov si,[cs:Score]
mov di,[WinningScore]
cmp si,di
je terminate
cmp si,8
jbe changethechar2
increasespeed2:
mov cx,0x4444
mov [SleepOffset],cx
jmp changethechar2

locationup2:
inc word[cs:Miss]
mov si,[cs:Miss]
cmp si,10
je terminate

changethechar2:
mov di, 0
mov [charoffsets+2], di
mov dl, 0
mov byte [charatlocation+1], dl
jmp Start2

dontchangeit2:

char3down:
mov ah,0x09
mov al,0xDC

mov di,[BoxLocation]
mov [es:di],ax


Start3:
mov al, [charatlocation+2]
cmp al, 0
jne movourchar3
sub sp, 2
push 14
call randG
pop dx
add dl, 0x41
mov [charatlocation+2], dl
sub sp, 2
push 79
call randG
pop dx
xor ax, ax
mov ax, dx
shl ax, 1
mov [charoffsets+4], ax

movourchar3:
mov bx, [Maxoffset]
mov cx, [chartimes+4]
mov dx,[BoxLocation]
down3:
mov di, [charoffsets+4]
mov ax, 0x0720
mov [es:di], ax
mov ah, [charcolors+2]
mov al, [charatlocation+2]
add di, 160
mov word si,[IsMultiplayer]
cmp si,0
je noMultiplayer3
mov si,[BoxLocation2]
cmp di,si
je incscore3
dec di
cmp di,si
je incscore3
dec di
cmp di,si
je incscore3
add di,2
inc di
cmp di,si
je incscore3
inc di
cmp di,si
je incscore3
sub di,2

noMultiplayer3:
cmp di,dx
je incscore3
dec di
cmp di,dx
je incscore3
dec di
cmp di,dx
je incscore3
add di,2
inc di
cmp di,dx
je incscore3
inc di
cmp di,dx
je incscore3
sub di,2
cmp di, bx
jge locationup3
mov [es:di], ax
call Sleep
call Sleep
call Sleep
call Sleep
mov [charoffsets+4], di
loop down3
jmp dontchangeit3

incscore3:
inc word [cs:Score]
mov si,[cs:Score]
mov di,[WinningScore]
cmp si,di
je terminate
cmp si,8
jbe changethechar3
increasespeed3:
mov cx,0x4444
mov [SleepOffset],cx

jmp changethechar3


jmp dontchangeit3

locationup3:
inc word [cs:Miss]
mov si,[cs:Miss]
cmp si,10
je terminate

changethechar3:
mov di, 0
mov [charoffsets+4], di
mov dl, 0
mov byte [charatlocation+2], dl
jmp Start3

dontchangeit3:

char4down:
mov ah,0x09
mov al,0xDC

mov di,[BoxLocation]
mov [es:di],ax


Start4:
mov al, [charatlocation+3]
cmp al, 0
jne movourchar4
sub sp, 2
push 14
call randG
pop dx
add dl, 0x41
mov [charatlocation+3], dl
sub sp, 2
push 79
call randG
pop dx
xor ax, ax
mov ax, dx
shl ax, 1
mov [charoffsets+6], ax
movourchar4:
    mov bx, [Maxoffset]
    mov cx, [chartimes+6]
     mov dx,[BoxLocation]
down4:
    mov di, [charoffsets+6]
    mov ax, 0x0720
    mov [es:di], ax

    mov ah, [charcolors+3]
    mov al, [charatlocation+3]
    add di, 160
	mov word si,[IsMultiplayer]
    cmp si,0
    je noMultiplayer4
mov si,[BoxLocation2]
cmp di,si
je incscore4
dec di
cmp di,si
je incscore4
dec di
cmp di,si
je incscore4
add di,2
inc di
cmp di,si
je incscore4
inc di
cmp di,si
je incscore4
sub di,2




noMultiplayer4:
cmp di,dx
   je incscore4
   dec di
  cmp di,dx
  je incscore4
  dec di
  cmp di,dx
  je incscore4
  add di,2
  inc di
  cmp di,dx
   je incscore4
   inc di
   cmp di,dx
  je incscore4
  sub di,2
  cmp di, bx
  jge locationup4

    mov [es:di], ax
    call Sleep
    call Sleep
    call Sleep
	call Sleep
    mov [charoffsets+6], di
    loop down4

    jmp dontchangeit4

incscore4:
inc word [cs:Score]
mov si,[cs:Score]
mov di,[WinningScore]
cmp si,di
je terminate
cmp si,8
jbe changethechar4
increasespeed4:
mov cx,0x4444
mov [SleepOffset],cx
jmp changethechar4




locationup4:

inc word [cs:Miss]
mov si,[cs:Miss]
cmp si,10
je terminate

changethechar4:
    mov di, 0
    mov [charoffsets+6], di
    mov dl, 0
    mov byte [charatlocation+3], dl

    jmp Start4

dontchangeit4:
   

char5down:
mov ah,0x09
mov al,0xDC

mov di,[BoxLocation]
mov [es:di],ax


Start5:
    mov al, [charatlocation+4]
    cmp al, 0
    jne movourchar5

    sub sp, 2
    push 14
    call randG
    pop dx
    add dl, 0x41
    mov [charatlocation+4], dl

    sub sp, 2
     push 79
    call randG
    pop dx
    xor ax, ax
    mov ax, dx
    shl ax, 1
    mov [charoffsets+8], ax

movourchar5:
    mov bx, [Maxoffset]
    mov cx, [chartimes+8]
    mov dx,[BoxLocation]
down5:
    mov di, [charoffsets+8]
    mov ax, 0x0720
    mov [es:di], ax

    mov ah, [charcolors+4]
    mov al, [charatlocation+4]
   add di,160
   mov word si,[IsMultiplayer]
cmp si,0
je noMultiplayer5
mov si,[BoxLocation2]
cmp di,si
je incscore5
dec di
cmp di,si
je incscore5
dec di
cmp di,si
je incscore5
add di,2
inc di
cmp di,si
je incscore5
inc di
cmp di,si
je incscore5
sub di,2


noMultiplayer5:
   cmp di,dx
je incscore5
dec di
cmp di,dx
je incscore5
dec di
cmp di,dx
je incscore5
add di,2
inc di
cmp di,dx
je incscore5
inc di
cmp di,dx
je incscore5
sub di,2
cmp di, bx
    jge locationup5

    mov [es:di], ax
    call Sleep
    call Sleep
    call Sleep
   call Sleep
    mov [charoffsets+8], di
    loop down5

    jmp dontchangeit5
incscore5:
inc word [cs:Score]
mov si,[cs:Score]
mov di,[WinningScore]
cmp si,di
je terminate
cmp si,8
jbe changethechar5
increasespeed5:
mov cx,0x4444
mov [SleepOffset],cx
jmp changethechar5
locationup5:

inc word [cs:Miss]
mov si,[cs:Miss]
cmp si,10
je terminate

changethechar5:
    mov di, 0
    mov [charoffsets+8], di
    mov dl, 0
    mov byte [charatlocation+4], dl

    jmp Start5

dontchangeit5:
  

    jmp l20

terminate:    
	call ENDCLEAR
    	
	
    popf
    popa
    
	jmp Main
	
	ret

ENDCLEAR:
    pusha
 
    call cls
   
	push 0 
	pop es
	mov ax,[oldisr8]
	mov bx,[oldisr8+2]
	cli 
	mov [es:8*4],ax
	mov [es:8*4+2],bx
	sti
	mov ax,[oldisr9]
	mov bx,[oldisr9+2]
	cli 
	mov [es:9*4],ax
	mov [es:9*4+2],bx
	sti
	xor ax,ax
	xor bx,bx
	mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x081E
    mov cx, [lenght8]
    push cs
    pop es
    mov bp, string8
    int 0x10
      
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0A1E
    mov cx, [lenght10]
    push cs
    pop es
    mov bp, string10
    int 0x10
	 mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0B1E
    mov cx, [lenght11]
    push cs
    pop es
    mov bp, string11
    int 0x10
	
	
	mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0C1E
    mov cx, [lenght12]
    push cs
    pop es
    mov bp, string12
    int 0x10
	
    push 0x28
    push 0x0A
    push word [cs:Timer]
    call printTimer
	
	 push 0x28
    push 0x0B
    push word [cs:Score]
    call printTimer
    
     push 0x28
    push 0x0C
    push word [cs:Miss]
    call printTimer	
	

    mov ax,[Score]
    mov bx,[Miss]  
    cmp ax,bx	 
    jg YOUWONLABEL
	 

	mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0F1E
    mov cx, [lenght13]
    push cs
    pop es
    mov bp, string13
    int 0x10
	
     
	jmp cumhere
	
	YOUWONLABEL:
     mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0F1E
    mov cx, [lenght14]
    push cs
    pop es
    mov bp, string14
    int 0x10
	 
	cumhere:
	mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x111E
    mov cx, [lenght15]
    push cs
    pop es
    mov bp, string15
	int 0x10
	 
	call SleepMore
	
	mov ah, 0
    int 16h
	
	mov ah, 0
    int 16h
    cmp ah,20
    je end

    cmp ah,31
    je endtothis
	
	endtothis:
	

    popa
    
	ret

cls:
    pushf
    pusha
    mov cx, 2000
    mov di, 0
    cld
    push 0xb800
    pop es
    mov ax, 0x0720

L10:
    stosw
    loop L10

    popa
    popf
    ret

randG:
    push bp
    mov bp, sp
    pusha
    cmp word [rand], 0
    jne next

    MOV AH, 00h
    INT 1AH
    inc word [rand]
    mov [randnum], dx
    jmp next1

next:
    mov ax, 25173
    mul word [randnum]
    add ax, 13849
    mov [randnum], ax

next1:
    xor dx, dx
    mov ax, [randnum]
    mov cx, [bp+4]
    inc cx
    div cx
    mov [bp+6], dx
    popa
    pop bp
    ret 2


SleepMore:
pusha
pushf

mov cx,0xFFFF
hi11:
loop hi11
mov cx,0xFFFF
hi12:
loop hi12
mov cx,0xFFFF
hi13:
loop hi13
mov cx,0xFFFF
hi14:
loop hi14
mov cx,0xFFFF
hi54:
loop hi54
mov cx,0xFFFF
hi75:
loop hi75
mov cx,0xFFFF
hi68:
loop hi68
mov cx,0xFFFF
hi77:
loop hi77
mov cx,0xFFFF
hi88:
loop  hi88

popf
popa
ret

CallMultiplayer:
    pusha
    pushf
    call cls

    push 0
    pop es

    xor ax,ax
	mov es,ax
	mov ax,[es:9*4]
	mov [oldisr9],ax
	mov ax,[es:9*4+2]
	mov [oldisr9+2],ax
	xor ax,ax
	mov es,ax
	mov ax,[es:8*4]
	mov [oldisr8],ax
	mov ax,[es:8*4+2]
	mov [oldisr8+2],ax
	
	cli
	mov word [es:9*4], HOOKED9
    mov word [es:9*4+2], cs
	mov word [es:8*4],HOOKED8
	mov word [es:8*4+2],cs
	sti                                          


    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0002
    mov dx, 0x0C12
    mov cx, [lenght4]
    push cs
    pop es
    mov bp, string4
    int 0x10
    call SleepMore
    call SleepMore
    call SleepMore
    call SleepMore
    call SleepMore
    call SleepMore
    call cls
	
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0046
    mov cx, [lenght10]
    push cs
    pop es
    mov bp, string10
    int 0x10
	 mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0145
    mov cx, [lenght11]
    push cs
    pop es
    mov bp, string11
    int 0x10
	
	mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0243
    mov cx, [lenght12]
    push cs
    pop es
    mov bp, string12
    int 0x10
	mov ax,1
	mov word [IsMultiplayer],ax
    mov ax,20
	mov word [WinningScore],ax
    call Charstartfalling
    
    popf
    popa
    ret
	
	
printTimer:
push bp
mov bp,sp
push es
push ax
push bx
push cx
push dx
push di

mov ax,0xb800
mov es,ax
mov ax,[bp+4]
mov bx,10
mov cx,0
DECIMAL:
mov dx,0
div bx
add dl,0x30
push dx
inc cx
cmp ax,0
jnz DECIMAL

xor ax,ax
mov al,80
mul byte [bp+6];row adress
mov bl,[bp+8];col adress
add al,bl
shl ax,1
mov di,ax
AtMost:
pop dx
mov dh,0x02
mov [es:di],dx
add di,2
loop AtMost

pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 6

	
HOOKED8:
pusha
inc word [cs:Timer]
push 76
push 0
push word[cs:Timer]
call printTimer
push 76
push 1
push word[cs:Score]
call printTimer
push 76
push 2
push word[cs:Miss]
call printTimer
mov al,0x20
out 0x20,al

popa
iret

CallSinglePlayerGame:
    pusha
    pushf
    call cls


    push 0
    pop es

    xor ax,ax
	mov es,ax
	mov ax,[es:9*4]
	mov [oldisr9],ax
	mov ax,[es:9*4+2]
	mov [oldisr9+2],ax
	xor ax,ax
	mov es,ax
	mov ax,[es:8*4]
	mov [oldisr8],ax
	mov ax,[es:8*4+2]
	mov [oldisr8+2],ax
	
	cli
	mov word [es:9*4], HOOKED9
    mov word [es:9*4+2], cs
	mov word [es:8*4],HOOKED8
	mov word [es:8*4+2],cs
	sti


    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0002
    mov dx, 0x0C12
    mov cx, [lenght5]
    push cs
    pop es
    mov bp, string5
    int 0x10
    call SleepMore
    call SleepMore
    call SleepMore
    call SleepMore
    call SleepMore
    call SleepMore
    call cls
	
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0046
    mov cx, [lenght10]
    push cs
    pop es
    mov bp, string10
    int 0x10
	 mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0145
    mov cx, [lenght11]
    push cs
    pop es
    mov bp, string11
    int 0x10
	
	mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0243
    mov cx, [lenght12]
    push cs
    pop es
    mov bp, string12
    int 0x10
	mov ax,1
	mov word [IsSinglePlayer],ax
    mov ax,10
	mov word [WinningScore],10
    call Charstartfalling
    
    popf
    popa
    ret

PutTheBoxAtCentre:
    push ax
	push di
    
    push 0xb800
    pop es
	
	mov ah,0x06
	mov al,0xDC
	mov di,[BoxLocation]
	mov [es:di],ax
	
    pop di
	pop ax
    
	ret

HOOKED9:
pusha
pushf

    in al,0x60
 
cmp al, 0x4B
je leftpressed          ; Left Arrow Pressed

cmp al, 0x4D
je rightpressed         ; Right Arrow Pressed

cmp al, 0x01
je SETESCAPE            ; Escape Pressed

cmp al, 0x2A
je SHIFTPRESSED         ; Left Shift Pressed

cmp al, 0xAA
je ShiftIsRelesed       ; Left Shift Released

cmp al, 0x1E
je Apressed             ; 'A' Key Pressed

cmp al, 0x20
je Dpressed             ; 'D' Key Pressed

cmp al, 0xCB
je LeftRealeased        ; Left Arrow Released

cmp al, 0xCD
je RightRealeased       ; Right Arrow Released

cmp al, 0x9E
je Areleased            ; 'A' Key Released

cmp al, 0xA0
je Dreleased            ; 'D' Key Released (Corrected)

	
 jmp dropit 
  
  leftpressed:
  mov dx,1
  mov word [IsLeft1activated],dx
  
  jmp dropit
  
  rightpressed:
  mov dx,1
  mov word [Isright1activated],dx
  
  jmp dropit
  
  LeftRealeased:
  mov dx,0
  mov word [IsLeft1activated],dx
  
  jmp dropit
  
  RightRealeased:
   mov dx,0
  mov word [Isright1activated],dx
  
  jmp dropit
 
  Apressed:
    mov di,[IsMultiplayer]
  cmp di,0
  je dropit
  mov dx,1
  mov dx,1
  mov word [Isleft2activiated],dx
  
  jmp dropit
  
  Dpressed:
  mov di,[IsMultiplayer]
  cmp di,0
  je dropit
  mov dx,1
  mov word [Isright2activated],dx
 
  jmp dropit   
  
  Areleased:
  mov dx,0
  mov word [Isleft2activiated],dx
   
  jmp dropit
  
  Dreleased:
  
  mov dx,0
  mov word [Isright2activated],dx

 jmp dropit
 
 SHIFTPRESSED:
 mov cx,4
  mov [ValueForMovingBox],cx

  jmp dropit

  ShiftIsRelesed:
   mov cx,2
   mov [ValueForMovingBox],cx

  jmp dropit

  SETESCAPE:
   mov byte [CheckIfEscape], '1'

  jmp dropit
 
dropit:

   call MoveskeysNow

    mov al, 20h
    out 20h, al


popf
popa
iret

MoveskeysNow:
pusha

 mov ax,[IsLeft1activated]
 cmp ax,1
 
 jne CheckNext1
 mov di,[BoxLocation]
 cmp di,3840
 je endmoveskey 
 mov ax,0x0720
  mov [es:di],ax	
  mov di,[BoxLocation]
  mov si,[ValueForMovingBox]
  sub di,si
  mov [BoxLocation],di
   mov ah,0x03
   mov al,0xDC


  mov di,[BoxLocation]
   mov [es:di],ax

CheckNext1:

mov ax,[Isright1activated]
cmp ax,1
jne CheckNext2
  mov di,[BoxLocation]
 cmp di,3998
 je endmoveskey 
  mov ax,0x0720
  mov [es:di],ax
   mov di,[BoxLocation]
   mov si,[ValueForMovingBox]
   add di,si
   mov [BoxLocation],di
 
   mov ah,0x03
   mov al,0xDC


  mov di,[BoxLocation]
   mov [es:di],ax

CheckNext2:
mov ax,[Isleft2activiated]
cmp ax,1
jne CheckNext3

mov di,[BoxLocation2]
 cmp di,3840
 je endmoveskey 
  mov ax,0x0720
  mov [es:di],ax	
  mov di,[BoxLocation2]
  mov si,[ValueForMovingBox]
  sub di,si
  mov [BoxLocation2],di
    mov ah,0x03
   mov al,0xDC


  mov di,[BoxLocation2]
   mov [es:di],ax
   
CheckNext3:
mov ax,[Isright2activated]
cmp ax,1
jne endmoveskey

 mov di,[BoxLocation2]
  cmp di,3998
 je endmoveskey 
 mov ax,0x0720
  mov [es:di],ax
   mov di,[BoxLocation2]
   mov si,[ValueForMovingBox]
   add di,si
   mov [BoxLocation2],di
   mov ah,0x03
   mov al,0xDC


  mov di,[BoxLocation2]
   mov [es:di],ax

endmoveskey:

popa
ret

ResetAllMemeory:
pusha

mov dl,0
mov cx,5
mov ax,1
mov bx,charatlocation
l100:
mov byte [bx],dl
inc bx
loop l100
mov dx,0
mov cx,5
mov bx,charatlocation
l101:
mov word [charatlocation],dx
add bx,2
loop l101     
mov dx,3920
mov [BoxLocation],dx
mov dx,3930
mov [BoxLocation2],dx
mov dx,0
mov word [CheckIfEscape],dx
mov word [Timer],dx
mov word [Score],dx
mov word [Miss],dx
mov word [IsSinglePlayer],dx
mov word[IsMultiplayer],dx
mov cx,0xFFFF
mov [SleepOffset],cx
mov ax,2
mov word [ValueForMovingBox],2
popa

ret

lol:
pop ax
Main:

    call ResetAllMemeory
    call ClearTheScreen
    call DisplayStaticPage
    call PrintNameOfTheGAME
    call Sleep
        
	 

    mov ah, 0
    int 16h
    cmp ah, 50
    je CallMultiplayer

    cmp ah, 31
    je CallSinglePlayerGame

end:

call cls
mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 0x0001
    mov dx, 0x0C1E
    mov cx, [lenght16]
    push cs
    pop es
    mov bp, string16
    int 0x10

   


   mov ax, 0x4c00
    int 0x21
