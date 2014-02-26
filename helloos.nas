; hello-os
; TAB=4

; The code below is a standard code used in FAT12 format floppy
		DB		0xeb, 0x4e, 0x90
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

		DB		0xb8, 0x00, 0x00, 0x8e, 0xd0, 0xbc, 0x00, 0x7c
		DB		0x8e, 0xd8, 0x8e, 0xc0, 0xbe, 0x74, 0x7c, 0x8a
		DB		0x04, 0x83, 0xc6, 0x01, 0x3c, 0x00, 0x74, 0x09
		DB		0xb4, 0x0e, 0xbb, 0x0f, 0x00, 0xcd, 0x10, 0xeb
		DB		0xee, 0xf4, 0xeb, 0xfd

; Display information

		DB		0x0a, 0x0a		; make 2 new lines
		DB		"hello, world"
		DB		0x0a			; make a new line
		DB		0

		RESB	0x1fe-$			; Repeatly write 0x00 until the address 0x001fe

		DB		0x55, 0xaa

; The output part outside the IPL

		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	4600
		DB		0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
		RESB	1469432
