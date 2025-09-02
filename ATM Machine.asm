include 'emu8086.inc'
JMP START
  
DATA SEGMENT
    ; ÔÚÇÑ ATM
    BIG_ATM      DB '    ___   _____ __  __ ',0DH,0AH
                 DB '   / _ \ |_   _|  \/  |',0DH,0AH
                 DB '  / /_\ \  | | | |\/| |',0DH,0AH
                 DB ' / /___\ \ | | | |  | |',0DH,0AH
                 DB '/_/     \_\|_| |_|  |_|',0DH,0AH,'$'
    
    TOTAL        DW 20
    IDS1         DW 0000H,0001H,0002H,0003H,0004H,0005H,0006H,0007H,0008H,0009H
    IDS2         DW 000AH,000BH,000CH,000DH,000EH,000FH,0010H,0011H,0012H,0013H
    PASSWORDS1   DB   0H,  1H,  2H,  3H,  4H,  5H,  6H,  7H,  8H,  9H
    PASSWORDS2   DB   0AH, 0BH, 0CH, 0DH, 0EH, 0FH, 1H,  2H,  3H,  4H
    BALANCES     DW 1000,1500,2000,2500,3000,3500,4000,4500,5000,5500
                 DW 6000,6500,7000,7500,8000,8500,9000,9500,10000,10500
   
    ; ÇáÑÓÇÆá
    WELCOME_MSG      DB '****** WELCOME TO ATM SYSTEM ******','$'
    ENTER_ID         DB 0DH,0AH,'ENTER YOUR ID: $'
    ENTER_PASS       DB 0DH,0AH,'ENTER YOUR PASSWORD: $'
    ACCESS_DENIED    DB 0DH,0AH,'ACCESS DENIED! PLEASE TRY AGAIN.$' 
    ACCESS_GRANTED   DB 0DH,0AH,'ACCESS GRANTED! WELCOME.$'
    WELCOME_BACK     DB '****** WELCOME BACK *******$'
    MAIN_MENU        DB 0DH,0AH,'MAIN MENU:',0DH,0AH
                     DB '1. CHECK BALANCE',0DH,0AH
                     DB '2. WITHDRAW',0DH,0AH
                     DB '3. DEPOSIT',0DH,0AH
                     DB '4. CHANGE PASSWORD',0DH,0AH
                     DB '5. EXIT',0DH,0AH
                     DB 'ENTER YOUR CHOICE: $'
    BALANCE_MSG      DB 0DH,0AH,'YOUR CURRENT BALANCE IS: $'
    WITHDRAW_MSG     DB 0DH,0AH,'ENTER AMOUNT TO WITHDRAW: $'
    DEPOSIT_MSG      DB 0DH,0AH,'ENTER AMOUNT TO DEPOSIT: $'
    NEW_PASS_MSG     DB 0DH,0AH,'ENTER NEW PASSWORD: $'
    PASS_CHANGED     DB 0DH,0AH,'PASSWORD CHANGED SUCCESSFULLY!$'
    INVALID_OPTION   DB 0DH,0AH,'INVALID OPTION! TRY AGAIN.$'
    INSUFFICIENT     DB 0DH,0AH,'INSUFFICIENT BALANCE!$'
    THANK_YOU        DB 0DH,0AH,'THANK YOU FOR USING OUR ATM. GOODBYE!$'
   
    ; ÑÓÇÆá ÃÎÑì
    MAX_ATTEMPTS_MSG DB 0DH,0AH,'TOO MANY FAILED ATTEMPTS! SYSTEM LOCKED.$'
    CONFIRM_WITHDRAW DB 0DH,0AH,'CONFIRM WITHDRAWAL? (1=YES, 0=NO): $'
    CONFIRM_CHANGE   DB 0DH,0AH,'CONFIRM PASSWORD CHANGE? (1=YES, 0=NO): $'
    CANCELLED        DB 0DH,0AH,'OPERATION CANCELLED.$'
    PRESS_ANY_KEY    DB 0DH,0AH,'PRESS ANY KEY TO CONTINUE...$'
   
    ; ãÊÛíÑÇÊ ãÄÞÊÉ
    IDINPUT      DW 1 DUP (?)
    PASSINPUT    DB 1 DUP (?)
    CURRENT_USER DW 0     
    TEMP         DW 0     
    ATTEMPTS     DB 0     
    USER_ARRAY   DB 0     ; 0 ááãÕÝæÝÉ ÇáÃæáì¡ 1 ááãÕÝæÝÉ ÇáËÇäíÉ
DATA ENDS

;*****************

CODE SEGMENT

START:
    MOV AX, DATA
    MOV DS, AX 
    
    ; ãÇßÑæÒ
    DEFINE_SCAN_NUM          
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS
    
    ; ÔÇÔÉ ÇáÈÏÇíÉ
    CALL CLEAR_SCREEN
    LEA DX, BIG_ATM
    CALL FAST_PRINT
    
    MOV ATTEMPTS, 0

LOGIN:
    LEA DX, WELCOME_MSG
    CALL FAST_PRINT
    
    CMP ATTEMPTS, 3
    JGE MAX_ATTEMPTS
   
    LEA DX, ENTER_ID
    CALL FAST_PRINT
    CALL SCAN_NUM
    MOV IDINPUT, CX
   
    MOV AX, CX
    MOV CX, 0
    MOV SI, -2
   
SEARCH_ID:
    ADD SI, 2
    INC CX
    CMP CX, TOTAL
    JG ACCESS_DENIED_MSG
    
    ; ÇáÈÍË Ýí ÇáãÕÝæÝÉ ÇáÃæáì
    CMP IDS1[SI], AX
    JE FOUND_IN_ARRAY1
    
    ; ÇáÈÍË Ýí ÇáãÕÝæÝÉ ÇáËÇäíÉ
    CMP IDS2[SI], AX
    JE FOUND_IN_ARRAY2
    
    JMP SEARCH_ID

FOUND_IN_ARRAY1:
    MOV CURRENT_USER, SI
    MOV USER_ARRAY, 0
    JMP CHECK_PASSWORD

FOUND_IN_ARRAY2:
    MOV CURRENT_USER, SI
    MOV USER_ARRAY, 1
    JMP CHECK_PASSWORD
   
CHECK_PASSWORD:
    LEA DX, ENTER_PASS
    CALL FAST_PRINT
    
    ; ÅÏÎÇá ßáãÉ ÇáãÑæÑ ßÑÞã
    CALL SCAN_NUM
    MOV PASSINPUT, CL
    
    ; ÍÓÇÈ ÇáÝåÑÓ ÇáÕÍíÍ áßáãÉ ÇáãÑæÑ
    MOV AX, CURRENT_USER
    SHR AX, 1  ; ÞÓãÉ Úáì 2 áÃä ÇáÝåÑÓ ßÇä ãÖÑæÈÇð Ýí 2
    MOV SI, AX
    
    CMP USER_ARRAY, 0
    JE CHECK_PASS1
    
    ; ÇáÊÍÞÞ ãä ÇáãÕÝæÝÉ ÇáËÇäíÉ
    MOV AL, PASSINPUT
    CMP PASSWORDS2[SI], AL
    JNE ACCESS_DENIED_MSG
    JMP ACCESS_GRANTED_MSG
    
CHECK_PASS1:
    MOV AL, PASSINPUT
    CMP PASSWORDS1[SI], AL
    JNE ACCESS_DENIED_MSG
    JMP ACCESS_GRANTED_MSG
          
ACCESS_DENIED_MSG:
    INC ATTEMPTS
    LEA DX, ACCESS_DENIED
    CALL FAST_PRINT
    
    LEA DX, PRESS_ANY_KEY
    CALL FAST_PRINT
    CALL GET_CHAR
    
    JMP LOGIN
    
ACCESS_GRANTED_MSG:
    MOV ATTEMPTS, 0
    LEA DX, ACCESS_GRANTED
    CALL FAST_PRINT
    LEA DX, WELCOME_BACK
    CALL FAST_PRINT
    
    LEA DX, PRESS_ANY_KEY
    CALL FAST_PRINT
    CALL GET_CHAR
     
MAX_ATTEMPTS:
    CMP ATTEMPTS, 3
    JL MAIN_MENU_DISPLAY
    LEA DX, MAX_ATTEMPTS_MSG
    CALL FAST_PRINT
    JMP EXIT_PROGRAM
   
MAIN_MENU_DISPLAY:
    CALL CLEAR_SCREEN
    LEA DX, MAIN_MENU
    CALL FAST_PRINT
    CALL SCAN_NUM
   
    CMP CX, 1
    JE CHECK_BALANCE
    CMP CX, 2
    JE WITHDRAW
    CMP CX, 3
    JE DEPOSIT
    CMP CX, 4
    JE CHANGE_PASSWORD
    CMP CX, 5
    JE EXIT
   
    LEA DX, INVALID_OPTION
    CALL FAST_PRINT
    
    LEA DX, PRESS_ANY_KEY
    CALL FAST_PRINT
    CALL GET_CHAR
    
    JMP MAIN_MENU_DISPLAY
   
CHECK_BALANCE:
    ; ÍÓÇÈ ÇáÝåÑÓ ÇáÕÍíÍ ááÑÕíÏ
    MOV AX, CURRENT_USER
    SHR AX, 1  ; ÞÓãÉ Úáì 2
    MOV BX, 2
    MUL BX     ; ÖÑÈ Ýí 2 áÃä ßá ÑÕíÏ ßáãÉ (2 ÈÇíÊ)
    MOV SI, AX
   
    LEA DX, BALANCE_MSG
    CALL FAST_PRINT
    MOV AX, BALANCES[SI]
    CALL PRINT_NUM_UNS
    
    LEA DX, PRESS_ANY_KEY
    CALL FAST_PRINT
    CALL GET_CHAR
    
    JMP MAIN_MENU_DISPLAY
   
WITHDRAW:
    ; ÍÓÇÈ ÇáÝåÑÓ ÇáÕÍíÍ ááÑÕíÏ
    MOV AX, CURRENT_USER
    SHR AX, 1
    MOV BX, 2
    MUL BX
    MOV SI, AX
   
    LEA DX, WITHDRAW_MSG
    CALL FAST_PRINT
    CALL SCAN_NUM
    MOV TEMP, CX 
    
    LEA DX, CONFIRM_WITHDRAW
    CALL FAST_PRINT
    CALL SCAN_NUM
    CMP CX, 1
    JNE WITHDRAW_CANCELLED
   
    MOV CX, TEMP
    MOV BX, BALANCES[SI]
    CMP CX, BX
    JG INSUFFICIENT_FUNDS
   
    SUB BX, CX
    MOV BALANCES[SI], BX
   
    LEA DX, BALANCE_MSG
    CALL FAST_PRINT
    MOV AX, BALANCES[SI]
    CALL PRINT_NUM_UNS
    JMP MAIN_MENU_LOOP
    
WITHDRAW_CANCELLED:
    LEA DX, CANCELLED
    CALL FAST_PRINT
    JMP MAIN_MENU_LOOP
   
INSUFFICIENT_FUNDS:
    LEA DX, INSUFFICIENT
    CALL FAST_PRINT
    JMP MAIN_MENU_LOOP
   
DEPOSIT:
    ; ÍÓÇÈ ÇáÝåÑÓ ÇáÕÍíÍ ááÑÕíÏ
    MOV AX, CURRENT_USER
    SHR AX, 1
    MOV BX, 2
    MUL BX
    MOV SI, AX
   
    LEA DX, DEPOSIT_MSG
    CALL FAST_PRINT
    CALL SCAN_NUM
   
    ADD BALANCES[SI], CX
   
    LEA DX, BALANCE_MSG
    CALL FAST_PRINT
    MOV AX, BALANCES[SI]
    CALL PRINT_NUM_UNS
    JMP MAIN_MENU_LOOP
   
CHANGE_PASSWORD:
    LEA DX, NEW_PASS_MSG
    CALL FAST_PRINT
    CALL SCAN_NUM
    MOV TEMP, CX 
    
    LEA DX, CONFIRM_CHANGE
    CALL FAST_PRINT
    CALL SCAN_NUM
    CMP CX, 1
    JNE PASSWORD_CANCELLED
    
    MOV CX, TEMP
    MOV PASSINPUT, CL
   
    ; ÍÓÇÈ ÇáÝåÑÓ ÇáÕÍíÍ
    MOV AX, CURRENT_USER
    SHR AX, 1
    MOV SI, AX
    
    CMP USER_ARRAY, 0
    JE UPDATE_PASS1
   
    ; ÊÍÏíË ÇáãÕÝæÝÉ ÇáËÇäíÉ
    MOV AL, CL
    MOV PASSWORDS2[SI], AL
    JMP PASSWORD_UPDATED
   
UPDATE_PASS1:
    MOV AL, CL
    MOV PASSWORDS1[SI], AL
   
PASSWORD_UPDATED:
    LEA DX, PASS_CHANGED
    CALL FAST_PRINT
    JMP MAIN_MENU_LOOP
    
PASSWORD_CANCELLED:
    LEA DX, CANCELLED
    CALL FAST_PRINT
    JMP MAIN_MENU_LOOP
   
EXIT:
    CALL CLEAR_SCREEN
    LEA DX, THANK_YOU
    CALL FAST_PRINT
    LEA DX, PRESS_ANY_KEY
    CALL FAST_PRINT
    CALL GET_CHAR
    JMP START
    
EXIT_PROGRAM:
    MOV AH, 4CH
    INT 21H
   
;===================
; ÈÑæÓíÌÑÇÊ
;===================

FAST_PRINT PROC
    MOV AH, 09H
    INT 21H
    RET
FAST_PRINT ENDP

GET_CHAR PROC
    MOV AH, 00H
    INT 16H
    RET
GET_CHAR ENDP

CLEAR_SCREEN PROC
    MOV AX, 0600H   
    MOV BH, 07H     
    MOV CX, 0000H   
    MOV DX, 184FH   
    INT 10H
    
    MOV AH, 02H     
    MOV BH, 00H     
    MOV DX, 0000H   
    INT 10H
    RET
CLEAR_SCREEN ENDP

MAIN_MENU_LOOP:
    LEA DX, PRESS_ANY_KEY
    CALL FAST_PRINT
    CALL GET_CHAR
    JMP MAIN_MENU_DISPLAY
   
CODE ENDS

END START
