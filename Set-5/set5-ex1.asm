; Microcomputer Systems - Flow Y [6th Semester]
; Nafsika Abatzi - 031 17 198 - nafsika.abatzi@gmail.com
; Dimitris Dimos - 031 17 165 - dimitris.dimos647@gmail.com
; 5rd Group of Exercises
; 1st Exercise
     


; ----------------------- MACROS---------------------------     
; PRINT CHAR 
PRINT MACRO CHAR
    PUSH AX
    PUSH DX 
    
    MOV DL,CHAR
    MOV AH,2
    INT 21H
    
    POP DX
    POP AX
ENDM PRINT    
      
      
      
; EXIT TO DOS    
EXIT MACRO
    MOV AX,4C00H
    INT 21H
ENDM EXIT
  


; PRINT STRING  
PRNT_STR MACRO STRING
    MOV DX,OFFSET STRING
    MOV AH,9
    INT 21H
ENDM PRNT_STR 


                     
; READ ASCII CODED DIGIT                     
READ MACRO
    MOV AH,8
    INT 21H
ENDM READ    
; -----------------------------------------------------------
      
      
      
DATA_SEG    SEGMENT
    NEW_LINE  DB 0AH,0DH,'$'
    QUIT_LINE DB "Time to quit...",0AH,0DH,'$'
DATA_SEG    ENDS


                
CODE_SEG    SEGMENT    
    ASSUME CS:CODE_SEG, DS:DATA_SEG
          
MAIN PROC FAR        ; we consider the first digit to be the MS 4-bit 
   
   MOV AX,DATA_SEG   ; important segment arrangements
   MOV DS,AX
   
   
   CALL HEX_KEYB     ; get hex digit
   CMP AL,'Q'        ; if it's 'Q' end it
   JE QUIT
   MOV DH,AL         ; save it in DH
   CALL HEX_KEYB     ; get then next hex digit
   CMP AL,'Q'        ; check for 'Q'
   JE QUIT
   MOV DL,AL         ; save it in DL
   
   CLC               ; clear carry, ready for left-slide
   SHL DH,4          ; slide DH by 4 and the OR it with DL
   OR DL,DH
   
   
   ; from now on we print the different forms of DL
   PUSH DX
      
   ; print the hex form of input number   
   SAR DH,4          ; manipulate the MS bits
   AND DH,0FH   
   ADD DH,30H        ; ASCII code them
   CMP DH,39H        
   JLE PRINT_H
   ADD DH,07H        ; if it's a letter, then correct the ASCII by adding 07H
PRINT_H:
   PRINT DH          ; and print their hex form
   
   
   AND DL,0FH        ; isolate 4 LS bits
   ADD DL,30H        ; ASCII code them
   CMP DL,39H        
   JLE PRINT_L
   ADD DL,07H        ; if it's a letter, then correct the ASCII by adding 07H
PRINT_L:
   PRINT DL          ; print their hex form  
   
   PRINT 'h'
   
   
   POP DX            ; restore DX
   PRINT '='
   CALL PRINT_DEC
   PRINT '='
   CALL PRINT_OCT
   PRINT '='
   CALL PRINT_BIN
   PRNT_STR NEW_LINE
   JMP MAIN
   
   
QUIT: 
    PRNT_STR QUIT_LINE   
    EXIT                          
MAIN ENDP
     
     

; ----------------------- ROUTINES ---------------------------      
     
; PRINT DECIMAL FORM OF DL
PRINT_DEC PROC NEAR     ; input: DL
                        ; prints its decimal form
    
    PUSH AX     ; save registers
    PUSH CX
    PUSH DX    
        
    MOV CX,1    ; initialize digit counter
    
    MOV AL,DL
    MOV DL,10 
    
LD: 
    MOV AH,0    ; divide number by 10
    DIV DL
    PUSH AX     ; save quotient
    CMP AL,0    ; if quot = 0, start printing
    JE PRNT_10
    INC CX      ; increase counter (aka digits number)
    JMP LD      ; repeat dividing quotients by 10

PRNT_10:
    POP AX      ; get digit
    MOV AL,AH
    MOV AH,0
    ADD AX,'0'  ; ASCII coded
    PRINT AL    ; print
    LOOP PRNT_10   ; repeat till no more digits 
    
    PRINT 'd'    
    
    POP DX                         
    POP CX      ; restore registers
    POP AX
    RET  
PRINT_DEC ENDP  
 
  
  

; PRINT OCTAL FORM OF DL
PRINT_OCT PROC NEAR     ; input: DL
                        ; prints its octal form
    
    PUSH AX     ; save registers
    PUSH CX
    PUSH DX
        
        
    MOV CX,1    ; initialize digit counter
    
    MOV AL,DL
    MOV DL,8 
    
LO: 
    MOV AH,0    ; divide number by 8
    DIV DL
    PUSH AX     ; save quotient
    CMP AL,0    ; if quot = 0, start printing
    JE PRNT_8
    INC CX      ; increase counter (aka digits number)
    JMP LO      ; repeat dividing quotients by 8

PRNT_8:
    POP AX      ; get digit
    MOV AL,AH
    MOV AH,0
    ADD AX,'0'  ; ASCII coded
    PRINT AL    ; print
    LOOP PRNT_8   ; repeat till no more digits
    
    PRINT 'o'     
    
    POP DX      ; restore registers                   
    POP CX
    POP AX
    RET  
PRINT_OCT ENDP
 

   
   
; PRINT BINARY FORM OF DL
PRINT_BIN PROC NEAR     ; input: DL
                        ; prints its binary form
    
    PUSH AX     ; save registers
    PUSH CX
    PUSH DX
        
        
    MOV CX,1    ; initialize digit counter
    
    MOV AL,DL
    MOV DL,2 
    
LB: 
    MOV AH,0    ; divide number by 2
    DIV DL
    PUSH AX     ; save quotient
    CMP AL,0    ; if quot = 0, start printing
    JE PRNT_2
    INC CX      ; increase counter (aka digits number)
    JMP LB      ; repeat dividing quotients by 2

PRNT_2:
    POP AX      ; get digit
    MOV AL,AH
    MOV AH,0
    ADD AX,'0'  ; ASCII coded
    PRINT AL    ; print
    LOOP PRNT_2   ; repeat till no more digits
    
    PRINT 'b'     
    
    POP DX      ; restore registers                   
    POP CX      
    POP AX
    RET  
PRINT_BIN ENDP
 
   
   

; READ A HEX DIGIT (ONLY HEX DIGITS ARE ACCEPTED) --> AL
HEX_KEYB PROC NEAR


IGNORE:    
    READ
    CMP AL,30H        ; if input < 30H ('0') then ignore it
    JL IGNORE
    CMP AL,39H        ; if input > 39H ('9') then it may be a hex letter
    JG CHECK_LETTER
    SUB AL,30H        ; otherwise make it a hex number
    JMP INPUT_OK
 
CHECK_LETTER:
    CMP AL,'Q'        ; if input = 'Q', then return to quit
    JE INPUT_OK
    CMP AL,'A'        ; if input < 'A' then ignore it
    JL IGNORE         
    CMP AL,'F'        ; if input > 'F' then ignore it
    JG IGNORE
    SUB AL,37H        ; otherwise make it a hex number
    
INPUT_OK:          
    RET  
HEX_KEYB ENDP

; --------------------------------------------------------------

CODE_SEG    ENDS
        END MAIN