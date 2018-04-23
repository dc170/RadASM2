; EVERY DAY MACROS :) #####################################################

      ;=============
      ; Local macros
      ;=============

      szText MACRO Name, Text:VARARG
        LOCAL lbl
          jmp lbl
            Name db Text,0
          lbl:
        ENDM

      m2m MACRO M1, M2
        push M2
        pop  M1
      ENDM

      return MACRO arg
        mov eax, arg
        ret
      ENDM


    ; **********************************************
    ; The original concept for the following macro *
    ; was designed by "huh" from New Zealand.      *
    ; **********************************************

    ; ---------------------
    ; literal string MACRO
    ; ---------------------
      literal MACRO quoted_text:VARARG
        LOCAL local_text
        .data
          local_text db quoted_text,0
        align 4
        .code
        EXITM <local_text>
      ENDM
    ; --------------------------------
    ; string address in INVOKE format
    ; --------------------------------
      SADD MACRO quoted_text:VARARG
        EXITM <ADDR literal(quoted_text)>
      ENDM
    ; --------------------------------
    ; string OFFSET for manual coding
    ; --------------------------------
      CTXT MACRO quoted_text:VARARG
        EXITM <offset literal(quoted_text)>
      ENDM

    ; -----------------------------------------------------
    ; string address embedded directly in the code section
    ; -----------------------------------------------------
      CADD MACRO quoted_text:VARARG
        LOCAL vname,lbl
          jmp lbl
            vname db quoted_text,0
          align 4
          lbl:
        EXITM <ADDR vname>
      ENDM

    ; --------------------------------
    ; string address in INVOKE format
    ; --------------------------------
      StrAddr MACRO quoted_text:VARARG
        EXITM <ADDR literal(quoted_text)>
      ENDM

     MOVmw MACRO Var1, Var2
      lea     esi, Var2
      lea     edx, Var1
      REPEAT     2
       mov     al, [esi]
       mov     [edx], al
       inc     esi
       inc     edx
      ENDM
     ENDM
     