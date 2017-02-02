; Equation Solver
; by ShahroOz 

; This program uses gauss jordan method.

;HELP
;   set the var to the number of variables
;   and set the array to matrix of 
;   equations.


data segment
    l dw ?
    temp1 dw ?
    temp2 dw ?
    temp3 dw ?
    numstr dw '$$$$$'
    manfi dw -1;
    var dw 3
    array dw 2,3,-1,0,1,-1,3,6,4,-2,-1,9
    ;array dw 1,2,3,13,1,1,1,7,-1,-2,-1,-11
data ends

stack segment
    mystack db 100 dup(?)
stack ends

myprog segment
    main proc far
        assume cs: myprog, ds: data, ss: stack
        mov ax, data
        mov ds, ax
        lea sp, mystack+100
        
        lea si, array
        mov bp, var
        call gos_jor
        
        mov bp, var
        lea si, array
        call print

        hlt
    main endp 
    
    print proc near
        
        mov cx, 0  
          
 loopq: cmp cx, bp
        jge outq
        mov ah, 2
        mov dx, 'X'
        int 21h
        
        inc cx
        push cx
        push ax
        push si
        mov ax,cx
        lea si, numstr
        call s2n
        pop si
        pop ax
        pop cx
        dec cx
        
        mov ah, 2
        mov dx, '='
        int 21h        
        
        mov ah, 2
        mov dx, ' '
        int 21h
        
               
        push ax
        push dx
        push si
        mov ax, cx
        mov dx, bp
        mov si, si
        call aij
        mov ax, [si]
        mov l, ax
        pop si
        pop dx
        pop ax
        
        cmp l, 0
        jge ok1
        mov ah, 2
        mov dx, '-'
        int 21h
        push ax
        push dx
        mov ax, l
        xor dx,dx
        imul manfi
        mov l, ax
        pop dx
        pop ax
   ok1: push cx
        push si
        mov ax,l
        lea si, numstr
        call s2n
        pop si
        pop cx
        
        mov ah, 2
        mov dx, '/'
        int 21h
        
         
        push ax
        push dx
        push si
        mov ax, cx
        mov dx, cx
        mov si, si
        call aij
        mov ax, [si]
        mov l, ax
        pop si
        pop dx
        pop ax
        
        cmp l, 0
        jge ok2
        mov ah, 2
        mov dx, '-'
        int 21h
        push ax
        push dx
        mov ax, l
        xor dx,dx 
        imul manfi
        mov l, ax
        pop dx
        pop ax
   ok2: push cx
        push si
        mov ax,l
        lea si, numstr
        call s2n
        pop si
        pop cx
         
        push ax
        push dx
        mov dx,13
        mov ah,2
        int 21h  
        mov dx,10
        mov ah,2
        int 21h
        int 21h
        pop dx
        pop ax       
        
        inc cx       
        jmp loopq
         
  outq: 
        
    print endp
    
    aij proc near; si as arr, ax as i, dx as j
        
        add si, dx
        add si, dx
        xor dx, dx
        inc bp
        mul bp
        add si, ax
        add si, ax
        dec bp
        
        ret
        
    aij endp
        
    gos_jor proc near; si as arr, bp as var
        
        push dx
        push bx
        push di
        push si
        
        xor dx, dx
 loop1: cmp dx, bp
        jge out1
        xor bx, bx
 loop2: cmp bx,var
        jg out2
        
        push ax
        push dx
        push si
        mov ax, bx
        mov dx, dx
        mov si, si
        call aij
        mov ax, [si]
        mov l, ax
        pop si
        pop dx
        pop ax
        
        xor di, di
 loop3: cmp di, bp
        jg out3
        cmp bx, dx
        je out4
        push ax
        push dx
        push si
        mov ax, dx
        mov dx, dx
        mov si, si
        call aij
        mov ax, [si]
        mov temp1, ax
        pop si
        pop dx
        pop ax
        
        push ax
        push dx
        push si
        mov ax, bx
        mov dx, di
        mov si, si
        call aij
        mov ax, [si]
        pop si
        xor dx, dx
        imul temp1
        mov temp2, ax
        pop dx
        pop ax
        
        push ax
        push dx
        push si
        mov ax, dx
        mov dx, di
        mov si, si
        call aij
        mov ax, [si]
        pop si
        xor dx, dx
        imul l
        mov temp3, ax
        pop dx
        pop ax
        
        push ax
        mov ax, temp2
        sub ax, temp3
        mov temp3, ax
        push ax
        push dx
        push si
        mov ax, bx
        mov dx, di
        mov si, si
        call aij
        mov ax, temp3
        mov [si], ax
        pop si
        pop dx
        pop ax
        pop ax
        
        
  out4: inc di
        jmp loop3     
        
  out3: inc bx
        jmp loop2     
        
  out2: inc dx
        jmp loop1
        
  out1: pop si
        pop di
        pop bx
        pop dx
        
        ret    
    
    gos_jor endp
    
    
    s2n proc near
        call dollars 
        mov  bx, 10  
        mov  cx, 0   
loop11:       
        mov  dx, 0   
        div  bx      
        push dx      
        inc  cx      
        cmp  ax, 0   
        jne  loop11   

loop21:  
        pop  dx        
        add  dl, 48  
        mov  [ si ], dl
        inc  si
        loop loop21
  
        mov ah, 9
        mov dx, offset numstr
        int 21h   

        ret
    s2n endp    
    
    dollars proc near                 
        mov cx, 5
        mov di, offset numstr
loopd:  mov bl, '$'
        mov [ di ], bl
        inc di
        loop loopd

        ret
    dollars endp
    
        
myprog ends
    end main
