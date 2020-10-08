; Microcomputer Systems - Flow Y [6th Semester]
; Nafsika Abatzi - 031 17 198 - nafsika.abatzi@gmail.com
; Dimitris Dimos - 031 17 165 - dimitris.dimos647@gmail.com
; 5th Group of Exercises
; BASIC MACROS TO INCLUDE FOR EASY USE IN EXERCISES



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