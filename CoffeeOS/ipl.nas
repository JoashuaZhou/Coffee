; coffeeOS
; TAB=4

CYLS	EQU		10				; Marco definition

		ORG 	0x7c00			; The address where IPL get loaded
		
; The code below is a standard code used in FAT12 format floppy		
		JMP		entry
		DB		0x90
		DB		"HELLOIPL"		; You can use any string to rename the IPL(8 bytes)
		DW		512				; The size of a sector(must be 512 bytes)
		DB		1				; The size of cluster(must be a sector)
		DW		1				; The start position of FAT(normally start with the first sector)
		DB		2				; The amount of FAT(must be 2)
		DW		224				; The size of root directory(normally be 224)
		DW		2880			; The size of floppy(must be 2880 sectors)
		DB		0xf0			; The type of floppy(must be 0xf0)
		DW		9				; The length of FAT(must be 9 sectors)
		DW		18				; The amount of sectors in a track(must be 18)
		DW		2				; The amount of magnetic(must be 2)
		DD		0				; Be 0 if you don't partition the floppy
		DD		2880			; Reclaim the size of floppy
		DB		0,0,0x29		; Unknown
		DD		0xffffffff		; 
		DB		"HELLO-OS   "	; The name of floppy
		DB		"FAT12   "		; The format name of floppy
		RESB	18				; Reserve 18 bytes

; Main body
entry:
		MOV		AX, 0			; Initialize the registers
		MOV		SS, AX
		MOV 	SP, 0x7c00
		MOV		DS, AX
		
; Read from disk
		MOV		AX, 0x0820
		MOV		ES, AX
		MOV		CH, 0			; Cylinder 0 (0 ~ 79)
		MOV		DH, 0			; Magnatic head 0 (0 ~ 1)
		MOV		CL, 2			; Sector 2   (1 ~ 18)
		
readloop:		
		MOV		SI, 0			; Record the amount of failure

retry:
		MOV		AH, 0x02		; Read from disk
		MOV		AL, 1			; read 1 sector
		MOV		BX, 0			; ES:BX is an address of cache area
		MOV		DL, 0x00		; Disk number 0
		INT		0x13			; Interrupt and call for BIOS of disk
		JNC		next			; If error not occur, jump to next to go on reading
		ADD		SI, 1			; Amount of failure increase 1
		CMP		SI, 5			; We only try to read disk less than 5 times
		JAE		error			; We only try to read disk less than 5 times
		MOV		AH, 0x00		; Reset BIOS of reading disk
		MOV		DL, 0x00		; Reset BIOS of reading disk
		INT		0x13			; Reset BIOS of reading disk
		JMP		retry
		
next:
		MOV		AX, ES			
		ADD		AX, 0x0020
		MOV		ES, AX			; We have to do this since no "ADD ES, 0x0020" command
		ADD		CL, 1			; Move to the next sector
		CMP		CL, 18			; Finish reading sector?
		JBE		readloop		; If not finish, keep reading
		MOV		CL, 1			; Reread from sector 1
		ADD		DH, 1			; Move to the other magnatic header
		CMP		DH, 2			; Finish reading magnatic header?
		JB		readloop		; If not finish, keep reading
		MOV		DH, 0
		ADD		CH, 1			; Move to the next cylinder
		CMP		CH, CYLS		; Finish reading cylinder?
		JB		readloop		; If not finish, keep reading
		
; Jump to the haribote.sys, which is our OS
		JMP		0xc200

finish:
		HLT						; CPU will sleep
		JMP		finish			; Infinite loop
		
error:
		MOV		SI, msg
		
putloop:
		MOV		AL, [SI]
		ADD		SI, 1
		CMP		AL, 0
		
		JE		finish
		MOV		AH, 0x0e		; Display a word
		MOV		BX, 15			; Designate the color for characters
		INT		0x10			; Interrupt and call for BIOS of graphic card
		JMP		putloop

; Display information
msg:
		DB		0x0a, 0x0a		; make 2 new lines
		DB		"load error"
		DB		0x0a			; make a new line
		DB		0

		RESB	0x7dfe-$		; ?

		DB		0x55, 0xaa
