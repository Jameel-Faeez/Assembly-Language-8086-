Automated Teller Machines (ATMs) are widely used for secure banking transactions. In real-world scenarios, they rely on microcontrollers or processors to manage authentication and transaction processes. This project aims to simulate the basic authentication process of an ATM system using Assembly Language for the Intel 8086 processor.
The project is designed to operate in a text-based environment and focuses on implementing essential login features:

Requesting user ID

Requesting password

Verifying credentials against stored values

Displaying the access result


The program begins by displaying a welcome message, then prompts the user to enter their ID. The ID is compared with two predefined ID arrays (IDS1 and IDS2). If a match is found, the program prompts for a password, which is verified against the corresponding password list (PASSWORDS1 or PASSWORDS2).
Key implementation details include:

Data Segment Usage: All IDs, passwords, and display messages are stored in the data segment.

Input/Output Handling: The program uses SCAN_NUM to receive numeric input and PRINT_STRING for displaying text.

Control Flow: Loops and conditional jumps (CMP, JE, JNE, JMP) are used for verification and re-prompting.

Error Handling: Invalid credentials trigger an error message and restart the login process.
