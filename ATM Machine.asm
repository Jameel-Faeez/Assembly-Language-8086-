include 'emu8086.inc'
JMP START
  
DATA SEGMENT
    TOTAL        DW 20
    IDS1         DW 0000H,0001H,0002H,0003H,0004H,0005H,0006H,0007H,0008H,0009H
    IDS2         DW 000AH,000BH,000CH,000DH,000EH,000FH,0010H,0011H,0012H,0013H
    PASSWORDS1   DB   00H,  01H,  02H,  03H,  04H,  05H,  06H,  07H,  08H,  09H
    PASSWORDS2   DB   0AH,  0BH,  0CH,  0DH,  0EH,  0FH,  01H,  02H,  03H,  04H
    BALANCES     DW 1000,1500,2000,2500,3000,3500,4000,4500,5000,5500 ; ????? ??????????
                 DW 6000,6500,7000,7500,8000,8500,9000,9500,10000,10500
   
    ; ????? ??????
    WELCOME_MSG      DB '****** WELCOME TO ATM SYSTEM ******',0
    ENTER_ID         DB 0DH,0AH,'ENTER YOUR ID: ',0
    ENTER_PASS       DB 0DH,0AH,'ENTER YOUR PASSWORD: ',0
    ACCESS_DENIED    DB 0DH,0AH,'ACCESS DENIED! PLEASE TRY AGAIN.',0 
    ACCESS_GRANTED   DB 0DH,0AH,'ACCESS GRANTED! WELCOME.',0
    WELCOME_BACK     DB '****** WELCOME BACK *******',0
    MAIN_MENU        DB 0DH,0AH,'MAIN MENU:',0DH,0AH
                    DB '1. CHECK BALANCE',0DH,0AH
                    DB '2. WITHDRAW',0DH,0AH
                    DB '3. DEPOSIT',0DH,0AH
                    DB '4. CHANGE PASSWORD',0DH,0AH
                    DB '5. EXIT',0DH,0AH
                    DB 'ENTER YOUR CHOICE: ',0
    BALANCE_MSG      DB 0DH,0AH,'YOUR CURRENT BALANCE IS: $',0
    WITHDRAW_MSG     DB 0DH,0AH,'ENTER AMOUNT TO WITHDRAW: $',0
    DEPOSIT_MSG      DB 0DH,0AH,'ENTER AMOUNT TO DEPOSIT: $',0
    NEW_PASS_MSG     DB 0DH,0AH,'ENTER NEW PASSWORD: ',0
    PASS_CHANGED     DB 0DH,0AH,'PASSWORD CHANGED SUCCESSFULLY!',0
    INVALID_OPTION   DB 0DH,0AH,'INVALID OPTION! TRY AGAIN.',0
    INSUFFICIENT     DB 0DH,0AH,'INSUFFICIENT BALANCE!',0
    THANK_YOU        DB 0DH,0AH,'THANK YOU FOR USING OUR ATM. GOODBYE!',0
   
    ; ??????? ??????
    IDINPUT      DW 1 DUP (?)
    PASSINPUT    DB 1 DUP (?)
    CURRENT_USER DW 0     ; ???? ???????? ??????
    TEMP         DW 0     ; ????? ????
DATA ENDS

;*****************

CODE SEGMENT

START:
    MOV AX,DATA
    MOV DS,AX 

    ; ????? ?????? ????????
    DEFINE_SCAN_NUM          
    DEFINE_PRINT_STRING
    DEFINE_PRINT_NUM
    DEFINE_PRINT_NUM_UNS

LOGIN:
    ; ??? ????? ???????
    LEA SI,WELCOME_MSG
    CALL PRINT_STRING
   
    ; ??? ????? ??????
    LEA SI,ENTER_ID
    CALL PRINT_STRING
    CALL SCAN_NUM
    MOV IDINPUT,CX
   
    ; ?????? ?? ???? ??????
    MOV AX,CX
    MOV CX,0
    MOV SI,-1
   
SEARCH_ID:
    INC CX
    CMP CX,TOTAL
    JE ACCESS_DENIED_MSG
    INC SI
    MOV DX,SI
    CMP IDS1[SI],AX
    JE CHECK_PASS1
    CMP IDS2[SI],AX
    JE CHECK_PASS2
    JMP SEARCH_ID
   
CHECK_PASS1:
    ; ??? ???? ???????? ??????
    MOV CURRENT_USER,DX
   
    ; ??? ????? ???? ??????
    LEA SI,ENTER_PASS
    CALL PRINT_STRING       
    CALL SCAN_NUM
    MOV PASSINPUT,CL
   
    ; ?????? ?? ???? ??????
    MOV AX,DX
    MOV DX,0002H
    DIV DL
    MOV SI,AX
    MOV AL,CL
    MOV AH,00H
    CMP PASSWORDS1[SI],AL
    JNE ACCESS_DENIED_MSG
    JMP MAIN_MENU_DISPLAY
     
CHECK_PASS2:
    ; ??? ???? ???????? ??????
    MOV CURRENT_USER,DX
   
    ; ??? ????? ???? ??????
    LEA SI,ENTER_PASS
    CALL PRINT_STRING       
    CALL SCAN_NUM
    MOV PASSINPUT,CL
   
    ; ?????? ?? ???? ??????
    MOV AX,DX
    MOV DX,0002H
    DIV DL
    MOV SI,AX
    MOV AL,CL
    MOV AH,00H
    CMP PASSWORDS2[SI],AL
    JNE ACCESS_DENIED_MSG
    JMP MAIN_MENU_DISPLAY
          
ACCESS_DENIED_MSG:
    LEA SI,ACCESS_DENIED
    CALL PRINT_STRING
    PRINT 0AH     
    PRINT 0DH
    JMP LOGIN
     
MAIN_MENU_DISPLAY:
    LEA SI,ACCESS_GRANTED
    CALL PRINT_STRING
    LEA SI,WELCOME_BACK
    CALL PRINT_STRING
   
MAIN_MENU_LOOP:
    LEA SI,MAIN_MENU
    CALL PRINT_STRING
    CALL SCAN_NUM
   
    CMP CX,1
    JE CHECK_BALANCE
    CMP CX,2
    JE WITHDRAW
    CMP CX,3
    JE DEPOSIT
    CMP CX,4
    JE CHANGE_PASSWORD
    CMP CX,5
    JE EXIT
   
    ; ??? ??? ?????? ??? ????
    LEA SI,INVALID_OPTION
    CALL PRINT_STRING
    JMP MAIN_MENU_LOOP
   
CHECK_BALANCE:
    ; ???? ???? ?????? (CURRENT_USER * 2 ??? BALANCES ?? ?????)
    MOV AX,CURRENT_USER
    MOV BX,2
    MUL BX
    MOV SI,AX
   
    ; ??? ??????
    LEA SI,BALANCE_MSG
    CALL PRINT_STRING
    MOV AX,BALANCES[SI]
    CALL PRINT_NUM_UNS
    JMP MAIN_MENU_LOOP
   
WITHDRAW:
    ; ???? ???? ??????
    MOV AX,CURRENT_USER
    MOV BX,2
    MUL BX
    MOV SI,AX
   
    ; ??? ?????? ?????
    LEA SI,WITHDRAW_MSG
    CALL PRINT_STRING
    CALL SCAN_NUM
   
    ; ?????? ?? ?????? ??????
    MOV BX,BALANCES[SI]
    CMP CX,BX
    JG INSUFFICIENT_FUNDS
   
    ; ????? ?????
    SUB BX,CX
    MOV BALANCES[SI],BX
   
    ; ??? ?????? ??????
    LEA SI,BALANCE_MSG
    CALL PRINT_STRING
    MOV AX,BALANCES[SI]
    CALL PRINT_NUM_UNS
    JMP MAIN_MENU_LOOP
   
INSUFFICIENT_FUNDS:
    LEA SI,INSUFFICIENT
    CALL PRINT_STRING
    JMP MAIN_MENU_LOOP
   
DEPOSIT:
    ; ???? ???? ??????
    MOV AX,CURRENT_USER
    MOV BX,2
    MUL BX
    MOV SI,AX
   
    ; ??? ?????? ???????
    LEA SI,DEPOSIT_MSG
    CALL PRINT_STRING
    CALL SCAN_NUM
   
    ; ????? ???????
    ADD BALANCES[SI],CX
   
    ; ??? ?????? ??????
    LEA SI,BALANCE_MSG
    CALL PRINT_STRING
    MOV AX,BALANCES[SI]
    CALL PRINT_NUM_UNS
    JMP MAIN_MENU_LOOP
   
CHANGE_PASSWORD:
    ; ??? ???? ?????? ???????
    LEA SI,NEW_PASS_MSG
    CALL PRINT_STRING
    CALL SCAN_NUM
    MOV PASSINPUT,CL
   
    ; ????? ???? ?????? ?? ???????
    MOV AX,CURRENT_USER
    MOV DX,0002H
    DIV DL
   
    ; ????? ??? ??? ???????? ?? ???????? ?????? ?? ???????
    MOV BX,CURRENT_USER
    CMP BX,10
    JL UPDATE_PASS1
   
    ; ????? ???? ?????? ???????? ???????
    SUB BX,10
    MOV SI,BX
    MOV AL,CL
    MOV PASSWORDS2[SI],AL
    JMP PASSWORD_UPDATED
   
UPDATE_PASS1:
    ; ????? ???? ?????? ???????? ??????
    MOV SI,BX
    MOV AL,CL
    MOV PASSWORDS1[SI],AL
   
PASSWORD_UPDATED:
    LEA SI,PASS_CHANGED
    CALL PRINT_STRING
    JMP MAIN_MENU_LOOP
   
EXIT:
    LEA SI,THANK_YOU
    CALL PRINT_STRING
    JMP LOGIN
   
CODE ENDS

END START