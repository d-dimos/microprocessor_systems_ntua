; Microcomputer Systems - Flow Y [6th Semester]
; Nafsika Abatzi - 031 17 198 - nafsika.abatzi@gmail.com
; Dimitris Dimos - 031 17 165 - dimitris.dimos647@gmail.com
; 5th Group of Exercises
; 2st Exercise    


INCLUDE MACROS.ASM
    
    

DATA_SEG    SEGMENT
    TABLE   DB 256 DUP(?)
    AVERAGE DB ?
    MIN     DB ?
    MAX     DB ?
    NEWLINE DB 0AH,0DH,'$' 
DATA_SEG    ENDS



CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
   
    
    
MAIN PROC FAR
    
    MOV AX,DATA_SEG  ; important initialization
    MOV DS,AX
    
        
    ; in this part data is stored    
    MOV AL,254   ; initialize counter
    MOV DI,0     ; initialize index
STORE:
    MOV [TABLE+DI],AL  
    DEC AL
    INC DI
    CMP DI,256
    JNE STORE   

     
    ; in this part average is calculated 
    MOV DX,0    ; initialize counter to store the sum       
    MOV DI,0    ; initialize index to 0
    MOV AX,0    ; temporary register
SUM:
    MOV AL,[TABLE+DI]
    ADD DX,AX
CONT:
    ADD DI,2
    CMP DI,256
    JNE SUM    
END_COUNT:      ; sum of all evens in DX
    MOV AX,DX
    MOV DX,0
    MOV CX,128
    DIV CX      ; divide the sum by 128
    MOV DX,AX   
    MOV AVERAGE,DL  ; average is now calculated and stored
      
      
    ; in this part min and max are calculated  
    MOV MAX,0   ; initializations
    MOV MIN,255
    MOV DI,0
    
MIN_MAX:
    MOV AL,[TABLE+DI]
    CMP MIN,AL          ; MIN =< AL ?
    JNA GO_MAX          ; if yes, then go see for max
    MOV MIN,AL          ; else update minimum data
GO_MAX:
    CMP MAX,AL          ; MAX >= AL ?
    JAE ITS_MAX         ; if yes, then continue
    MOV MAX,AL          ; else update maximum data
ITS_MAX:
    INC DI
    CMP DI,256
    JNE MIN_MAX    
    
    
    
    ; in this part, demanded data is printed
    MOV AL,AVERAGE     ; PRINT AVERAGE
    SAR AL,4
    AND AL,0FH   ; isolate 4 MSB 
    ADD AL,30H   ; ASCII code it 
    PRINT AL     ; print the first hex digit
    
    MOV AL,AVERAGE
    AND AL,0FH   ; isolate 4 LSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK1
    ADD AL,07H   ; if it's a letter, fix ASCII
OK1:
    PRINT AL     ; print the second hex digit
    PRINT 'h'
    
    PRNT_STR NEWLINE
        
        
        
    MOV AL,MIN          ; PRINT MINIMUM DATA
    SAR AL,4
    AND AL,0FH   ; isolate 4 MSB
    CMP AL,0
    JE NEXT_DIGIT 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK2
    ADD AL,07H   ; if it's a letter, fix ASCII
OK2: 
    PRINT AL     ; print the first hex digit
NEXT_DIGIT:    
    MOV AL,MIN
    AND AL,0FH   ; isolate 4 LSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK3
    ADD AL,07H   ; if it's a letter, fix ASCII
OK3: 
    PRINT AL     ; print the second hex digit
    PRINT 'h'
    
    PRINT ' '
    
    MOV AL,MAX           ; PRINT MAXIMUM DATA
    SAR AL,4
    AND AL,0FH   ; isolate 4 MSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK4
    ADD AL,07H   ; if it's a letter, fix ASCII
OK4: 
    PRINT AL     ; print the first hex digit
    
    MOV AL,MAX
    AND AL,0FH   ; isolate 4 LSB 
    ADD AL,30H   ; ASCII code it
    CMP AL,39H
    JLE OK5
    ADD AL,07H   ; if it's a letter, fix ASCII
OK5: 
    PRINT AL     ; print the second hex digit
    PRINT 'h'
      
              
                 
    EXIT   
        
MAIN    ENDP
   
CODE_SEG    ENDS
    END MAIN