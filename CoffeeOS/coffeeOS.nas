; coffeeOS
; TAB=4

; BOOT_INFO
CYLS	EQU		0x0ff0			; Set initial area
LEDS	EQU		0x0ff1			; 
VMODE	EQU		0x0ff2			; The amount and bits of colors
SCRNX	EQU		0x0ff4			; x of screen resolution
SCRNY	EQU		0x0ff6			; y of screen resolution
VRAM	EQU		0x0ff8			; Video RAM, the start address of image cache

		ORG		0xc200			; 0x8000 + 0x4200 = 0xc200?
		
		MOV		AL, 0x13		; VGA, 320*200*8 bit color
		MOV		AH, 0x00
		INT		0x10
		MOV		BYTE [VMODE], 8	; Record screen mode
		MOV		WORD [SCRNX], 320
		MOV		WORD [SCRNY], 200
		MOV		DWORD [VRAM], 0x000a0000
		
; Get Keyboard LED status by keyboard BIOS
		MOV		AH, 0x02
		INT		0x16			; keyboard BIOS
		MOV		[LEDS], AL
fin:
		HLT
		JMP		fin
