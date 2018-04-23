title add3pos.asm

        .model small
        .stack 100h
        .code


_start:
        mov cx, 0ah ;Move value 10 in the al register


again:
        mov ah, 8h ;Accept input
        int 21h    ; do it 


        add al, 3h ;Add 3 to the value in the al register
        mov dl, al ;move the al value register to the dl register
        mov ah, 2h ; 
        int 21h ;Do it

        sub cx, 1 ;Subtract 1 from the value in the cx register
        jz exit ;jump to exit when =  0
        jmp again ;otherwise bak to again


exit:

        mov ax, 4c00h
        int 21h

end _start
