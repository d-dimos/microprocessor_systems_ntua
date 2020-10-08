; Microcomputer Systems - Flow Y [6th Semester]
; Nafsika Abatzi - 031 17 198 - nafsika.abatzi@gmail.com
; Dimitris Dimos - 031 17 165 - dimitris.dimos647@gmail.com
; 5th Group of Exercises
; 4th Exercise    


INCLUDE MACROS.ASM
    
    

DATA_SEG    SEGMENT
    SYMBOLS DB 16 DUP(?)
    NEWLINE DB 0AH,0DH,'$'
    ENTER   DB "Enter was pressed. Program now exits...",0AH,0DH,'$'          
DATA_SEG    ENDS



CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
    
    
    
MAIN PROC FAR  
    
    MOV AX,DATA_SEG
    MOV DS,AX
  
  
AGAIN:    
    MOV CX,16            ; initialize counter
    MOV DI,0             ; initialize array index
INPUT:
    CALL GET_CHAR        ; get acceptable character
    CMP AL,0DH           ; if it's enter then exit
    JE END_OF_PROG
    MOV [SYMBOLS+DI],AL
    INC DI
    LOOP INPUT
      
      
      
    MOV CX,16
    MOV DI,0
OUTPUT:
    PRINT [SYMBOLS+DI]   ; print all characters
    INC DI
    LOOP OUTPUT
      
        
    PRNT_STR NEWLINE     ; new line 
      
      
    MOV CX,16
    MOV DI,0
PRINT_NUMS:
    MOV AL,[SYMBOLS+DI]
    CMP AL,30H            ; we check if it is an ASCII coded digit
    JL  NOT_A_NUMBER
    CMP AL,39H
    JG NOT_A_NUMBER
    PRINT AL              ; print only the digits
    
NOT_A_NUMBER:
    INC DI
    LOOP PRINT_NUMS 
    
    PRINT '-'
    
    MOV CX,16
    MOV DI,0
PRINT_LETTERS:
    MOV AL,[SYMBOLS+DI]
    CMP AL,'A'            ; we check if it is an ASCII coded capital letter
    JL  NOT_A_LETTER
    CMP AL,'Z'
    JG NOT_A_LETTER
    ADD AL,20H            ; make it a non-capital letter
    PRINT AL              ; print only the letters as non capitals
    
NOT_A_LETTER:
    INC DI
    LOOP PRINT_LETTERS
      
        
    PRNT_STR NEWLINE     ; new line    
    JMP AGAIN
      
END_OF_PROG:
    PRNT_STR ENTER
    EXIT
MAIN ENDP 




; --------- AUXILIARY ROUTINES ----------- 

; READ A DIGIT OR CHARACTER BETWEEN 'A' AND 'Z' --> AL
GET_CHAR PROC NEAR
IGNORE:    
    READ
    CMP AL,0DH
    JE INPUT_OK
    CMP AL,30H        ; if input < 30H ('0') then ignore it
    JL IGNORE
    CMP AL,39H        ; if input > 39H ('9') then it may be a capital letter
    JG MAYBE_LETTER
    JMP INPUT_OK
 
MAYBE_LETTER:
    CMP AL,'A'        ; if input < 'A' then ignore it
    JL IGNORE         
    CMP AL,'Z'        ; if input > 'Z' then ignore it
    JG IGNORE
    
INPUT_OK:          
    RET  
GET_CHAR ENDP



; PRINT THE NUMBER IN DL
PRINT_HEX PROC NEAR
    
    PUSH AX

    MOV AL,DL
    SAR AL,4
    AND AL,0FH   ; isolate 4 MSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE NEX
    ADD AL,07H   ; if it's a letter, fix ASCII
NEX:
    CMP AL,'0'
    JE DONT_PRINT_IT 
    PRINT AL     ; print the first hex digit

DONT_PRINT_IT:    
    MOV AL,DL
    AND AL,0FH   ; isolate 4 LSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK
    ADD AL,07H   ; if it's a letter, fix ASCII
OK:
    PRINT AL     ; print the second hex digit
    
    POP AX
    RET
PRINT_HEX ENDP
 
 

CODE_SEG    ENDS
    END MAIN