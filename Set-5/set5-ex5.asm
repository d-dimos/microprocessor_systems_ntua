; Microcomputer Systems - Flow Y [6th Semester]
; Nafsika Abatzi - 031 17 198 - nafsika.abatzi@gmail.com
; Dimitris Dimos - 031 17 165 - dimitris.dimos647@gmail.com
; 5th Group of Exercises
; 5th Exercise    
     
         
     
INCLUDE MACROS.ASM
   
   
   
PRINT_DEC MACRO
    PUSH AX
    
    ADD DL, 30H
    MOV AH,2
    INT 21H
    
    POP AX
ENDM    
    
   
   
DATA_SEG    SEGMENT
    START_MSG DB "START (Y, N):",0AH,0DH,'$'
    END_MSG   DB "Program will now end...",0AH,0DH,'$'
    ERROR_MSG DB "ERROR",0AH,0DH,'$'
    FIRST     DB ?
    SECOND    DB ?
    THIRD     DB ?
    TEMP      DB "The temperature is: ",'$'
    NEWLINE   DB 0AH,0DH,'$'             
DATA_SEG    ENDS

 
 

CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
    
MAIN PROC FAR  
    
    ; define DATA SEGMENT
    MOV AX,DATA_SEG
    MOV DS,AX
    
    PRNT_STR START_MSG   ; ask user what he wants 
    CALL YES_OR_NO       ; put answer in AL
         
          
    ; act accordingly (N===>end program)
    CMP AL,'N'
    JE END_ALL
       
REPEAT:       
    ; we get the 3-HEX-digit input    
    CALL GET_INPUT
    CMP AL,'N'
    JE END_ALL
    MOV FIRST,AL
    
    CALL GET_INPUT
    CMP AL,'N'
    JE END_ALL
    MOV SECOND,AL
    
    CALL GET_INPUT
    CMP AL,'N'
    JE END_ALL
    MOV THIRD,AL
    
    
    ; put input in AX
    CALL TIDY_INPUT
    
    ; calculate A/D Converter output Volts (AX)
    MOV BX,10
    MUL BX
    MOV BX,20475
    DIV BX
    MOV BX,AX           ; Volts = (INPUT * 10 / 20475)
                        ; BX = quotient
                        ; DX = remainder
                        
    ; check for error
    CMP BX,2
    JGE ERROR_PART      ; if quotient >= 2, then we have            
                        ; a temperature over 999.9 degrees ===> ERROR
    
                      
    
    ; which region are we in?
    CALL TIDY_INPUT     ; AX <=== input
    CMP AX,2047         ;      0 < (A|D) < 2047.5  ===> 0<temp<500 deg
    JLE FIRST_REGION
    CMP AX,3685         ; 2047.5 < (A|D) < 3685.5  ===> 500<temp<700 deg
    JLE SECOND_REGION
                        ; otherwise third class    ===> 700<temp<1000 deg
                  
                 
                        
THIRD_REGION:     ; T = (200*input)/273 - 2000
    MOV CX,2000
    MUL CX        ; DX:AX = 2000*input
    MOV CX,273
    DIV CX        ; AX = (2000*input)/273
    MOV CX,20000
    SUB AX,CX     ; AX = (2000*input)/273 - 20000
                  ; result is multiplied by 10
                  ; to keep last digit as the decimal afterwards
    CALL PRINT_TEMPERATURE
    JMP REPEAT   
           
           
    
FIRST_REGION:     ; T = (200*input)/819
    MOV CX,2000   ; mul by 2000 (to keep last digit as the decimal afterwards)
    MUL CX
    MOV CX,819
    DIV CX        ; result in AX
    CALL PRINT_TEMPERATURE
    JMP REPEAT    
    
    
    
SECOND_REGION:    ; T = 250 + (100*input)/819  
    MOV CX,1000
    MUL CX        ; DX:AX = input*1000
    MOV CX,819    
    DIV CX        ; AX = (1000*input)/819
    MOV CX,2500
    ADD AX,CX     ; AX = 2500 + (1000*input)/819
                  ; result is multiplied by 10
                  ; to keep last digit as the decimal afterwards
    CALL PRINT_TEMPERATURE
    JMP REPEAT
     

    
    ; if temperature exceeds 999.9 degrees
    ERROR_PART:
    PRNT_STR  ERROR_MSG
    JMP REPEAT    
    ; ------------------------------
    
    
    
END_ALL:
    PRNT_STR END_MSG
    EXIT
MAIN ENDP 



; --------- AUXILIARY ROUTINES ----------- 


; routine get a Y or a N (ignore all there characters)
YES_OR_NO PROC NEAR
IGNORE:    
    READ
    CMP AL,'Y'
    JE GOT_IT
    CMP AL,'N'
    JE GOT_IT
    JMP IGNORE
GOT_IT:
    RET
YES_OR_NO   ENDP 




; routine to input a hex number
GET_INPUT PROC NEAR
IGNORE_:    
    READ
    CMP AL,30H        ; if input < 30H ('0') then ignore it
    JL IGNORE_
    CMP AL,39H        ; if input > 39H ('9') then it may be a hex letter
    JG CHECK_LETTER
    SUB AL,30H        ; otherwise make it a hex number
    JMP GOT_INPUT
 
CHECK_LETTER:
    CMP AL,'N'        ; if input = 'N', then return to quit
    JE GOT_INPUT
    CMP AL,'A'        ; if input < 'A' then ignore it
    JL IGNORE_         
    CMP AL,'F'        ; if input > 'F' then ignore it
    JG IGNORE_
    SUB AL,37H        ; otherwise make it a hex number
    
GOT_INPUT:
    RET
GET_INPUT ENDP


   
   
; routine to put input in AX   
TIDY_INPUT PROC NEAR
    PUSH BX
    
    MOV AH,FIRST        ; AH = 0000XXXX
    
    MOV AL,SECOND       ; AL = 0000YYYY
    SAL AL,4
    AND AL,0F0H         ; AL = YYYY0000
    
    MOV BL,THIRD
    AND BL,0FH          ; BL = 0000ZZZZ
    OR  AL,BL           ; AL = YYYYZZZZ
                        ; AX = 0000XXXX YYYYZZZZ (FULL NUMBER)
    POP BX
    RET    
TIDY_INPUT ENDP


   
   
; routine to print temperature (it's in AX)   
PRINT_TEMPERATURE PROC NEAR
    PUSH AX
    PRNT_STR TEMP
    POP AX
    
    MOV CX,0        ; initialize counter
SPLIT:    
    MOV DX,0
    MOV BX,10       
    DIV BX          ; take the last decimal digit
    PUSH DX         ; save it 
    INC CX
    CMP AX,0
    JNE SPLIT       ; continue, till we split the whole number
    
    DEC CX
    CMP CX,0
    JNE PRNT_
    PRINT '0'
    JMP ONLY_DECIMAL
    
PRNT_:    
    POP DX          ; print the digits we saved in reverse
    PRINT_DEC
    LOOP PRNT_

ONLY_DECIMAL:    
    PRINT '.'       ; the last digit is the decimal
    POP DX
    PRINT_DEC
    
    PRINT ' '
    PRINT 0F8H
    PRINT 'C'
    PRNT_STR NEWLINE
    
    RET     
PRINT_TEMPERATURE ENDP


   
CODE_SEG    ENDS
    END MAIN