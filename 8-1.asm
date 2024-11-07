;P172实验7
assume cs:code,ds:data,ds:table

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data ends

table segment
    db 21 dup('year summ ne ?? ')
table ends


code segment

start:
    mov ax,data
    mov ds,ax

    mov ax,table
    mov es,ax

    ;复制年份及收入
    mov bx,0
    mov bp,0
    mov cx,21
    s1:     
        push cx
        mov cx,2
        mov si,0
        s2:
            ;年份
            mov ax,[bx][si]
            mov es:[bp][si],ax
            ;收入
            mov ax,84[bx][si]
            mov es:[bp].5[si],ax

            add si,2
            loop s2
        pop cx
        add bx,4
        add bp,16
        loop s1
    
    ;复制雇员数
    mov bx,0
    mov bp,0
    mov cx,21
    u:
        mov ax,168[bx]
        mov es:[bp].0ah,ax
        add bx,2
        add bp,16
        loop u

    ;计算人均收入
    mov cx,21
    mov bp,0
    v:
        mov ax,es:[bp].5
        mov dx,es:[bp].7
        div word ptr es:[bp].0ah
        mov es:[bp].0dh,ax
        add bp,16
        loop v

    mov ax,4c00h
    int 21h

code ends

end start