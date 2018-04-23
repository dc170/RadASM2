com_seg segment byte public            ; define the ONLY segment

        assume cs:com_seg, ds:com_seg  ; both code & data in same segment.
        org 100h                       ; go to start adress in memory.

start:
        mov ah, 40h                    ; the DOS function number.
        mov bx, 1                      ; the screen handle.
        mov cx, 11                     ; the length of the text to display.
        mov dx, offset Greeting        ; the address of the text.
        int 21h                        ; get DOS to execute the function.

        mov ax, 4Ch                    ; the TERMINATE process function.
        int 21h                        ; call DOS again to EXIT.

Greeting db "Hello World",13,10        ; specify the text as byte data.

com_seg ends                           ; define the end of the segment.

        end start