assume cs:code,ds:data

data segment
    db 'Welcome to masm!', 0
data ends

code segment

    main:

        ; ;测试show_str
        ; mov ax,data
        ; mov ds,ax

        ; mov dh,12
        ; mov dl,32
        ; mov cl,7
        ; mov si,0
        ; call show_str

        ; ; 测试divdw
        ; mov ax,4240h
        ; mov dx,000fh
        ; mov cx,0ah
        ; call divdw

        ; mov ax,4c00h
        ; int 21h




    ; show_str
    ; 功能：在指定位置，用指定颜色，显示一个用0结束的字符串
    ; 参数：(dh)=行号(0~24), (dl)=列号(0~79), (cl)=颜色, ds:si指向字符串首地址
    ; 返回：无
    ;   7  6   5   4   3   2   1   0
    ;  BL  R   G   B   I   R   G   B
    ;  闪烁     背景   高亮    前景

    show_str:
        ; 将用到的寄存器压入栈中
        push ax
        push es
        push si     ; 虽然si用作传参，但show_str中也用到了它，也将它压入栈中
        push di
        push bx

        ; 设置显存位置
        mov ax,0b800h
        mov es,ax

        ; 计算行的首地址，行号X160，结果存放在ax中
        ; 用bx来表示行偏移量
        mov al,dh
        mov dh,160
        mul dh
        mov bx,ax

        ; di来表示列偏移量，列数乘2
        mov dh,0
        mov di,dx
        add di,di

        ; 用ax来保存每一个字符，ah为颜色，al为字符
        mov ah,cl
        mov cx,0
        s:
            mov cl,[si]
            jcxz return
            mov al,[si]
            mov es:[bx+di],ax
            inc si
            add di,2
            jmp short s

        return:
            pop bx
            pop di
            pop si
            pop es
            pop ax

            ret


    ; divdw
    ; 功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型
    ; 参数：(ax) = dword型数据的低16位
    ;      (dx) = dword型数据的高16位
    ;      (cx) = 除数
    ; 返回：(dx) = 结果的高16位，(ax) = 结果的低16位
    ;       (cx) = 余数
    ;
    ; 例：计算 1000000/10(0F4240H/0AH)
    ;
    ; 公式：X ÷ N = H / N * 10000H + (H % N * 10000H + L) ÷ N
    ;   X:被除数    N:除数    H:X的高16位    L:X的低16位

    divdw:
        push si
        push di

        mov si,ax ; 暂存低位
        mov di,dx ; 暂存高位
        
        mov ax,di
        mov dx,0
        div cx

        mov di,ax ; 结果的高16位
        mov ax,si 
        div cx

        mov dx,di

        pop di
        pop si

        ret

code ends

end main