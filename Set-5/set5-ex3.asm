; Microcomputer Systems - Flow Y [6th Semester]
; Nafsika Abatzi - 031 17 198 - nafsika.abatzi@gmail.com
; Dimitris Dimos - 031 17 165 - dimitris.dimos647@gmail.com
; 5th Group of Exercises
; 3st Exercise    


INCLUDE MACROS.ASM
    
    

DATA_SEG    SEGMENT
    FIRST   DB ?
    SECOND  DB ?
    NEWLINE DB 0AH,0DH,'$'      
DATA_SEG    ENDS



CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
   
    
    
MAIN PROC FAR  
    
    MOV AX,DATA_SEG
    MOV DS,AX
    
    MOV BX,0         ; initialization
    CALL HEX_KEYB
    MOV BH,AL
    SAL BH,4         
    CALL HEX_KEYB
    MOV BL,AL
    OR BL,BH
    MOV FIRST,BL     ; first number in FIRST
    
  
    CALL HEX_KEYB
    MOV BH,AL
    SAL BH,4
    CALL HEX_KEYB
    MOV BL,AL
    OR BL,BH
    MOV SECOND,BL    ; second number in SECOND
     
    ; print in the form: x=... y=... 
    PRINT 'x'
    PRINT '='
    
    MOV DL,FIRST 
    CALL PRINT_HEX       ; print its hex form
    
    PRINT ' '
    PRINT 'y'
    PRINT '='
    
    MOV DL,SECOND
    CALL PRINT_HEX       ; print its hex form
    
    PRNT_STR NEWLINE
    

    
    ; calculate sum and difference    
    MOV AH,0
    MOV BH,0
    MOV AL,FIRST
    MOV BL,SECOND
    ADD AX,BX         ; add them 
    
    
    PRINT 'x'
    PRINT '+'
    PRINT 'y'
    PRINT '='
    
    MOV DX,AX
    CALL PRINT_DEC_2     ; print the sum from DX
    PRINT ' '
    PRINT 'x'
    PRINT '-'
    PRINT 'y'
    PRINT '='
    
    MOV AH,0
    MOV BH,0
    MOV AL,FIRST
    MOV BL,SECOND
    
    CMP AL,BL
    JAE NO_MINUS      ; check for the sign. If FIRST < SECOND then 
    PRINT '-'         ; we do SECOND-FIRST
    SUB BX,AX         ; and put a '-'
    MOV DL,BL
    JMP OK_DIF
NO_MINUS:    
    SUB AX,BX         ; sub them
    MOV DL,AL
OK_DIF:      
     
    CALL PRINT_DEC    ; print the difference from DL
      

    EXIT
MAIN ENDP 




; --------- AUXILIARY ROUTINES -----------
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
    CMP AL,'A'        ; if input < 'A' then ignore it
    JL IGNORE         
    CMP AL,'F'        ; if input > 'F' then ignore it
    JG IGNORE
    SUB AL,37H        ; otherwise make it a hex number
    
INPUT_OK:          
    RET  
HEX_KEYB ENDP



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
    PUSH AX     ; save
    CMP AL,0    ; if quot = 0, start printing
    JE PRNT_10
    INC CX      ; increase counter (aka digits number)
    JMP LD      ; repeat dividing quotients by 10

PRNT_10:
    POP AX      ; get digit
    MOV AL,AH
    MOV AH,0
    ADD AX,'0'     ; ASCII coded
    PRINT AL       ; print
    LOOP PRNT_10   ; repeat till no more digits 
            
    
    POP DX                         
    POP CX      ; restore registers
    POP AX
    RET  
PRINT_DEC ENDP



; PRINT DECIMAL FORM OF DX
PRINT_DEC_2 PROC NEAR   ; input: DX
                        ; prints its decimal form
    
    PUSH AX     ; save registers
    PUSH BX
    PUSH CX
    PUSH DX    
        
    MOV CX,1    ; initialize digit counter
    
    MOV AX,DX
    MOV BX,10 
    
LD_2:
    MOV DX,0     
    DIV BX
    PUSH DX       ; save
    CMP AX,0      ; if quot = 0, start printing
    JE PRNT_10_2
    INC CX        ; increase counter (aka digits number)
    JMP LD_2      ; repeat dividing quotients by 10

PRNT_10_2:
    POP DX        ; get digit
    MOV AL,DL
    MOV AH,0
    ADD AX,'0'       ; ASCII coded
    PRINT AL         ; print
    LOOP PRNT_10_2   ; repeat till no more digits 
        
    
    POP DX                         
    POP CX      ; restore registers
    POP BX
    POP AX
    RET  
PRINT_DEC_2 ENDP
    


CODE_SEG    ENDS
    END MAIN