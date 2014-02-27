; hello-os
; TAB=4

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
		MOV		ES,	AX
		
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
		
finish:
		HLT
		JMP		finish			; Infinite loop

; Display information
msg:
		DB		0x0a, 0x0a		; make 2 new lines
		DB		"hello, world"
		DB		0x0a			; make a new line
		DB		0

		RESB	0x7dfe-$		; ?

		DB		0x55, 0xaa

; The output part outside the IPL

		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	4600
		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	1469432
