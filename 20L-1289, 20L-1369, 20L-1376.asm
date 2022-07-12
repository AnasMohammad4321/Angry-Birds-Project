; Mohammad Anas 20L-1289
; Mansoor Tariq 20L-1369
; Sana Ahmed Khan 20L-1376
; BDS-3B
;COAL PROJECT
;ANGRY BIRDS

[org 0x100]
jmp main
load: db 'Loading...  ', 0
ending: db 'Press Enter to end the game.', 0
score: db 'SCORE:', 0
hit: db 0
s: dw 0

; ANAS' CODE
loading:
        push ax
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov di, 0 ; point di to top left column
        nextloc1: 
            mov word [es:di], 0x3020 ; clear next char on screen
            add di, 2 ; move to next screen location
            cmp di, 4000 ; has the whole screen cleared
            jne nextloc1 ; if no clear next position
            mov ax, 0xE020  ;attribute +11
        push 0x0220
        mov ax, load
        push ax
        push 36
        push 10

        call printstr
        call printDots
        pop ax
        ret
        
    printDots:
        push es
        pusha
        mov ax, 0xb800
        mov es, ax ; point es to video base
        mov cx, 10
        mov ax, 0x30FE
        mov di, 1832
        cld ; auto increment mode
    l11:
        stosw
        mov dx, 12
    l2:
        call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
        dec dx
        cmp dx, 0
        jne l2
        loop l11
        popa
        pop es
        ret
        
    sleep: 
        push cx
        mov cx, 0xFFFF
    delay1: 
        loop delay1
        pop cx
	ret
clrscr:		
	push es
	push ax
	push di
	
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, 0 ; point di to top left column
	nextloc: 
		mov word [es:di], 0x0720 ; clear next char on screen
		add di, 2 ; move to next screen location
		cmp di, 4000 ; has the whole screen cleared
		jne nextloc ; if no clear next position
	pop di
	pop ax
	pop es
	ret 

drawBow:
	push bp
	mov bp, sp
	push ax

	mov ax, 0xE020; character
	push ax
	mov ax, 18; top
	push ax
	mov ax, 21; bottom
	push ax
	mov ax, 8; left
	push ax
	call drawVertical
	
	mov ax, 0xE020; character
	push ax
	mov ax, 18; top
	push ax
	mov ax, 6; left
	push ax
	mov ax, 11 ;right
	push ax
	call drawHorizontal

	mov ax, 0xE020; character
	push ax
	mov ax, 16; top
	push ax
	mov ax, 18; bottom
	push ax
	mov ax, 6; left
	push ax
	call drawVertical

	mov ax, 0xE020; character
	push ax
	mov ax, 16; top
	push ax
	mov ax, 18; bottom
	push ax
	mov ax, 10; left
	push ax
	call drawVertical

	pop ax
	pop bp
	ret 

drawdiamond:	
	;subroutine to draw diamond on screen
				push bp		;stack order: x [bp+4], y [bp+6]
				mov bp, sp
				push es
				push di
				push ax
				push cx
	mov ax, 0xb800
	mov es, ax
	mov al, 80
	mul byte [bp+6]
	add ax, [bp+4]
	shl ax, 1
	mov di, ax
	
	mov ax, 0x3F2A	;white asterisk on aqua background
	mov cx, 3
	rep stosw		;stosw-> mov [es:di], ax		rep-> repeats cx times
	
	add di, 156
	mov [es:di], ax
				
				pop cx
				pop ax
				pop di
				pop es
				pop bp
				ret 4	;x, y

drawVertical:
	push bp
	mov bp, sp
	push ax
	push cx
	push es
	push di

	push 0xb800
	pop es
	
	;finding the location
	mov al, 80
	mul byte[bp + 8]; top
	add ax, [bp + 4]; left/right
	shl ax, 1
	mov di, ax
	
	;loop count
	mov cx, [bp + 6]; bottom
	sub cx, [bp + 8]; top
	mov ax, [bp + 10]; character
	
	loop4:
		mov [es:di], ax
		add di, 160
		loop loop4
		
	pop di
	pop es
	pop cx
	pop ax
	pop bp
	
	ret 8
	
drawHorizontal:
	push bp
	mov bp, sp
	push ax
	push cx
	push es
	push di
	
	push 0xb800
	pop es
	
	;finding the location
	mov al, 80
	mul byte[bp + 8]
	add ax, [bp + 6]
	shl ax, 1
	mov di, ax
	
	;loop count
	mov cx, [bp + 4]; right
	sub cx, [bp + 6]; left
	
	mov ax, [bp + 10]; character
	
	loop2:
		mov [es:di], ax
		add di, 2
		loop loop2
		
	pop di
	pop es
	pop cx
	pop ax
	pop bp
	
	ret 8

PrintRectangle:
	push bp
	mov bp, sp
	push ax
	push cx
	push di
	push es
	
	;top line
		mov ax, [bp+12]; character
		push ax
		mov ax, [bp+10]; top
		push ax
		mov ax, [bp+6]; left
		push ax
		mov ax, [bp+4]; right
		push ax
		call drawHorizontal
		
		;left line
		mov ax, [bp+12]; character
		push ax
		mov ax, [bp+10]; top
		push ax
		mov ax, [bp+8]; bottom
		push ax
		mov ax, [bp+6]; left
		push ax
		call drawVertical
		
		;right line
		mov ax, [bp+12]; character
		push ax
		mov ax, [bp+10]; top
		push ax
		mov ax, [bp+8]; bottom
		push ax
		mov ax, [bp+4]; right
		sub ax, 1		;adjustment of right coordinate
		push ax
		call drawVertical
		
		;bottom line
		mov ax, [bp+12]; character
		push ax
		mov ax, [bp+8]; bottom
		sub ax, 1		;adjustment of bottom coordinate
		push ax
		mov ax, [bp+6]; left
		push ax
		mov ax, [bp+4]; right
		push ax
		call drawHorizontal
	
						pop es
						pop di
						pop cx
						pop ax
						pop bp
						ret 10	;right, left, bottom, top, character with attribute
		
delay:
	push cx
	mov cx, 50 ; change the values  to increase delay time
	delay_loop1:
		push cx
		mov cx, 0xFFFF
	delay_loop2:
		loop delay_loop2
		pop cx
		loop delay_loop1
		pop cx
	ret

position:
	; y = [bp + 4], x = [bp + 6]
	push bp
	mov bp, sp
	push ax
	
	mov al, 80
	mul word[bp + 4]; 80*y
	add ax, [bp + 6]; 80* y + x
	shl ax, 1; (80* y + x)*2
	mov di, ax
	
	pop ax
	pop bp
	
	ret 4

strlen:
	push bp
	mov bp, sp
	push cx
	push es
	push di
	
	les di, [bp + 4]
	xor al, al
	mov cx, 0xffff
	repne scasb 
	mov ax, 0xffff
	sub ax, cx
	dec ax
	
	pop di
	pop es
	pop cx
	pop bp
	
	ret 4
						
printstr:
			;subroutine to print string on screen
			; y = [bp + 4], x = [bp + 6], string = [bp + 8], attribute = [bp + 11]
            push bp
			mov bp, sp
            push ax
            push cx
            push es
            push di
            push si
			

    push 0xB800
	pop es
	
	push ds; data segment
	push word[bp + 8]; string
	call strlen
    cmp ax, 0
    je exit

    mov cx, ax
	mov ax, 0

	push word[bp+6]; x
    push word[bp+4]; y
    call position

    mov ah, [bp + 11]
	mov si, [bp+8]
	
	cld
	nextchar:
		lodsb 
		stosw
		loop nextchar
	
	
	exit:
		pop si
        pop di
        pop es 
		pop cx
		pop ax
		pop bp
	
	ret 8

printnum:	
		                push bp
						mov bp, sp
						push es
						push ax
						push bx
						push cx
						push dx
						push di
						mov ax, 0xb800
						mov es, ax ; point es to video base
		
						push word[bp+6]; x
						push word[bp+4]; y
						call position
		
						mov ax, [s] ; load number in ax
						mov bx, 10 ; use base 10 for division
						mov cx, 0 ; initialize count of digits
    nextdigit:
                mov dx, 0 ; zero upper half of dividend
                div bx ; divide by 10
                add dl, 0x30 ; convert digit into ascii value
                push dx ; save ascii value on stack
                inc cx ; increment count of values
                cmp ax, 0 ; is the quotient zero
                jnz nextdigit ; if no divide it again
    nextpos: 
                pop dx ; remove a digit from the stack
                mov dh, 0x02 ; use normal attribute
                mov [es:di], dx ; print char on screen
                add di, 2 ; move to next screen location
                loop nextpos ; repeat for all digits on stack

                pop di
                pop dx
                pop cx
                pop bx
                pop ax
                pop es
                pop bp
                ret 6

PrintCloud:
	;right 		bp + 4
	;left 		bp + 6
	;bottom 	bp + 8
	;top		bp + 10
	;character  bp + 12
	push bp
	mov bp, sp
	push ax
	push cx
	push di
	push es
	
	;base line
		mov ax, [bp+12]; character
		push ax
		mov ax, [bp+10]; top
		push ax
		mov ax, [bp+6]; left
		push ax
		mov ax, [bp+4]; right
		push ax
		call drawHorizontal
	;mid line
		mov ax, [bp + 12]
		push ax
		mov ax,[bp + 10]
		dec ax
		push ax
		mov ax, [bp + 6]
		add ax, 2
		push ax
		mov ax, [bp + 4]
		sub ax, 2
		push ax
		call drawHorizontal
	;top line
		mov ax, [bp + 12]
		push ax
		mov ax,[bp + 10]
		sub ax, 2
		push ax
		mov ax, [bp + 6]
		add ax, 5
		push ax
		mov ax, [bp + 4]
		sub ax, 5
		push ax
		call drawHorizontal
	
	pop es
	pop di
	pop cx
	pop ax
	pop bp

	ret 10

drawBird:
	push bp
	mov bp, sp
	push es
	push di
	push ax
	push bx
	push cx
	mov ax, 0xb800
	mov es, ax
	mov di, [bp + 4]
	mov cx, 5
	mov bx, 0

	mov word [es:di - 2], 0x3420 ;hair

	l1:                                   ;body loop
		mov word [es:di + bx], 0x4420 
		mov word [es:di + bx + 160], 0x4420 
		mov word [es:di + bx + 320], 0x4420 
		mov word [es:di + bx + 480], 0x6420
		add bx, 2
		loop l1

	mov word [es:di + 4 + 160], 0x876f ;eye

	mov word [es:di + 10 + 160], 0xEE00 ;beak
	mov word [es:di + 12 + 160], 0xEE00

	pop cx
	pop bx
	pop ax
	pop di
	pop es
	pop bp
	ret 2
printBricks:
	cmp byte[hit], 0
	je full
	cmp byte[hit], 1
	je middle
	cmp byte[hit], 2
	je middle2
	cmp byte[hit], 3
	je middle3
	cmp byte[hit], 4
	je destroy

	middle:
		call mid
		ret
	middle2:
		call mid2
		ret
	middle3:
		call mid3 
		ret
	destroy:
		ret
	full:
		; Lower Red horizontal slab
		mov dx, 2994 ;starting position +8 
		push dx
		mov si, 3016 ; limit; +6
		push si
		mov bx, 0x4420 ;+4
		push bx
		call print1

		; Upper Red horizontal slab
		mov dx, 2348 
		push dx
		mov si, 2382
		push si
		mov bx, 0x4420 ;+4
		push bx
		call print1

		;Most upper Red horizontal slab
		mov dx, 1220
		push dx
		mov si, 1270
		push si
		mov bx, 0x4420 ;+4
		push bx
		call print1

		;lower left brown (down) vertical
		mov dx, 2190 
		push dx
		call print2

		mov dx, 1870 
		push dx
		call print2

		mov dx, 1710 
		push dx
		call print2

		;lower right brown (down) vertical
		mov dx, 2216
		push dx
		call print2

		mov dx, 1896
		push dx
		call print2

		mov dx, 1736
		push dx
		call print2

		;upper left brown (down) vertical
		mov dx, 1070
		push dx
		call print2

		mov dx, 910
		push dx
		call print2

		;upper right brown (down) vertical
		mov dx, 936
		push dx
		call print2

		mov dx, 1096
		push dx
		call print2

		mov dx, 3150
		push dx
		call print3

		mov dx, 3176
		push dx
		call print3

		mov dx, 2834
		push dx
		call print4

		mov dx, 2854
		push dx
		call print5

		;lower jin
		mov dx, 1730
		call print6

		;upper jin
		mov dx, 610
		call print6
		ret

mid:
				; Lower Red horizontal slab
			mov dx, 2994 ;starting position +8 
			push dx
			mov si, 3016 ; limit; +6
			push si
			mov bx, 0x4420 ;+4
			push bx
			call print1

			; Upper Red horizontal slab
			mov dx, 2348 
			push dx
			mov si, 2382
			push si
			mov bx, 0x4420 ;+4
			push bx
			call print1

			;lower right brown (down) vertical
			mov dx, 2216
			push dx
			call print2

			mov dx, 1896
			push dx
			call print2

			mov dx, 1736
			push dx
			call print2

			mov dx, 3150
			push dx
			call print3

			mov dx, 3176
			push dx
			call print3

			mov dx, 2834
			push dx
			call print4

			mov dx, 2854
			push dx
			call print5

			;lower jin
			mov dx, 1730
			call print6

			 ret
mid2:
				; Lower Red horizontal slab
			mov dx, 2994 ;starting position +8 
			push dx
			mov si, 3016 ; limit; +6
			push si
			mov bx, 0x4420 ;+4
			push bx
			call print1

			mov dx, 3150
			push dx
			call print3

			mov dx, 3176
			push dx
			call print3

			mov dx, 2834
			push dx
			call print4

			mov dx, 2854
			push dx
			call print5

			ret
mid3:
		; Lower Red horizontal slab
		mov dx, 2994 ;starting position +8 
		push dx
		mov si, 3016 ; limit; +6
		push si
		mov bx, 0x4420 ;+4
		push bx
		call print1

		; Upper Red horizontal slab
		mov dx, 2348 
		push dx
		mov si, 2382
		push si
		mov bx, 0x4420 ;+4
		push bx
		call print1

		;Most upper Red horizontal slab
		mov dx, 1220
		push dx
		mov si, 1270
		push si
		mov bx, 0x4420 ;+4
		push bx
		call print1

		;lower left brown (down) vertical
		mov dx, 2190 
		push dx
		call print2

		mov dx, 1870 
		push dx
		call print2

		mov dx, 1710 
		push dx
		call print2

		;lower right brown (down) vertical
		mov dx, 2216
		push dx
		call print2

		mov dx, 1896
		push dx
		call print2

		mov dx, 1736
		push dx
		call print2

		;upper right brown (down) vertical
		mov dx, 936
		push dx
		call print2

		mov dx, 1096
		push dx
		call print2

		mov dx, 3150
		push dx
		call print3

		mov dx, 3176
		push dx
		call print3

		mov dx, 2834
		push dx
		call print4

		mov dx, 2854
		push dx
		call print5

		;lower jin
		mov dx, 1730
		call print6

		;upper jin
		mov dx, 610
		call print6
		ret

printTrees:
		push 35   ;x position
		push 14   ;y position
		push 3   ;height of tree
		call tree3

		push 20
		push 13
		push 3
		call tree2
		
		push 45
		push 13
		push 3
		call tree

		ret

printClouds:
			;	PRINTING 5 CLOUDS OF DIFFERENT SIZES
		mov ax, 0x992A
		push ax
		push 3; top
		push 5; bottom
		push 2; left
		push 15; right
		call PrintCloud

		mov ax, 0x992A
		push ax
		push 5; top
		push 10; bottom
		push 17; left
		push 32; right
		call PrintCloud

		mov ax, 0x992A
		push ax
		push 3; top
		push 5; bottom
		push 33; left
		push 45; right
		call PrintCloud

		ret

printIntial:
		call delay
		call setBackground 
		call printBricks
		call printTrees
		call drawBow
		call printClouds
		push 0x0220		;green on black
		push score		;"SCORE"
		push 72			;x
		push 0			;y							
		call printstr
		push s			;number
		push 78			;x
		push 0			;y
		call printnum
		push 2092
		call drawBird
		ret
printSimple:
		call delay
		call setBackground 
		call printBricks
		call printTrees
		call drawBow
		call printClouds
		push 0x0220		;green on black
		push score		;"SCORE"
		push 72			;x
		push 0			;y							
		call printstr
		push s			;number
		push 78			;x
		push 0			;y
		call printnum
		push 2082
		call drawBird
		ret
printUp:
		mov cx, 15
		mov bx, 1930
		push bx
		printup:
			call delay
			call setBackground 
			call printBricks
			call printTrees
			call drawBow
			call printClouds
			push 0x0220		;green on black
			push score		;"SCORE"
			push 72			;x
			push 0			;y							
			call printstr
			push s			;number
			push 78			;x
			push 0			;y
			call printnum
			pop bx
			push bx
			call drawBird
			sub bx, 150
			push bx
			cmp bx, 430
			je exitup
			loop printup
		exitup:
			pop bx
			mov byte[hit], 3
			add word[s], 9
			ret
printParabola:
		mov cx, 5
		mov bx, 1930
		push bx
		printparabolaUp:
			call delay
			call setBackground 
			call printBricks
			call printTrees
			call drawBow
			call printClouds
			push 0x0220		;green on black
			push score		;"SCORE"
			push 72			;x
			push 0			;y							
			call printstr
			push s			;number
			push 78			;x
			push 0			;y
			call printnum
			pop bx
			push bx
			call drawBird
			sub bx, 150
			push bx
			loop printparabolaUp
		mov bx, 1180
		mov cx, 5
		printparabolaDown:
			call delay
			call setBackground 
			call printBricks
			call printTrees
			call drawBow
			call printClouds
			push 0x0220		;green on black
			push score		;"SCORE"
			push 72			;x
			push 0			;y							
			call printstr
			push s			;number
			push 78			;x
			push 0			;y
			call printnum
			pop bx
			push bx
			call drawBird
			cmp di, 2030
			je exitparabola
			add bx, 170
			push bx
			cmp bx, 2030
			je exitparabola
			loop printparabolaDown

		exitparabola:
			pop bx
			mov byte[hit], 1
			add word[s], 9
			ret


printStraight:
		mov cx, 10
		mov bx, 2082
		push bx
		printstraight:
			call delay
			call setBackground 
			call printBricks
			call printTrees
			call drawBow
			call printClouds
			push 0x0220			;green on black
			push score		;"SCORE"
			push 72			;x
			push 0			;y							
			call printstr
			push s			;number
			push 78			;x
			push 0			;y
			call printnum
			pop bx
			push bx
			call drawBird
			add bx, 12
			push bx
			cmp bx, 2202
			je exitstraigth
			loop printstraight
		exitstraigth:
			pop bx
			mov byte[hit], 2
			add word[s], 9
			ret

printDown:
		mov cx,4
		mov bx, 2082
		push bx
		printdown1:
			call delay
			call setBackground 
			call printBricks
			call printTrees
			call drawBow
			call printClouds
			push 0x0220			;green on black
			push score		;"SCORE"
			push 72			;x
			push 0			;y							
			call printstr
			push s			;number
			push 78			;x
			push 0			;y
			call printnum
			pop bx
			push bx
			call drawBird
			add bx, 168
			push bx
		; 	cmp bx, 2202
		; 	je exitstraigth
		 	loop printdown1
		mov bx, 2754
		mov cx, 10
		printdown2:
			call delay
			call setBackground 
			call printBricks
			call printTrees
			call drawBow
			call printClouds
			push 0x0220			;green on black
			push score		;"SCORE"
			push 72			;x
			push 0			;y							
			call printstr
			push s			;number
			push 78			;x
			push 0			;y
			call printnum
			pop bx
			push bx
			call drawBird
			add bx, 10
			push bx
		 	cmp bx, 2834
		 	je exitdown
		 	loop printdown2

		exitdown:
		 	pop bx
		 	mov byte[hit], 4
		 	add word[s], 9
			ret
; MANSOOR'S CODE
setBackground: 
    push es 
    push ax 
    push cx 
    push di

    mov ax, 0xb800
    mov es, ax 
    xor di, di 
    mov ax, 0x3020    ;sky blue colour
    mov cx, 1600

    cld
    rep stosw

    mov cx,400
    mov ax,0x2a1c
    
    rep stosw

    pop di 
    pop cx 
    pop ax 
    pop es 
    
    ret
 
tree:
	;storing values of registers and segements on the stacks
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	
	mov ax, 0xb800  ; accessing video memory
	mov es, ax      ;ponting es towards video memory
	mov al, 80      ; load al with columns per row 
	mul byte [bp+6] ; multiply with y position
	add ax, [bp+8]  ; add x position
	mov cx,[bp+4]   ;moving height of tree in cx
	shl ax, 1        
	mov di,ax 
	
	mov bx,2
	mov dx,bx
	mov ax,0xa12a   ; ascii of * is 2a  and attribute green background with white foreground
	mov [es:di],ax
	dec cx
	
	loop1:
		add ah,2
		add di,158
		push di
		mov [es:di],ax
 
	a:
		add di,2
		mov [es:di],ax
		dec bx
		cmp bx,0
		jne a
		pop di
		mov bx,dx
		add bx,2
		mov dx,bx
		loop loop1
		
		mov cx,[bp+4]
		dec cx
	b: 
		add di,162
		loop b
		
		mov [es:di],ax
		push di
		mov bx,2
		mov dx,bx
		
		mov cx,[bp+4]
		dec cx
		dec cx
	loop_2:
		add ah,2
		sub di,162
		push di
		mov [es:di],ax
 
	c:
		add di,2
		mov [es:di],ax
		dec bx
		cmp bx,0
		jne c
		pop di
		mov bx,dx
		add bx,2
		mov dx,bx
		loop loop_2
		pop di
		mov ax,0x6720     ;ascii of space is 20 ans 67 is attribute for brown colour
		mov cx,[bp+4]
	d:
		add di,160
		mov [es:di],ax

		dec cx
		cmp cx,0
		jne d
	;restoring previous values 
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp

	;emptying the stack
	ret 6

tree2:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
 
    mov ax, 0xb800  ; accessing video memory
    mov es, ax      ;ponting es towards video memory
    mov al, 80      ; load al with columns per row 
    mul byte [bp+6] ; multiply with y position
    add ax, [bp+8]  ; add x position
    mov cx,[bp+4]   ;moving height of tree in cx
    shl ax, 1        
    mov di,ax 
 
    push di
    mov ax,0xa12a     ; ascii of * is 2a  and attribute green background with white foreground
    
    ;printing left portion of tree
    ; e.g
    ;   *
    ;  *
    ; *
    mov [es:di],ax
    dec cx
    
    t2loop: 
        add di,158
        mov [es:di],ax
        loop t2loop


    ;printing base of the tree
    ;e.g

    ;***
    
    add ah,3
    mov cx,[bp+4]
    shl cx,1
    add cx,1

    add di,158 ; moving to next line
    
    mov [es:di],ax
    dec cx
 
    t2loop2:
        add di,2    
        mov [es:di],ax
        loop t2loop2
 
    mov cx,[bp+4]
    shl cx,1
    sub di, cx   ;going to the middle point of the tree to print trunk
    
    ;now printing trunk
    mov cx,[bp+4]
    mov ax,0x6409     ;ascii of space is 20 ans 67 is attribute for brown colour
    
    t2loop4:
        add di,160
        mov [es:di],ax
        loop t2loop4
 
    pop di     ;popping top point of the tree to go to the position from where the tree has started
    
    ;print right side of tree
    ;e.g
    ;*
    ; *
    ;  *
    mov cx,[bp+4]
    dec cx

    mov ax,0xa82a
 
    t2loop3:
        add di,162
        mov [es:di],ax
        loop t2loop3
 
    ;restoring previous values 
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp

    ;emptying the stack
    ret 6
 
tree3:
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
 
    mov ax, 0xb800  ; accessing video memory
    mov es, ax      ;ponting es towards video memory
    mov al, 80      ; load al with columns per row 
    mul byte [bp+6] ; multiply with y position
    add ax, [bp+8]  ; add x position
    mov cx,[bp+4]   ;moving height of tree in cx
    push cx
    mov bx,cx
    push bx
    shl ax, 1        
    mov di,ax 
    
    mov ax,0xa42a     ; ascii of * is 2a  and attribute green background with white foreground
    mov [es:di],ax
    
    add ah,1
    push di
 
    t3loop:

        add di,158
        push di
    
    t3loop1:
        mov [es:di],ax
        add di,2
        loop t3loop1     

    mov bx,[bp-18]   
    dec bx     ;decrementing height of tree
    mov [bp-18],bx    
    
    mov cx,[bp+4]
    add cx,2
    mov [bp+4],cx
    pop di
    add ah,1
    cmp bx,0
    jne t3loop
 
    mov cx,[bp+4]
    shr cx,1
    add di,cx
    add di,2

    ;now printing trunk
    mov cx,[bp-16]
    
    mov ax,0x6720     ;ascii of space is 20 ans 67 is attribute for brown colour
 
 
hello:
    add di,160
    mov [es:di],ax

    dec cx
    cmp cx,0
    jne hello
 
    add sp,6
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    
    ret 6
display:
	;using interrupt int 10h and service number 0 to access video memory containing 200 rows and 320 columns
	mov ah,0
	mov al,13h
	int 10h

	;cx stores the length of the whole screen
	mov cx,64000

	;pointing es to 0xa000
	mov ax,0xa000
	mov es,ax

	;clearing the screen with red colour
	;mov word[es:di],number----> number can be from 1 - 256 
	loop1000:
	mov word[es:di],40
	add di,1
	loop loop1000


	;now below program is being used to print the shape of our angry bird
	mov di,20000
	mov word[es:di],44
	add di,319

	mov cx,50
	mov si,2
	push si
	push di

	loop2000:
	mov word[es:di],44

	loop3:
	add di,1
	mov word[es:di],44
	dec si
	cmp si,0
	jne loop3
	pop di
	add di,319
	pop si
	add si,2
	push si
	push di
	loop loop2000

	pop di
	pop si
	mov cx,10
	push si
	push di

	loop4000:
	mov word[es:di],44

	loop5:
	add di,1
	mov word[es:di],44
	dec si
	cmp si,0
	jne loop5

	pop di
	add di,321
	pop si
	sub si,2
	push si
	push di
	loop loop4000

	pop di
	pop si

	push si
	push di

	mov cx,8
	loop6:
	mov word[es:di],44

	loop7:
	add di,1
	mov word[es:di],44
	dec si
	cmp si,0
	jne loop7
	pop di
	add di,322
	pop si
	sub si,4
	push si
	push di
	loop loop6

	pop si
	pop di

	mov di,26380
	sub di,5
	push di
	mov cx,10

	mov si,7

	loop8:
	mov word[es:di],0
	add di,322
	loop loop8
	pop di
	add di,320
	push di
	dec si
	mov cx,10
	cmp si,0
	jne loop8

	pop di
	sub di,320
	add di,50
	push di
	mov cx,10
	mov si,7
	loop11:
	mov word[es:di],0
	add di,318
	loop loop11
	pop di
	sub di,320
	push di
	dec si
	mov cx,10
	cmp si,0
	jne loop11

	pop di
	sub di,50
	add di,2240
	add di,2
	add di,640

	mov word[es:di],77
	add di,319
	push di
	mov cx,3
	push cx
	mov si,7

	loop12:
	add di,1
	mov word[es:di],15
	loop loop12
	pop cx
	pop di
	add di,319
	add cx,3
	push di
	push cx
	dec si
	cmp si,0
	jne loop12

	pop cx
	pop di
	add di,2
	push di
	push cx
	mov si,4

	loop13:
	mov word[es:di],15
	add di,1
	loop loop13
	pop cx
	pop di
	add di,321
	sub cx,2
	push di
	push cx
	dec si
	cmp si,0
	jne loop13

	pop cx
	pop di
	push di
	push cx
	mov si,3
	loop14:
	mov word[es:di],15
	add di,1
	loop loop14
	pop cx
	pop di
	add di,322
	sub cx,4
	push di
	push cx
	dec si
	cmp si,0
	jne loop14

	pop cx
	pop di
	add di,25
	add di,2880
	sub di,5120

	mov cx,25
	push di
	push cx
	mov dx,di
	mov si,9

	loop16:
	mov word[es:di],15
	add di,1
	loop loop16
	pop cx
	pop di
	sub di,318
	sub cx,3
	push di
	push cx
	dec si
	cmp si,0
	jne loop16

	pop cx
	pop di

	mov cx,25
	mov di,dx

	push di
	push cx
	mov si,4

	loop18:
	mov word[es:di],15
	add di,1
	loop loop18
	pop cx
	pop di
	add di,321
	sub cx,2
	push di
	push cx
	dec si
	cmp si,0
	jne loop18


	pop cx
	pop di
	push di
	push cx
	mov si,3
	loop19:
	mov word[es:di],15
	add di,1
	loop loop19
	pop cx
	pop di
	add di,322
	sub cx,4
	push di
	push cx
	dec si
	cmp si,0
	jne loop19

	pop cx
	pop di

	mov di,dx
	sub di,5
	mov cx,3
	mov word[es:di],0
	add di,319

	push di
	push cx
	mov si,10
	loop20:

	mov word[es:di],41
	add di,1
	loop loop20

	pop cx
	pop di
	add di,319
	push di
	add cx,2
	push cx
	dec si
	cmp si,0
	jne loop20

	pop cx
	pop di
	push di
	push cx

	loop21:
	mov word[es:di],41
	add di,1
	loop loop21

	pop cx
	pop di
	add di,320
	push di
	push cx
	mov si,5
	loop22:
	mov word[es:di],41
	add di,1
	loop loop22
	pop cx
	pop di
	add di,322
	push di
	sub cx,4
	push cx
	dec si
	cmp si,0
	jne loop22

	pop cx
	pop di

	mov di,dx
	add di,9
	mov cx,5
	push di
	mov si,4

	loop23:
	add di,1
	mov word[es:di],0
	loop loop23
	pop di
	add di,320
	push di
	mov cx,5
	dec si
	cmp si,0
	jne loop23

	pop di

	mov di,dx
	sub di,28
	push di
	mov si,4
	loop24:
	add di,1
	mov word[es:di],0
	loop loop24
	pop di
	add di,320
	push di
	mov cx,5
	dec si
	cmp si,0
	jne loop24

	pop di

	pop di   ;moving a stores value in di


	;below program is being used to print ANGRY BIRDS on screen
	mov di,6480

	mov cx,30
	loop25:
	mov word[es:di],3
	add di,320
	loop loop25

	sub di,4800
	add di,1
	mov cx,20
	loop26:
	mov word[es:di],3
	add di,1
	loop loop26

	mov di,6480
	mov cx,20
	loop27:
	mov word[es:di],3
	add di,1
	loop loop27

	mov cx,30
	loop28:
	mov word[es:di],3
	add di,320
	loop loop28

	sub di,320
	add di,10

	mov cx,30
	loop29:
	mov word[es:di],3
	sub di,320
	loop loop29

	add di,321
	mov cx,30

	loop30:
	mov word[es:di],3
	add di,321
	loop loop30

	mov cx,30
	loop31:
	mov word[es:di],3
	sub di,320
	loop loop31

	add di,10
	mov cx,30
	;add di,320
	push di
	loop32:
	mov word[es:di],3
	add di,320
	loop loop32

	mov cx,20
	loop34:
	mov word[es:di],3
	add di,1
	loop loop34

	mov dx,di
	pop di
	mov cx,20
	loop33:
	mov word[es:di],3
	add di,1
	loop loop33

	mov di,dx
	mov cx,13
	loop35:
	mov word[es:di],3
	sub di,320
	loop loop35
	add di,1
	mov cx,5
	loop36:
	mov word[es:di],3
	sub di,1
	loop loop36


	mov di,dx
	add di,10

	mov cx,30
	loop37:
	mov word[es:di],3
	sub di,320
	loop loop37

	mov cx,20
	loop38:
	mov word[es:di],3
	add di,1
	loop loop38

	mov cx,15
	loop39:
	mov word[es:di],3
	add di,320
	loop loop39

	mov cx,20
	loop40:
	mov word[es:di],3
	sub di,1
	loop loop40

	mov cx,16
	loop41:
	mov word[es:di],3
	add di,321
	loop loop41

	add di,25
	mov cx,15
	loop42:
	mov word[es:di],3
	sub di,320
	loop loop42
	mov cx,15
	push di
	loop43:
	mov word[es:di],3
	sub di,319
	loop loop43
	pop di
	mov cx,15
	loop44:
	mov word[es:di],3
	sub di,321
	loop loop44


	;for printing BIRDS
	mov di,56100

	mov cx,30

	loop45:
	mov word[es:di],3
	sub di,320
	loop loop45

	mov cx,20

	loop46:
	mov word[es:di],3
	add di,1
	loop loop46

	mov cx,30
	loop47:
	mov word[es:di],3
	add di,320
	loop loop47

	mov cx,20

	loop48:
	mov word[es:di],3
	sub di,1
	loop loop48

	sub di,4800

	mov cx,20
	loop49:
	mov word[es:di],3
	add di,1
	loop loop49

	add di,4800
	add di,10

	mov cx,30
	loop50:
	mov word[es:di],3
	sub di,320
	loop loop50

	add di,10
	mov cx,30

	add di,320
	loop51:
	mov word[es:di],3
	add di,320
	loop loop51

	sub di,9600
	mov cx,20
	loop52:
	mov word[es:di],3
	add di,1
	loop loop52

	mov cx,15
	loop53:
	mov word[es:di],3
	add di,320
	loop loop53

	mov cx,20
	loop54:
	mov word[es:di],3
	sub di,1
	loop loop54

	mov cx,15
	loop55:
	mov word[es:di],3
	add di,321
	loop loop55

	add di,15
	mov cx,30
	loop56:
	mov word[es:di],3
	sub di,320
	loop loop56

	mov cx,7
	loop57:
	mov word[es:di],3
	add di,1
	loop loop57

	mov cx,15
	loop58:
	mov word[es:di],3
	add di,321
	loop loop58
	push di
	mov cx,15
	loop59:
	mov word[es:di],3
	add di,319
	loop loop59


	;for printing S
	;cx is the length of the particular line
	mov cx,7
	loop60:
	mov word[es:di],3
	sub di,1
	loop loop60
	pop di
	add di,15
	sub di,4800
	mov cx,8
	push di   ; di is being pushed so that it can be used later

	loop61:
	mov word[es:di],3
	add di,319
	loop loop61

	mov cx,14  
	loop63:
	mov word[es:di],3
	add di,321
	loop loop63

	mov cx,10
	loop64:
	mov word[es:di],3
	add di,319
	loop loop64

	mov cx,8
	loop65:
	mov word[es:di],3
	sub di,321
	loop loop65

	pop di         ;moving the stored value on stack to di
	mov cx,8
	loop62:
	mov word[es:di],3
	add di,321
	loop loop62

	ret

; SANA'S CODE
print1: ;horizontal red
	push bp
	mov bp, sp
	push es
	push ax
	push di
	push bx

	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, [bp + 8] ;starting
	mov si, [bp + 6] ;ending
	mov bx, [bp + 4] ;character

	next1:
		mov word [es:di], bx        
		add di, 2                                               ; move to next screen location
		cmp di, si                                    ; has the whole screen cleared
		jne next1                                           ; if no clear next position
	
	pop bx
	pop di
	pop ax
	pop es
	pop bp
	ret 6

print2:; top and middle brown verticals
	push es
	push ax
	push di
	push cx

	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, dx ;
	mov cx, 3
	next2:
		mov word [es:di], 0x6720   
		mov word [es:di+2], 0x6720   
		sub di, 160
		loop next2

	pop cx
	pop di
	pop ax
	pop es
	ret 2

print3:; end brown verticals
	push es
	push ax
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, dx ;

	next3:
		mov word [es:di], 0x6720
		mov word [es:di+2], 0x6720
		add di, 160   
		cmp di, 4000 
		jle next3                                           ; has the whole screen cleared  

	pop di
	pop ax
	pop es
	ret 2

print4:; first brown blocks
	push es
	push ax
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, dx ;

	next4:
		mov word [es:di], 0x6720
		mov word [es:di-160], 0x6720
		mov word [es:di-320], 0x6720
		mov word [es:di+2], 0x6720
		mov word [es:di+4], 0x6720
		jle next4                                           ; has the whole screen cleared  

	pop di
	pop ax
	pop es
	ret 2

print5: ; second brown blocks
	push es
	push ax
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, dx ;

	next5:
		mov word [es:di], 0x6720
		mov word [es:di+320+2], 0x6720
		mov word [es:di+320+4], 0x6720
		mov word [es:di-160], 0x6720
		mov word [es:di-320], 0x6720
		mov word [es:di-2], 0x6720
		mov word [es:di-4], 0x6720
		jle next5                                           ; has the whole screen cleared  

	pop di
	pop ax
	pop es
	ret 2


print6: ;green jin
	push es
	push ax
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, dx ;

	next6:
		mov word [es:di+2], 0x2020
		mov word [es:di-4], 0x2020
		mov word [es:di], 0x7020
		mov word [es:di-160], 0x2020
		mov word [es:di-8], 0x7020
		mov word [es:di-10], 0x2020
		mov word [es:di+160], 0x2020
		mov word [es:di+160-8], 0x2020
		mov word [es:di+160-2], 0x2020
		mov word [es:di+160-4], 0x2020
		mov word [es:di+160-6], 0x2020

		mov word [es:di+320-2], 0x2020
		mov word [es:di+320-6], 0x2020
		mov word [es:di+320-4], 0x2020

		mov word [es:di-320-4], 0x2020

		mov word [es:di-160-2], 0x2020
		mov word [es:di-160-4], 0x4420
		mov word [es:di-160-6], 0x2020
		mov word [es:di-160-8], 0x2020
		mov word [es:di-320], 0x1820
		mov word [es:di-320+2], 0x1820



	pop di
	pop ax
	pop es
	ret






main:
	call clrscr
    call loading
	mov dx, 4; number of turns
	push dx

	moves:
		call printIntial
		
		mov ah, 0 ; service 0 – get keystroke
		int 0x16 ; call BIOS keyboard service
		cmp al, 97
		jne next4
		call printSimple

		Next1:
			mov ah, 0 ; service 0 – get keystroke
			int 0x16 ; call BIOS keyboard service
			cmp al, 119
			jne Next2
			call printUp

		jmp Next4

		Next2:
			; mov ah, 0 ; service 0 – get keystroke
			; int 0x16 ; call BIOS keyboard service
			cmp al, 100
			jne Next3
			call printParabola
		
		jmp Next4


		Next3:
			; mov ah, 0 ; service 0 – get keystroke
			; int 0x16 ; call BIOS keyboard service
			cmp al, 115
			jne Next4
			call printStraight
		
		jmp Next4
		

		Next4:
			; mov ah, 0 ; service 0 – get keystroke
			; int 0x16 ; call BIOS keyboard service
			cmp al, 120
			jne Next5
			call printDown
		
		
		Next5:
			pop dx
			sub dx, 1
			cmp dx, 0
			push dx
			jne moves
	
	call printIntial
	mov ax, 0x0220  ;attribute +11
	push ax
	mov ax, ending ;string +8
	push ax
	mov ax, 30		;x coordinate +6
	push ax
    mov ax, 9		;y coordinate +4
	push ax
	call printstr
	
	mov ah, 0 ; service 0 – get keystroke
	int 0x16 ; call BIOS keyboard service
	call display
	
	mov ax, 0x4c00
	int 21h