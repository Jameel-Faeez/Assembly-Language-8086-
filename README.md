8086 ATM System
A fully functional ATM (Automated Teller Machine) system simulator implemented in x86 Assembly language (8086) using the EMU8086 IDE. This project demonstrates core low-level programming concepts, including memory management, input/output handling, and conditional logic in an assembly environment.

//📖 Table of Contents
Features

Project Structure

How It Works

Data Segment

Code Logic

Prerequisites

How to Run

Usage Instructions

Key Procedures

Limitations & Assumptions

Future Enhancements

✨ Features
User Authentication: Secure login with User ID and Password.

Account Management: Pre-defined accounts with balances.

Transaction Menu:

Check Balance: View the current account balance.

Withdraw: Withdraw money with balance validation and confirmation.

Deposit: Add money to the account.

Change Password: Update the account password with confirmation.

Exit: Log out and return to the main screen.

Security: Implements a 3-attempt limit for failed logins before locking the system.

User Interface: Features a text-based ASCII art header and a clear menu-driven interface.

🗂️ Project Structure
The program is structured into two main segments:

DATA SEGMENT: Contains all messages, user data, and variables.

BIG_ATM: ASCII art for the ATM header.

IDS1, IDS2: Arrays holding valid User IDs (10 each, total 20).

PASSWORDS1, PASSWORDS2: Corresponding passwords for the User IDs.

BALANCES: Account balances for all 20 users.

Various messages for user interaction (WELCOME_MSG, MAIN_MENU, etc.).

Runtime variables (IDINPUT, PASSINPUT, CURRENT_USER, ATTEMPTS).

CODE SEGMENT: Contains the executable logic of the ATM system.

START: The main entry point of the program.

LOGIN: Handles the user authentication process.

MAIN_MENU_DISPLAY: Presents the transaction options.

Procedures for each operation (CHECK_BALANCE, WITHDRAW, etc.).

Helper procedures (FAST_PRINT, CLEAR_SCREEN, GET_CHAR).

🔍 How It Works
Data Segment
User data is statically stored in arrays. The program uses an index (CURRENT_USER) and a flag (USER_ARRAY) to track which user is logged in and which array their data resides in (1 or 2). Balances are stored as words (16-bit values).

Code Logic
Initialization: The screen is cleared, and the ASCII art header is displayed.

Login:

The user is prompted for their ID and password.

The program searches through the IDS1 and IDS2 arrays for a match.

If found, it checks the corresponding password in the respective password array.

After 3 failed attempts, the system locks.

Main Menu: Upon successful login, the user is presented with a menu of transactions.

Transactions: Each menu option calls a specific procedure that performs the action (e.g., subtracting from balance for withdrawal, adding for deposit) and provides feedback to the user.

Loop: After a transaction is completed, the user is returned to the main menu until they choose to exit.

✅ Prerequisites
EMU8086 IDE: This program is written specifically for the EMU8086 assembler and emulator. You must have it installed to compile and run the code.

Download from: https://emu8086.en.softonic.com/

🚀 How to Run
Launch EMU8086.

Create a New File: Copy and paste the entire provided assembly code into a new file.

Emulate: Click the "Emulate" button (or press F5) to start the emulation process.

Run: Click the "Run" button (or press F8 to step through, or F9 to run) to execute the program.

📝 Usage Instructions
Login:

When prompted, enter your User ID (e.g., 0 to 19).

Enter your Password (e.g., for User ID 0, the password is 0; for User ID 10, the password is 10 (0xA in hex)).

Main Menu: Choose an operation by typing the corresponding number (1-5) and pressing Enter.

Transactions:

Withdraw/Deposit: Enter the numerical amount.

Confirmations: For critical actions (Withdraw, Change Password), you must confirm (1 for Yes, 0 for No).

Navigation: Press any key when prompted to continue back to the menu.

⚙️ Key Procedures
FAST_PRINT: Uses DOS interrupt 21h function 09h to print a $-terminated string.

SCAN_NUM: An EMU8086-inbuilt procedure to read a number from input into the CX register.

PRINT_NUM_UNS: An EMU8086-inbuilt procedure to print an unsigned number from the AX register.

CLEAR_SCREEN: Uses BIOS interrupt 10h to clear the console screen.

GET_CHAR: Waits for a single keypress from the user.

⚠️ Limitations & Assumptions
Pre-defined Data: All user accounts, passwords, and balances are hardcoded into the program. No dynamic account creation.

Input Validation: Basic validation is present. The system assumes numerical input for menus and amounts.

Password Security: Passwords are stored in plain text and are single-byte hexadecimal values, making them insecure. This is a simulation.

EMU8086 Dependency: The code relies on EMU8086-specific includes (emu8086.inc) and procedures (SCAN_NUM, PRINT_NUM_UNS).

🔮 Future Enhancements
Persistent Storage: Save/load user data to/from a file on disk.

Admin Mode: Add an administrative mode to view all accounts, reset passwords, and modify balances.

Transaction History: Implement a simple log for the last few transactions per account.

Enhanced UI: Create a more robust text-based user interface with boxes and colors using BIOS interrupts.

Stronger Passwords: Implement a routine to handle multi-character string passwords.


