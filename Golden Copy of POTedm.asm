;--------------------------------------------------------------------------------------------------
; Configurations, etc. for the Assembler Tools and the PIC

	LIST p = PIC16F648a	;select the processor

    errorlevel  -306 ;Suppresses Message[306]Crossing page boundary -- ensure page bits are set.

#INCLUDE <P16f648a.inc> 		; Microchip Device Header File

; Specify Device Configuration Bits

; Code Protect Off _CP_OFF, Watch Dog Timer Off _WDT_OFF, Brown Out Reset Off _BODEN_ON,
; Power Up Timer On _PWRTE_ON, RC Oscillator _RC_OSC, Write Enable to Flash Memory Off _WRT_ENABLE_OFF,
; Low Voltage Programming On _LVP_ON, Debug Mode Off _DEBUG_OFF, EEprom Code Protection Off _CPD_OFF


  __CONFIG _RC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_ON & _EXTCLK_OSC & _MCLRE_OFF & _LVP_OFF

;wip mks - update the following to match the above config line
;_CP_OFF = code can be read back from device
;_WDT_OFF = watch dog timer is off
;_BODEN_ON = device will be reset and held in reset while power drops below acceptable level
;_PWRTE_ON = device will delay startup after power applied to ensure stable operation
;_XT_OSC = device will use oscillator or crystal resonator
;_LVP_ON = device can be programmed in system with low voltage

;for improved reliability, Watch Dog code can be added and the Watch Dog Timer turned on - _WDT_ON
;turn on code protection to keep others from reading the code from the chip - _CP_ON
; _RC_OSC = RC oscillator
; _XT_OSC = Crystal/Resonator oscillator

; end of configurations
;--------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------
; Variables in RAM
;
; Note that you cannot use a lot of the data definition directives for RAM space (such as DB)
; unless you are compiling object files and using a linker command file.  The cblock directive is
; commonly used to reserve RAM space or Code space when producing "absolute" code, as is done here.
; 

; Assign variables in RAM - Bank 0

 cblock 	0x7f      	; Define a var at 127


	tvar                ; use this to test opcodes using a register

 endc

; Define variables in the memory which is mirrored in all 4 RAM banks.  This area is usually used
; by the interrupt routine for saving register states because there is no need to worry about
; which bank is current when the interrupt is invoked.
; On the PIC16F876, 0x70 thru 0x7f is mirrored in all 4 RAM banks.

 cblock	0x70

	W_TEMP
	FSR_TEMP
	STATUS_TEMP
	PCLATH_TEMP
	
 endc

; end of Variables in RAM
;--------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------
; Power On and Reset Vectors
;

;	org 0x00                ; Start of Program Memory

;	goto start		; jump to main code section
;	nop			; Pad out so interrupt
;	nop			;  service routine gets
;	nop			;    put at address 0x0004.
;	goto interrupt_handler	; points to interrupt service routine


; end of Reset Vectors
;--------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------
; start function^
;
; Program execution starts here.  After initializing the PIC, the main loop is entered which runs
; indefinitely.
; 

    org 0x0
    goto    L0        ;(0x9e)
L127:
    call    L1        ;(0x19)
    movwf   0x36
    call    L2        ;(0x15)
    movf    0x20,W
    iorwf   0x21,W
    btfsc   0x3,2
    goto    L3        ;(0x99)
    call    L4        ;(0x93)
    bcf     0x4,7
    movf    0x36,W
    xorwf   0x0,F
L7:
    clrwdt
    goto    L5        ;(0xe)
L5:
    goto    L6        ;(0xf)
L6:
    incf    0x20,F
    btfsc   0x3,2
L168:
    incfsz  0x21,F
    goto    L7        ;(0xc)
    xorwf   0x0,F
    goto    L3        ;(0x99)
L2:
    xorlw   0xff
L176:
    bsf     0x4,7
    andwf   0x0,F
    goto    L3        ;(0x99)
L1:
    movwf   0x28
    movlw   0x6
    btfsc   0x28,3
    movlw   0x5
    movwf   0x4
    movlw   0x0
    movwf   0xa
    movf    0x28,W
    andlw   0x7
    addwf   0x2,F
    retlw   0x1
    retlw   0x2
    retlw   0x4
L175:
    retlw   0x8
    retlw   0x10
    retlw   0x20
    retlw   0x40
    retlw   0x80
    movwf   0x4
    movf    0x0,W
    goto    L3        ;(0x99)
L50:
    clrf    0x23
L18:
    movwf   0x22
L9:
    movlw   0xff
    addwf   0x22,F
    btfss   0x3,0
    addwf   0x23,F
    btfss   0x3,0
    goto    L3        ;(0x99)
    movlw   0x3
L174:
    movwf   0x21
    movlw   0xe6
    call    L8        ;(0x3c)
    goto    L9        ;(0x30)
    clrf    0x21
L8:
    addlw   0xfb
L173:
    movwf   0x20
    comf    0x21,F
    movlw   0xff
    btfss   0x3,0
    goto    L10        ;(0x45)
L11:
    addwf   0x20,F
    btfsc   0x3,0
    goto    L11        ;(0x42)
L10:
    addwf   0x20,F
    clrwdt
    incfsz  0x21,F
    goto    L11        ;(0x42)
    nop
    return
L57:
    movwf   0x22
    movlw   0x1
    goto    L12        ;(0x51)
L156:
    movwf   0x22
    movlw   0x4
    goto    L12        ;(0x51)
L12:
    movwf   0x28
L179:
    movf    0x23,W
    subwf   0x21,W
    btfss   0x3,2
    goto    L13        ;(0x58)
    movf    0x22,W
    subwf   0x20,W
L13:
    movlw   0x4
    btfsc   0x3,0
    movlw   0x1
    btfsc   0x3,2
    movlw   0x2
    andwf   0x28,W
    btfss   0x3,2
    movlw   0xff
    goto    L3        ;(0x99)
L68:
    clrf    0x25
    clrf    0x24
    movlw   0x10
    movwf   0x26
L15:
    rlf     0x21,W
    rlf     0x24,F
L178:
    rlf     0x25,F
    movf    0x22,W
    subwf   0x24,F
    movf    0x23,W
    btfss   0x3,0
    incfsz  0x23,W
L177:
    subwf   0x25,F
    btfsc   0x3,0
    goto    L14        ;(0x77)
    movf    0x22,W
    addwf   0x24,F
    movf    0x23,W
    btfsc   0x3,0
    incfsz  0x23,W
L186:
    addwf   0x25,F
    bcf     0x3,0
L14:
    rlf     0x20,F
    rlf     0x21,F
    decfsz  0x26,F
    goto    L15        ;(0x65)
    movf    0x20,W
    goto    L3        ;(0x99)
L69:
    movlw   0x10
    movwf   0x28
    clrf    0x21
    clrf    0x20
L17:
    rrf     0x27,F
    rrf     0x26,F
    btfss   0x3,0
    goto    L16        ;(0x8b)
    movf    0x22,W
    addwf   0x20,F
    movf    0x23,W
    btfsc   0x3,0
L182:
    incfsz  0x23,W
    addwf   0x21,F
L16:
    rrf     0x21,F
    rrf     0x20,F
    rrf     0x25,F
    rrf     0x24,F
    decfsz  0x28,F
    goto    L17        ;(0x81)
L181:
    movf    0x24,W
    goto    L3        ;(0x99)
L4:
    comf    0x20,F
    comf    0x21,F
L187:
    incf    0x20,F
    btfsc   0x3,2
    incf    0x21,F
    return
L3:
    bcf     0x3,7
    bcf     0x3,6
    bcf     0x3,5
    clrwdt
    return
L0:
    movlw   0x7
    movwf   0x1f
    movlw   0xff
L188:
    movwf   0x6
    bsf     0x3,5
    movlw   0x78
    movwf   0x6
    bcf     0x3,5
    movlw   0xff
    movwf   0x5
    bsf     0x3,5
L183:
    movlw   0x38
    movwf   0x5
    movlw   0x58
    movwf   0x1
    bcf     0x3,5
    movlw   0x3
L185:
    movwf   0x5
    movlw   0xff
    movwf   0x6
    clrf    0x40
    clrf    0x41
    movlw   0x3
L184:
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L18        ;(0x2f)
L109:
    bsf     0xa,3
    call    L19        ;(0x6a8)
    movlw   0xe8
    movwf   0x4a
    movlw   0x3
    movwf   0x4b
    movlw   0xe8
L180:
    movwf   0x48
    movlw   0x3
    movwf   0x49
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L18        ;(0x2f)
    bsf     0xa,3
    call    L20        ;(0x6ae)
    movlw   0x1
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x80
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L26:
    clrwdt
    movlw   0x14
    subwf   0x50,W
L194:
    bcf     0xa,3
    btfsc   0x3,0
    goto    L22        ;(0x101)
    movf    0x50,W
    sublw   0x13
    bcf     0xa,3
    btfss   0x3,0
    goto    L23        ;(0xfb)
    bcf     0xa,3
    call    L24        ;(0xe3)
    movwf   0x4e
    bcf     0xa,3
    goto    L23        ;(0xfb)
L24:
    movlw   0x0
    movwf   0xa
    movf    0x50,W
L193:
    addwf   0x2,F
    retlw   0x4f
    retlw   0x50
    retlw   0x54
    retlw   0x20
    retlw   0x41
    retlw   0x75
    retlw   0x74
    retlw   0x6f
    retlw   0x4e
    retlw   0x6f
    retlw   0x74
    retlw   0x63
    retlw   0x68
    retlw   0x65
    retlw   0x72
    retlw   0x20
    retlw   0x52
    retlw   0x36
    retlw   0x2e
L192:
    retlw   0x34
L23:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
L191:
    goto    L26        ;(0xd3)
L22:
    movlw   0xc0
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
L198:
    clrf    0x50
L30:
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L27        ;(0x134)
    movf    0x50,W
    sublw   0x13
    bcf     0xa,3
    btfss   0x3,0
    goto    L28        ;(0x12e)
    bcf     0xa,3
    call    L29        ;(0x116)
    movwf   0x4e
    bcf     0xa,3
L197:
    goto    L28        ;(0x12e)
L29:
    movlw   0x1
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x43
    retlw   0x48
    retlw   0x4f
    retlw   0x4f
    retlw   0x53
    retlw   0x45
    retlw   0x20
    retlw   0x43
    retlw   0x4f
    retlw   0x4e
    retlw   0x46
L196:
    retlw   0x49
    retlw   0x47
    retlw   0x55
    retlw   0x52
    retlw   0x41
    retlw   0x54
L195:
    retlw   0x49
    retlw   0x4f
    retlw   0x4e
L28:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L30        ;(0x106)
L27:
    movlw   0x94
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
L200:
    clrf    0x50
L34:
    clrwdt
    movlw   0x13
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L31        ;(0x166)
    movf    0x50,W
    sublw   0x12
    bcf     0xa,3
    btfss   0x3,0
    goto    L32        ;(0x160)
    bcf     0xa,3
    call    L33        ;(0x149)
    movwf   0x4e
    bcf     0xa,3
    goto    L32        ;(0x160)
L33:
    movlw   0x1
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
L201:
    retlw   0x31
    retlw   0x20
    retlw   0x2d
    retlw   0x20
    retlw   0x45
    retlw   0x44
    retlw   0x4d
    retlw   0x20
    retlw   0x4e
    retlw   0x6f
    retlw   0x74
    retlw   0x63
    retlw   0x68
L203:
    retlw   0x43
    retlw   0x75
    retlw   0x74
    retlw   0x74
    retlw   0x65
L199:
    retlw   0x72
L32:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L34        ;(0x139)
L31:
    movlw   0xd4
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L38:
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
L204:
    goto    L35        ;(0x199)
    movf    0x50,W
    sublw   0x13
    bcf     0xa,3
    btfss   0x3,0
    goto    L36        ;(0x193)
    bcf     0xa,3
    call    L37        ;(0x17b)
    movwf   0x4e
    bcf     0xa,3
    goto    L36        ;(0x193)
L37:
    movlw   0x1
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x32
    retlw   0x20
L205:
    retlw   0x2d
    retlw   0x20
L206:
    retlw   0x45
    retlw   0x44
    retlw   0x4d
    retlw   0x20
    retlw   0x45
    retlw   0x78
    retlw   0x74
    retlw   0x65
    retlw   0x6e
    retlw   0x64
    retlw   0x20
    retlw   0x52
    retlw   0x65
    retlw   0x61
    retlw   0x63
    retlw   0x68
L36:
    bsf     0xa,3
L202:
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L38        ;(0x16b)
L35:
    movlw   0x94
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    bsf     0xa,3
    call    L39        ;(0x67c)
    movlw   0x1
    movwf   0x5c
L46:
    clrwdt
    bcf     0xa,3
    btfss   0x6,3
    goto    L40        ;(0x1dc)
    clrwdt
    bcf     0xa,3
    btfsc   0x6,5
    goto    L41        ;(0x1b7)
L42:
    clrwdt
    bcf     0xa,3
    btfss   0x6,5
    goto    L42        ;(0x1a9)
    clrwdt
    movf    0x5c,W
    sublw   0x1
    bcf     0xa,3
    btfsc   0x3,2
    goto    L43        ;(0x1b5)
    bcf     0xa,3
    goto    L44        ;(0x1c9)
L43:
    bcf     0xa,3
    goto    L45        ;(0x1cf)
L41:
    clrwdt
    bcf     0xa,3
    btfsc   0x6,4
    goto    L46        ;(0x1a1)
L47:
    clrwdt
    bcf     0xa,3
    btfss   0x6,4
    goto    L47        ;(0x1bb)
    clrwdt
    movf    0x5c,W
    sublw   0x1
    bcf     0xa,3
    btfsc   0x3,2
    goto    L48        ;(0x1c7)
    bcf     0xa,3
L189:
    goto    L44        ;(0x1c9)
L48:
    bcf     0xa,3
    goto    L45        ;(0x1cf)
L44:
    movlw   0x1
    movwf   0x5c
    movlw   0x94
    movwf   0x4e
    bcf     0xa,3
    goto    L49        ;(0x1d5)
L45:
    movlw   0x2
L255:
    movwf   0x5c
    movlw   0xd4
    movwf   0x4e
    bcf     0xa,3
    goto    L49        ;(0x1d5)
L49:
    bsf     0xa,3
    call    L21        ;(0x668)
L208:
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    clrf    0xa
    goto    L46        ;(0x1a1)
L40:
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    bsf     0xa,3
    call    L51        ;(0x677)
    clrwdt
    movf    0x5c,W
L207:
    sublw   0x2
    bcf     0xa,3
    btfsc   0x3,2
    goto    L52        ;(0x725)
    movlw   0x1
L212:
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x80
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L56:
    clrwdt
    movlw   0x13
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L53        ;(0x21d)
    movf    0x50,W
    sublw   0x12
L211:
    bcf     0xa,3
    btfss   0x3,0
    goto    L54        ;(0x217)
    bcf     0xa,3
    call    L55        ;(0x200)
    movwf   0x4e
    bcf     0xa,3
    goto    L54        ;(0x217)
L55:
    movlw   0x2
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x4f
    retlw   0x50
    retlw   0x54
    retlw   0x20
    retlw   0x45
L210:
    retlw   0x44
    retlw   0x4d
    retlw   0x20
    retlw   0x4e
    retlw   0x6f
    retlw   0x74
L209:
    retlw   0x63
    retlw   0x68
    retlw   0x43
    retlw   0x75
    retlw   0x74
L215:
    retlw   0x74
    retlw   0x65
    retlw   0x72
L54:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L56        ;(0x1f0)
L53:
    movlw   0xc2
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movf    0x40,W
    movwf   0x20
    movf    0x41,W
L214:
    movwf   0x21
    clrf    0x23
    movlw   0x0
    clrf    0xa
    call    L57        ;(0x4b)
    bcf     0xa,3
    btfss   0x3,2
    goto    L58        ;(0x25a)
    clrf    0x50
L62:
    clrwdt
    movlw   0x11
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L59        ;(0x258)
    movf    0x50,W
    sublw   0x10
    bcf     0xa,3
    btfss   0x3,0
L213:
    goto    L60        ;(0x252)
    bcf     0xa,3
    call    L61        ;(0x23d)
    movwf   0x4e
    bcf     0xa,3
    goto    L60        ;(0x252)
L61:
    movlw   0x2
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x31
    retlw   0x20
    retlw   0x2d
    retlw   0x20
    retlw   0x53
    retlw   0x45
L220:
    retlw   0x54
    retlw   0x20
    retlw   0x43
    retlw   0x55
    retlw   0x54
    retlw   0x20
    retlw   0x44
    retlw   0x45
    retlw   0x50
    retlw   0x54
    retlw   0x48
L60:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
L217:
    bcf     0xa,3
    btfss   0x3,2
    goto    L62        ;(0x22d)
L59:
    bcf     0xa,3
    goto    L63        ;(0x2de)
L58:
    clrf    0x50
L67:
    clrwdt
    movlw   0xe
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L64        ;(0x283)
    movf    0x50,W
    sublw   0xd
    bcf     0xa,3
    btfss   0x3,0
    goto    L65        ;(0x27d)
    bcf     0xa,3
L218:
    call    L66        ;(0x26b)
    movwf   0x4e
    bcf     0xa,3
    goto    L65        ;(0x27d)
L66:
    movlw   0x2
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x31
    retlw   0x20
    retlw   0x2d
    retlw   0x20
    retlw   0x44
L221:
    retlw   0x45
    retlw   0x50
    retlw   0x54
    retlw   0x48
    retlw   0x20
    retlw   0x3d
    retlw   0x20
L222:
    retlw   0x30
    retlw   0x2e
L65:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L67        ;(0x25b)
L64:
    movf    0x40,W
    movwf   0x20
    movf    0x41,W
    movwf   0x21
    movlw   0x10
L219:
    movwf   0x22
    movlw   0x27
    movwf   0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x59
    movlw   0x30
    addwf   0x59,W
L190:
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x59,W
    movwf   0x26
    clrf    0x27
    movlw   0x10
    movwf   0x22
    movlw   0x27
    movwf   0x23
L226:
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x46
    movf    0x25,W
    movwf   0x47
    movf    0x46,W
    subwf   0x40,W
    movwf   0x44
    movf    0x47,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x41,W
    movwf   0x45
    movf    0x44,W
    movwf   0x20
    movf    0x45,W
L225:
    movwf   0x21
    movlw   0xe8
    movwf   0x22
    movlw   0x3
    movwf   0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x5a
    movlw   0x30
    addwf   0x5a,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x5a,W
    movwf   0x26
    clrf    0x27
    movlw   0xe8
    movwf   0x22
    movlw   0x3
    movwf   0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x46
    movf    0x25,W
L224:
    movwf   0x47
    movf    0x46,W
    subwf   0x44,W
    movwf   0x42
    movf    0x47,W
    btfss   0x3,0
L223:
    addlw   0x1
    subwf   0x45,W
    movwf   0x43
    movf    0x42,W
    movwf   0x20
L230:
    movf    0x43,W
    movwf   0x21
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x58
    movlw   0x30
    addwf   0x58,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x22
    movwf   0x4e
    bsf     0xa,3
L229:
    call    L25        ;(0x670)
L63:
    movlw   0x96
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L74:
    clrwdt
    movlw   0xd
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L70        ;(0x314)
    movf    0x50,W
    sublw   0xc
    bcf     0xa,3
    btfss   0x3,0
    goto    L71        ;(0x30e)
    bcf     0xa,3
    call    L72        ;(0x2f3)
    movwf   0x4e
    bcf     0xa,3
    goto    L71        ;(0x30e)
L72:
    movlw   0x3
L228:
    movwf   0xa
    movf    0x50,W
    goto    L73        ;(0x300)
    
 cblock 	0x2f7      	; define variables at 2f7
    fill7               ; (0x2f7)
    fill8               ; (0x2f8)
    fill9               ; (0x2f9)
    L227                ; (0x2fa)
    fillb               ; (0x2fb)
    fillc               ; (0x2fc)
    filld               ; (0x2fd)
    fille               ; (0x2fe)
    fillf               ; (0x2ff)
 endc

    org 0x300

L73:
    addwf   0x2,F
    retlw   0x32
    retlw   0x20
    retlw   0x2d
    retlw   0x20
    retlw   0x43
    retlw   0x55
    retlw   0x54
L234:
    retlw   0x20
    retlw   0x4e
    retlw   0x4f
    retlw   0x54
    retlw   0x43
    retlw   0x48
L71:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L74        ;(0x2e3)
L70:
    movlw   0xd6
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
L233:
    clrf    0x50
L78:
    clrwdt
    movlw   0x11
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L75        ;(0x344)
    movf    0x50,W
    sublw   0x10
    bcf     0xa,3
    btfss   0x3,0
    goto    L76        ;(0x33e)
    bcf     0xa,3
    call    L77        ;(0x329)
    movwf   0x4e
    bcf     0xa,3
    goto    L76        ;(0x33e)
L77:
    movlw   0x3
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x33
    retlw   0x20
    retlw   0x2d
L232:
    retlw   0x20
    retlw   0x4a
    retlw   0x4f
    retlw   0x47
    retlw   0x20
    retlw   0x45
L231:
    retlw   0x4c
    retlw   0x45
    retlw   0x43
    retlw   0x54
    retlw   0x52
L238:
    retlw   0x4f
    retlw   0x44
    retlw   0x45
L76:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L78        ;(0x319)
L75:
    movlw   0xc2
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    bsf     0xa,3
    call    L39        ;(0x67c)
    movlw   0x1
L237:
    movwf   0x5c
L86:
    clrwdt
    bcf     0xa,3
    btfss   0x6,3
    goto    L79        ;(0x399)
    clrwdt
    bcf     0xa,3
    btfsc   0x6,5
    goto    L80        ;(0x368)
L81:
    clrwdt
    bcf     0xa,3
    btfss   0x6,5
    goto    L81        ;(0x354)
    clrwdt
    movlw   0x3
    subwf   0x5c,W
    bcf     0xa,3
    btfss   0x3,0
    goto    L82        ;(0x360)
    bcf     0xa,3
    goto    L83        ;(0x380)
L82:
    clrwdt
    movf    0x5c,W
    sublw   0x2
L236:
    bcf     0xa,3
    btfsc   0x3,2
    goto    L84        ;(0x38c)
    bcf     0xa,3
    goto    L85        ;(0x386)
L80:
    clrwdt
L235:
    bcf     0xa,3
    btfsc   0x6,4
    goto    L86        ;(0x34c)
L87:
    clrwdt
    bcf     0xa,3
    btfss   0x6,4
    goto    L87        ;(0x36c)
    clrwdt
    movlw   0x2
    subwf   0x5c,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L88        ;(0x378)
    bcf     0xa,3
    goto    L84        ;(0x38c)
L88:
    clrwdt
    movf    0x5c,W
    sublw   0x2
    bcf     0xa,3
    btfsc   0x3,2
    goto    L83        ;(0x380)
    bcf     0xa,3
    goto    L85        ;(0x386)
L83:
    movlw   0x1
    movwf   0x5c
    movlw   0xc2
    movwf   0x4e
    bcf     0xa,3
    goto    L89        ;(0x390)
L85:
    movlw   0x2
    movwf   0x5c
    movlw   0x96
    movwf   0x4e
    bcf     0xa,3
    goto    L89        ;(0x390)
L84:
    movlw   0x3
    movwf   0x5c
    movlw   0xd6
L240:
    movwf   0x4e
L89:
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L18        ;(0x2f)
    clrf    0xa
    goto    L86        ;(0x34c)
L79:
    movlw   0x3
    movwf   0x23
L239:
    movlw   0xe8
    clrf    0xa
    call    L18        ;(0x2f)
    bsf     0xa,3
    call    L51        ;(0x677)
    clrwdt
L241:
    movf    0x5c,W
    sublw   0x3
    bcf     0xa,3
    btfsc   0x3,2
    goto    L90        ;(0x4ab)
    clrwdt
    movf    0x5c,W
    sublw   0x2
    bcf     0xa,3
    btfsc   0x3,2
    goto    L91        ;(0x55c)
    movlw   0x1
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L95:
    clrwdt
    movlw   0x10
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L92        ;(0x3db)
    movf    0x50,W
    sublw   0xf
    bcf     0xa,3
    btfss   0x3,0
    goto    L93        ;(0x3d5)
    bcf     0xa,3
    call    L94        ;(0x3c1)
L243:
    movwf   0x4e
    bcf     0xa,3
    goto    L93        ;(0x3d5)
L94:
    movlw   0x3
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x20
    retlw   0x20
    retlw   0x20
    retlw   0x53
    retlw   0x65
L242:
    retlw   0x74
    retlw   0x20
    retlw   0x43
    retlw   0x55
    retlw   0x54
L246:
    retlw   0x20
    retlw   0x44
    retlw   0x45
    retlw   0x50
    retlw   0x54
    retlw   0x48
L93:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L95        ;(0x3b1)
L92:
    movlw   0xc4
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
L245:
    clrf    0x50
L99:
    clrwdt
    movlw   0xc
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L96        ;(0x406)
    movf    0x50,W
    sublw   0xb
    bcf     0xa,3
    btfss   0x3,0
L244:
    goto    L97        ;(0x400)
    bcf     0xa,3
    call    L98        ;(0x3f0)
    movwf   0x4e
    bcf     0xa,3
    goto    L97        ;(0x400)
L98:
    movlw   0x3
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x30
    retlw   0x2e
    retlw   0x30
    retlw   0x30
    retlw   0x30
    retlw   0x20
    retlw   0x69
    retlw   0x6e
    retlw   0x63
    retlw   0x68
    retlw   0x65
    retlw   0x73
L97:
    bsf     0xa,3
L247:
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L99        ;(0x3e0)
L96:
    movlw   0xc6
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    bsf     0xa,3
    call    L39        ;(0x67c)
    movlw   0x1
    movwf   0x5c
    clrf    0x53
L107:
    clrwdt
    bcf     0xa,3
    btfsc   0x6,3
    goto    L100        ;(0x43c)
L101:
    clrwdt
    bcf     0xa,3
    btfss   0x6,3
    goto    L101        ;(0x413)
    movlw   0x1
    movwf   0x23
    movlw   0x2c
    clrf    0xa
    call    L18        ;(0x2f)
    movlw   0x14
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
L249:
    clrwdt
    movlw   0x3
    subwf   0x5c,W
    bcf     0xa,3
    btfss   0x3,0
    goto    L102        ;(0x42a)
    movf    0x53,W
    movwf   0x55
L248:
    bcf     0xa,3
    goto    L103        ;(0x471)
L102:
    clrwdt
    movlw   0x2
    subwf   0x5c,W
    bcf     0xa,3
    btfss   0x3,0
    goto    L104        ;(0x437)
    movf    0x53,W
    movwf   0x57
    movlw   0x3
    movwf   0x5c
    clrf    0x53
    bcf     0xa,3
    goto    L100        ;(0x43c)
L104:
    movf    0x53,W
    movwf   0x56
    movlw   0x2
    movwf   0x5c
    clrf    0x53
L100:
    clrwdt
    bcf     0xa,3
    btfsc   0x6,5
    goto    L105        ;(0x44d)
    movlw   0xc8
    clrf    0xa
L251:
    call    L50        ;(0x2e)
    clrwdt
    movlw   0x1
    subwf   0x53,W
    bcf     0xa,3
    btfsc   0x3,0
L250:
    goto    L106        ;(0x45e)
    movlw   0xa
    movwf   0x53
    bcf     0xa,3
    goto    L106        ;(0x45e)
L105:
    clrwdt
    bcf     0xa,3
    btfsc   0x6,4
    goto    L107        ;(0x40f)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    clrwdt
    movlw   0x9
    subwf   0x53,W
    bcf     0xa,3
    btfss   0x3,0
    goto    L108        ;(0x460)
    movlw   0xff
    movwf   0x53
    bcf     0xa,3
    goto    L108        ;(0x460)
L106:
    movlw   0x2
    subwf   0x53,F
L108:
    incf    0x53,F
    movlw   0xc5
    addwf   0x5c,W
L252:
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x30
    addwf   0x53,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
L253:
    movlw   0x10
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0xa
    goto    L107        ;(0x40f)
L103:
    bsf     0xa,3
    call    L51        ;(0x677)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    movf    0x56,W
    movwf   0x26
    clrf    0x27
    movlw   0x10
    movwf   0x22
    movlw   0x27
    movwf   0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x57,W
    movwf   0x26
    clrf    0x27
    movlw   0xe8
    movwf   0x22
    movlw   0x3
    movwf   0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x44
    movf    0x25,W
    movwf   0x45
    movf    0x42,W
    addwf   0x44,W
    movwf   0x46
    movf    0x43,W
    btfsc   0x3,0
    addlw   0x1
    addwf   0x45,W
    movwf   0x47
    movf    0x55,W
    movwf   0x26
    clrf    0x27
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x46,W
    addwf   0x42,W
L254:
    movwf   0x40
    movf    0x47,W
    btfsc   0x3,0
    addlw   0x1
    addwf   0x43,W
    movwf   0x41
    clrf    0xa
    goto    L109        ;(0xb9)
L90:
    movlw   0x1
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x1
    movwf   0x23
    movlw   0xf4
    clrf    0xa
    call    L18        ;(0x2f)
    bcf     0x6,7
L158:
    movlw   0x80
L120:
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x20
    movwf   0x4e
    clrf    0x50
L111:
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L110        ;(0x4c8)
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L111        ;(0x4bc)
L110:
    movlw   0x86
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L115:
    clrwdt
    movlw   0x8
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L112        ;(0x4ef)
    movf    0x50,W
L256:
    sublw   0x7
    bcf     0xa,3
    btfss   0x3,0
    goto    L113        ;(0x4e9)
    bcf     0xa,3
    call    L114        ;(0x4dd)
    movwf   0x4e
    bcf     0xa,3
    goto    L113        ;(0x4e9)
L114:
    movlw   0x4
    movwf   0xa
    movf    0x50,W
L257:
    addwf   0x2,F
    retlw   0x4a
    retlw   0x4f
    retlw   0x47
    retlw   0x20
    retlw   0x4d
    retlw   0x6f
    retlw   0x64
    retlw   0x65
L113:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L115        ;(0x4cd)
L112:
    movlw   0xc4
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L119:
    clrwdt
    movlw   0xc
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L116        ;(0x51a)
    movf    0x50,W
    sublw   0xb
    bcf     0xa,3
    btfss   0x3,0
    goto    L117        ;(0x514)
    bcf     0xa,3
    call    L118        ;(0x504)
    movwf   0x4e
    bcf     0xa,3
    goto    L117        ;(0x514)
L118:
    movlw   0x5
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x5a
    retlw   0x45
    retlw   0x52
    retlw   0x4f
    retlw   0x20
    retlw   0x6f
    retlw   0x72
    retlw   0x20
    retlw   0x45
    retlw   0x58
    retlw   0x49
    retlw   0x54
L117:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L119        ;(0x4f4)
L116:
    movlw   0xe6
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x22
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    bsf     0xa,3
    call    L120        ;(0x4b6)
L124:
    clrwdt
    bcf     0xa,3
    btfss   0x6,4
    goto    L121        ;(0x532)
    clrwdt
    bcf     0xa,3
    btfss   0x6,5
    goto    L122        ;(0x53b)
    clrwdt
    bcf     0xa,3
    btfss   0x6,3
    goto    L123        ;(0x550)
    clrf    0xa
    goto    L124        ;(0x524)
L121:
    bcf     0x6,1
    movlw   0x1
    subwf   0x48,F
    movlw   0x0
    btfss   0x3,0
    addlw   0x1
    subwf   0x49,F
    bcf     0xa,3
    goto    L125        ;(0x53f)
L122:
    bsf     0x6,1
    incf    0x48,F
    btfsc   0x3,2
    incf    0x49,F
L125:
    clrwdt
    bcf     0xa,3
    btfsc   0x6,6
    goto    L126        ;(0x546)
    movlw   0x64
    clrf    0xa
    call    L50        ;(0x2e)
L126:
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    bsf     0xa,3
    call    L120        ;(0x4b6)
    clrf    0xa
    goto    L124        ;(0x524)
L123:
    clrwdt
    bcf     0xa,3
    btfsc   0x6,6
    goto    L109        ;(0xb9)
    movlw   0xe8
    movwf   0x48
    movlw   0x3
    movwf   0x49
    bsf     0xa,3
    call    L120        ;(0x4b6)
    clrf    0xa
    goto    L124        ;(0x524)
L91:
    movlw   0x1
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    clrf    0x50
L131:
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L128        ;(0x592)
    movf    0x50,W
    sublw   0x13
    bcf     0xa,3
    btfss   0x3,0
    goto    L129        ;(0x58c)
    bcf     0xa,3
    call    L130        ;(0x574)
    movwf   0x4e
    bcf     0xa,3
    goto    L129        ;(0x58c)
L130:
    movlw   0x5
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x4f
    retlw   0x50
    retlw   0x54
    retlw   0x20
    retlw   0x41
    retlw   0x75
    retlw   0x74
    retlw   0x6f
    retlw   0x4e
    retlw   0x6f
    retlw   0x74
    retlw   0x63
    retlw   0x68
    retlw   0x20
    retlw   0x52
    retlw   0x65
    retlw   0x76
    retlw   0x36
    retlw   0x2e
    retlw   0x31
L129:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L131        ;(0x564)
L128:
    movlw   0xd4
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L135:
    clrwdt
    movlw   0x13
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L132        ;(0x5c4)
    movf    0x50,W
    sublw   0x12
    bcf     0xa,3
    btfss   0x3,0
    goto    L133        ;(0x5be)
    bcf     0xa,3
    call    L134        ;(0x5a7)
    movwf   0x4e
    bcf     0xa,3
    goto    L133        ;(0x5be)
L134:
    movlw   0x5
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x50
    retlw   0x6f
    retlw   0x77
L216:
    retlw   0x65
    retlw   0x72
    retlw   0x20
    retlw   0x4f
    retlw   0x4e
    retlw   0x20
    retlw   0x50
    retlw   0x72
    retlw   0x65
    retlw   0x73
    retlw   0x73
    retlw   0x20
    retlw   0x5a
    retlw   0x45
    retlw   0x52
    retlw   0x4f
L133:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L135        ;(0x597)
L132:
    clrwdt
    bcf     0xa,3
    btfsc   0x6,3
    goto    L132        ;(0x5c4)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    movlw   0xc0
L258:
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L139:
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L136        ;(0x5fe)
    movf    0x50,W
    sublw   0x13
L259:
    bcf     0xa,3
    btfss   0x3,0
    goto    L137        ;(0x5f8)
    bcf     0xa,3
    call    L138        ;(0x5e0)
    movwf   0x4e
    bcf     0xa,3
    goto    L137        ;(0x5f8)
L138:
    movlw   0x5
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x5a
    retlw   0x65
    retlw   0x72
    retlw   0x6f
    retlw   0x69
    retlw   0x6e
    retlw   0x67
    retlw   0x20
    retlw   0x65
    retlw   0x6c
    retlw   0x65
    retlw   0x63
    retlw   0x74
    retlw   0x72
    retlw   0x6f
    retlw   0x64
    retlw   0x65
    retlw   0x2e
    retlw   0x2e
    retlw   0x2e
L137:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L139        ;(0x5d0)
L136:
    movlw   0x94
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L143:
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L140        ;(0x631)
    movf    0x50,W
    sublw   0x13
    bcf     0xa,3
    btfss   0x3,0
    goto    L141        ;(0x62b)
    bcf     0xa,3
    call    L142        ;(0x613)
    movwf   0x4e
    bcf     0xa,3
    goto    L141        ;(0x62b)
L142:
    movlw   0x6
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x53
    retlw   0x65
    retlw   0x74
    retlw   0x20
    retlw   0x44
    retlw   0x65
    retlw   0x70
    retlw   0x74
    retlw   0x68
    retlw   0x20
    retlw   0x43
    retlw   0x75
    retlw   0x74
    retlw   0x20
    retlw   0x44
    retlw   0x65
    retlw   0x70
    retlw   0x74
    retlw   0x68
    retlw   0x20
L141:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L143        ;(0x603)
L140:
    movlw   0xd4
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x20
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x2e
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    addwf   0x59,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    addwf   0x5a,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    addwf   0x58,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x22
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x20
    movwf   0x4e
    clrf    0x50
L145:
    clrwdt
    movlw   0xd
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L144        ;(0x663)
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L145        ;(0x657)
L144:
    bsf     0x6,1
    movlw   0x5
    clrf    0xa
    call    L50        ;(0x2e)
    bcf     0x6,2
L21:
    bcf     0x6,7
L146:
    movlw   0x2
    movwf   0x23
    movlw   0x8a
    clrf    0xa
    call    L18        ;(0x2f)
    movlw   0x5
    movwf   0x20
L25:
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    clrwdt
    bcf     0xa,3
    btfsc   0x5,3
L51:
    goto    L146        ;(0x669)
    movlw   0xc0
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
L39:
    bsf     0x6,1
    movlw   0xe8
    movwf   0x48
    movlw   0x3
    movwf   0x49
L261:
    movlw   0xc0
    movwf   0x4e
    bsf     0xa,3
L260:
    call    L21        ;(0x668)
    movlw   0x20
    movwf   0x4e
    clrf    0x50
L148:
    clrwdt
    movlw   0x14
    subwf   0x50,W
L262:
    bcf     0xa,3
    btfsc   0x3,0
    goto    L147        ;(0x694)
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L148        ;(0x688)
L147:
    movlw   0xdf
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
L263:
    clrf    0x50
L152:
    clrwdt
    movlw   0x7
L265:
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L149        ;(0x6ba)
L264:
    movf    0x50,W
    sublw   0x6
    bcf     0xa,3
    btfss   0x3,0
    goto    L150        ;(0x6b4)
    bcf     0xa,3
L266:
    call    L151        ;(0x6a9)
    movwf   0x4e
    bcf     0xa,3
L19:
    goto    L150        ;(0x6b4)
L151:
    movlw   0x6
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x77
L20:
    retlw   0x61
    retlw   0x69
    retlw   0x74
    retlw   0x69
    retlw   0x6e
    retlw   0x67
L150:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L152        ;(0x699)
L149:
    clrwdt
    bcf     0xa,3
    btfsc   0x6,3
    goto    L149        ;(0x6ba)
    bcf     0x6,2
    movlw   0x22
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
L153:
    movf    0x5,W
    movwf   0x4c
    movlw   0x18
    andwf   0x4c,W
    movwf   0x5e
    clrwdt
    movf    0x5e,W
    sublw   0x0
    bcf     0xa,3
    btfsc   0x3,2
    goto    L153        ;(0x6c3)
    clrwdt
    bcf     0xa,3
    btfsc   0x5,3
    goto    L154        ;(0x6e1)
    bcf     0x6,1
    movlw   0x1
    subwf   0x48,F
    movlw   0x0
    btfss   0x3,0
    addlw   0x1
    subwf   0x49,F
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    bcf     0xa,3
    goto    L155        ;(0x6f8)
L154:
    bcf     0x6,1
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    bsf     0x6,1
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    incf    0x48,F
    btfsc   0x3,2
    incf    0x49,F
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
L155:
    movf    0x48,W
    movwf   0x3a
    movf    0x49,W
    movwf   0x3b
    movf    0x48,W
    movwf   0x20
    movf    0x49,W
    movwf   0x21
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L156        ;(0x4e)
    bcf     0xa,3
    btfss   0x3,2
    goto    L157        ;(0x710)
    movf    0x4a,W
    subwf   0x48,W
    movwf   0x3a
    movf    0x4b,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x49,W
    movwf   0x3b
L157:
    bsf     0xa,3
    call    L120        ;(0x4b6)
    movf    0x3c,W
    movwf   0x20
    movf    0x3d,W
    movwf   0x21
    movf    0x41,W
    movwf   0x23
    movf    0x40,W
    clrf    0xa
    call    L156        ;(0x4e)
    bcf     0xa,3
    btfss   0x3,2
    goto    L153        ;(0x6c3)
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L18        ;(0x2f)
    clrf    0xa
    goto    L158        ;(0x4b5)
L52:
    movlw   0x1
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x80
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
L162:
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L159        ;(0x75c)
    movf    0x50,W
    sublw   0x13
    bcf     0xa,3
    btfss   0x3,0
    goto    L160        ;(0x756)
    bcf     0xa,3
    call    L161        ;(0x73e)
    movwf   0x4e
    bcf     0xa,3
    goto    L160        ;(0x756)
L161:
    movlw   0x7
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x4f
    retlw   0x50
    retlw   0x54
    retlw   0x20
    retlw   0x45
    retlw   0x44
    retlw   0x4d
    retlw   0x20
    retlw   0x45
    retlw   0x78
    retlw   0x74
    retlw   0x65
    retlw   0x6e
    retlw   0x64
    retlw   0x20
    retlw   0x52
    retlw   0x65
    retlw   0x61
    retlw   0x63
    retlw   0x68
L160:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L162        ;(0x72e)
L159:
    movlw   0xc2
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movf    0x40,W
    movwf   0x20
    movf    0x41,W
    movwf   0x21
    clrf    0x23
    movlw   0x0
    clrf    0xa
    call    L57        ;(0x4b)
    bcf     0xa,3
    btfss   0x3,2
    goto    L163        ;(0x799)
    clrf    0x50
L167:
    clrwdt
    movlw   0x11
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L164        ;(0x797)
    movf    0x50,W
    sublw   0x10
    bcf     0xa,3
    btfss   0x3,0
    goto    L165        ;(0x791)
    bcf     0xa,3
    call    L166        ;(0x77c)
    movwf   0x4e
    bcf     0xa,3
    goto    L165        ;(0x791)
L166:
    movlw   0x7
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x31
    retlw   0x20
    retlw   0x2d
    retlw   0x20
    retlw   0x53
    retlw   0x45
    retlw   0x54
    retlw   0x20
    retlw   0x43
    retlw   0x55
    retlw   0x54
    retlw   0x20
    retlw   0x44
    retlw   0x45
    retlw   0x50
    retlw   0x54
    retlw   0x48
L165:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L167        ;(0x76c)
L164:
    bsf     0xa,3
    goto    L168        ;(0x11)
L163:
    clrf    0x50
L172:
    clrwdt
    movlw   0xe
    subwf   0x50,W
    bcf     0xa,3
    btfsc   0x3,0
    goto    L169        ;(0x7c2)
    movf    0x50,W
    sublw   0xd
    bcf     0xa,3
    btfss   0x3,0
    goto    L170        ;(0x7bc)
    bcf     0xa,3
    call    L171        ;(0x7aa)
    movwf   0x4e
    bcf     0xa,3
    goto    L170        ;(0x7bc)
L171:
    movlw   0x7
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x31
    retlw   0x20
    retlw   0x2d
    retlw   0x20
    retlw   0x44
    retlw   0x45
    retlw   0x50
    retlw   0x54
    retlw   0x48
    retlw   0x20
    retlw   0x3d
    retlw   0x20
    retlw   0x30
    retlw   0x2e
L170:
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bcf     0xa,3
    btfss   0x3,2
    goto    L172        ;(0x79a)
L169:
    movf    0x40,W
    movwf   0x20
    movf    0x41,W
    movwf   0x21
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x59
    movlw   0x30
    addwf   0x59,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x59,W
    movwf   0x26
    clrf    0x27
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x46
    movf    0x25,W
    movwf   0x47
    movf    0x46,W
    subwf   0x40,W
    movwf   0x44
    movf    0x47,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x41,W
    movwf   0x45
    movf    0x44,W
    movwf   0x20
    movf    0x45,W
    movwf   0x21
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x5a
    movlw   0x30
    addwf   0x5a,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x5a,W
    movwf   0x26
    clrf    0x27
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x46
    movf    0x25,W
    movwf   0x47
    movf    0x46,W
    subwf   0x44,W
    movwf   0x42
    movf    0x47,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x45,W
    movwf   0x43
    movf    0x42,W
    movwf   0x58
    movlw   0x30
    addwf   0x58,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x22
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x96
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0xd
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L173        ;(0x3d)
    movf    0x50,W
    sublw   0xc
    bsf     0xa,3
    btfss   0x3,0
    goto    L174        ;(0x37)
    bsf     0xa,3
    call    L175        ;(0x26)
    movwf   0x4e
    bsf     0xa,3
    goto    L174        ;(0x37)
    movlw   0x8
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x32
    retlw   0x20
    retlw   0x2d
    retlw   0x20
    retlw   0x43
    retlw   0x55
    retlw   0x54
    retlw   0x20
    retlw   0x4e
    retlw   0x4f
    retlw   0x54
    retlw   0x43
    retlw   0x48
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L176        ;(0x16)
    movlw   0xd6
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0x11
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L177        ;(0x6d)
    movf    0x50,W
    sublw   0x10
    bsf     0xa,3
    btfss   0x3,0
    goto    L178        ;(0x67)
    bsf     0xa,3
    call    L179        ;(0x52)
    movwf   0x4e
    bsf     0xa,3
    goto    L178        ;(0x67)
    movlw   0x8
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x33
    retlw   0x20
    retlw   0x2d
    retlw   0x20
    retlw   0x4a
    retlw   0x4f
    retlw   0x47
    retlw   0x20
    retlw   0x45
    retlw   0x4c
    retlw   0x45
    retlw   0x43
    retlw   0x54
    retlw   0x52
    retlw   0x4f
    retlw   0x44
    retlw   0x45
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L11        ;(0x42)
    movlw   0xc2
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    bsf     0xa,3
    call    L39        ;(0x67c)
    movlw   0x1
    movwf   0x5c
    clrwdt
    bsf     0xa,3
    btfss   0x6,3
    goto    L180        ;(0xc0)
    clrwdt
    bsf     0xa,3
    btfsc   0x6,5
    goto    L181        ;(0x91)
    clrwdt
    bsf     0xa,3
    btfss   0x6,5
    goto    L69        ;(0x7d)
    clrwdt
    movlw   0x3
    subwf   0x5c,W
    bsf     0xa,3
    btfss   0x3,0
    goto    L182        ;(0x89)
    bsf     0xa,3
    goto    L183        ;(0xa9)
    clrwdt
    movf    0x5c,W
    sublw   0x2
    bsf     0xa,3
    btfsc   0x3,2
    goto    L184        ;(0xb5)
    bsf     0xa,3
    goto    L185        ;(0xaf)
    clrwdt
    bsf     0xa,3
    btfsc   0x6,4
    goto    L186        ;(0x75)
    clrwdt
    bsf     0xa,3
    btfss   0x6,4
    goto    L187        ;(0x95)
    clrwdt
    movlw   0x2
    subwf   0x5c,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L188        ;(0xa1)
    bsf     0xa,3
    goto    L184        ;(0xb5)
    clrwdt
    movf    0x5c,W
    sublw   0x2
    bsf     0xa,3
    btfsc   0x3,2
    goto    L183        ;(0xa9)
    bsf     0xa,3
    goto    L185        ;(0xaf)
    movlw   0x1
    movwf   0x5c
    movlw   0xc2
    movwf   0x4e
    bsf     0xa,3
    goto    L109        ;(0xb9)
    movlw   0x2
    movwf   0x5c
    movlw   0x96
    movwf   0x4e
    bsf     0xa,3
    goto    L109        ;(0xb9)
    movlw   0x3
    movwf   0x5c
    movlw   0xd6
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    bsf     0xa,3
    goto    L186        ;(0x75)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    bsf     0xa,3
    call    L51        ;(0x677)
    clrwdt
    movf    0x5c,W
    sublw   0x3
    bsf     0xa,3
    btfsc   0x3,2
    goto    L189        ;(0x1c6)
    clrwdt
    movf    0x5c,W
    sublw   0x2
    bsf     0xa,3
    btfsc   0x3,2
    goto    L190        ;(0x290)
    movlw   0x1
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0x10
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L191        ;(0x100)
    movf    0x50,W
    sublw   0xf
    bsf     0xa,3
    btfss   0x3,0
    goto    L192        ;(0xfa)
    bsf     0xa,3
    call    L193        ;(0xe6)
    movwf   0x4e
    bsf     0xa,3
    goto    L192        ;(0xfa)
    movlw   0x8
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x20
    retlw   0x20
    retlw   0x20
    retlw   0x53
    retlw   0x65
    retlw   0x74
    retlw   0x20
    retlw   0x43
    retlw   0x55
    retlw   0x54
    retlw   0x20
    retlw   0x44
    retlw   0x45
    retlw   0x50
    retlw   0x54
    retlw   0x48
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L194        ;(0xd6)
    movlw   0xc4
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0xc
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L195        ;(0x12b)
    movf    0x50,W
    sublw   0xb
    bsf     0xa,3
    btfss   0x3,0
    goto    L196        ;(0x125)
    bsf     0xa,3
    call    L197        ;(0x115)
    movwf   0x4e
    bsf     0xa,3
    goto    L196        ;(0x125)
    movlw   0x9
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x30
    retlw   0x2e
    retlw   0x30
    retlw   0x30
    retlw   0x30
    retlw   0x20
    retlw   0x69
    retlw   0x6e
    retlw   0x63
    retlw   0x68
    retlw   0x65
    retlw   0x73
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L198        ;(0x105)
    movlw   0xc6
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    bsf     0xa,3
    call    L39        ;(0x67c)
    movlw   0x1
    movwf   0x5c
    clrf    0x53
    clrwdt
    bsf     0xa,3
    btfsc   0x6,3
    goto    L199        ;(0x15f)
    clrwdt
    bsf     0xa,3
    btfss   0x6,3
    goto    L200        ;(0x138)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    movlw   0x14
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrwdt
    movlw   0x3
    subwf   0x5c,W
    bsf     0xa,3
    btfss   0x3,0
    goto    L201        ;(0x14d)
    movf    0x53,W
    movwf   0x55
    bsf     0xa,3
    goto    L202        ;(0x194)
    clrwdt
    movlw   0x2
    subwf   0x5c,W
    bsf     0xa,3
    btfss   0x3,0
    goto    L203        ;(0x15a)
    movf    0x53,W
    movwf   0x57
    movlw   0x3
    movwf   0x5c
    clrf    0x53
    bsf     0xa,3
    goto    L199        ;(0x15f)
    movf    0x53,W
    movwf   0x56
    movlw   0x2
    movwf   0x5c
    clrf    0x53
    clrwdt
    bsf     0xa,3
    btfsc   0x6,5
    goto    L204        ;(0x170)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    clrwdt
    movlw   0x1
    subwf   0x53,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L205        ;(0x181)
    movlw   0xa
    movwf   0x53
    bsf     0xa,3
    goto    L205        ;(0x181)
    clrwdt
    bsf     0xa,3
    btfsc   0x6,4
    goto    L27        ;(0x134)
    movlw   0xc8
    clrf    0xa
    call    L50        ;(0x2e)
    clrwdt
    movlw   0x9
    subwf   0x53,W
    bsf     0xa,3
    btfss   0x3,0
    goto    L206        ;(0x183)
    movlw   0xff
    movwf   0x53
    bsf     0xa,3
    goto    L206        ;(0x183)
    movlw   0x2
    subwf   0x53,F
    incf    0x53,F
    movlw   0xc5
    addwf   0x5c,W
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x30
    addwf   0x53,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x10
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    bsf     0xa,3
    goto    L27        ;(0x134)
    bsf     0xa,3
    call    L51        ;(0x677)
    movlw   0x3
    movwf   0x23
    movlw   0x20
    clrf    0xa
    call    L18        ;(0x2f)
    movf    0x56,W
    movwf   0x26
    clrf    0x27
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x57,W
    movwf   0x26
    clrf    0x27
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x44
    movf    0x25,W
    movwf   0x45
    movf    0x42,W
    addwf   0x44,W
    movwf   0x46
    movf    0x43,W
    btfsc   0x3,0
    addlw   0x1
    addwf   0x45,W
    movwf   0x47
    movf    0x55,W
    movwf   0x42
    clrf    0x43
    movf    0x46,W
    addwf   0x42,W
    movwf   0x40
    movf    0x47,W
    btfsc   0x3,0
    addlw   0x1
    addwf   0x43,W
    movwf   0x41
    clrf    0xa
    goto    L52        ;(0x725)
    movlw   0x1
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L18        ;(0x2f)
    bcf     0x6,7
    movlw   0x80
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x20
    movwf   0x4e
    clrf    0x50
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L207        ;(0x1e3)
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L208        ;(0x1d7)
    movlw   0x86
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0x8
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L209        ;(0x20f)
    movf    0x50,W
    sublw   0x7
    bsf     0xa,3
    btfss   0x3,0
    goto    L210        ;(0x209)
    bsf     0xa,3
    call    L211        ;(0x1f8)
    movwf   0x4e
    bsf     0xa,3
    goto    L210        ;(0x209)
    movlw   0xa
    movwf   0xa
    movf    0x50,W
    goto    L55        ;(0x200)
    org 0xa00
    addwf   0x2,F
    retlw   0x4a
    retlw   0x4f
    retlw   0x47
    retlw   0x20
    retlw   0x4d
    retlw   0x6f
    retlw   0x64
    retlw   0x65
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L212        ;(0x1e8)
    movlw   0xc2
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0xf
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L61        ;(0x23d)
    movf    0x50,W
    sublw   0xe
    bsf     0xa,3
    btfss   0x3,0
    goto    L213        ;(0x237)
    bsf     0xa,3
    call    L214        ;(0x224)
    movwf   0x4e
    bsf     0xa,3
    goto    L213        ;(0x237)
    movlw   0xa
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x44
    retlw   0x49
    retlw   0x53
    retlw   0x50
    retlw   0x4c
    retlw   0x41
    retlw   0x59
    retlw   0x20
    retlw   0x6f
    retlw   0x72
    retlw   0x20
    retlw   0x45
    retlw   0x58
    retlw   0x49
    retlw   0x54
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L215        ;(0x214)
    movlw   0xe6
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x22
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    bsf     0xa,3
    call    L216        ;(0x5ae)
    clrwdt
    bsf     0xa,3
    btfss   0x6,4
    goto    L217        ;(0x255)
    clrwdt
    bsf     0xa,3
    btfss   0x6,5
    goto    L218        ;(0x267)
    clrwdt
    bsf     0xa,3
    btfss   0x6,3
    goto    L219        ;(0x288)
    bsf     0xa,3
    goto    L220        ;(0x247)
    bcf     0x6,1
    decf    0x51,F
    clrwdt
    movlw   0x2
    subwf   0x51,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L221        ;(0x274)
    movlw   0x65
    movwf   0x51
    movlw   0x1
    subwf   0x48,F
    movlw   0x0
    btfss   0x3,0
    addlw   0x1
    subwf   0x49,F
    bsf     0xa,3
    goto    L221        ;(0x274)
    bsf     0x6,1
    incf    0x51,F
    clrwdt
    movlw   0xc9
    subwf   0x51,W
    bsf     0xa,3
    btfss   0x3,0
    goto    L221        ;(0x274)
    movlw   0x65
    movwf   0x51
    incf    0x48,F
    btfsc   0x3,2
    incf    0x49,F
    clrwdt
    bsf     0xa,3
    btfsc   0x6,6
    goto    L222        ;(0x27b)
    movlw   0x1
    clrf    0xa
    call    L50        ;(0x2e)
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    movlw   0x1
    movwf   0x21
    movlw   0x2c
    clrf    0xa
    call    L8        ;(0x3c)
    bsf     0xa,3
    goto    L220        ;(0x247)
    clrwdt
    bcf     0xa,3
    btfsc   0x6,6
    goto    L52        ;(0x725)
    bsf     0xa,3
    call    L216        ;(0x5ae)
    bsf     0xa,3
    goto    L220        ;(0x247)
    movlw   0x1
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L18        ;(0x2f)
    clrf    0x50
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L223        ;(0x2c8)
    movf    0x50,W
    sublw   0x13
    bsf     0xa,3
    btfss   0x3,0
    goto    L224        ;(0x2c2)
    bsf     0xa,3
    call    L225        ;(0x2aa)
    movwf   0x4e
    bsf     0xa,3
    goto    L224        ;(0x2c2)
    movlw   0xa
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x4f
    retlw   0x50
    retlw   0x54
    retlw   0x20
    retlw   0x41
    retlw   0x75
    retlw   0x74
    retlw   0x6f
    retlw   0x4e
    retlw   0x6f
    retlw   0x74
    retlw   0x63
    retlw   0x68
    retlw   0x20
    retlw   0x52
    retlw   0x65
    retlw   0x76
    retlw   0x36
    retlw   0x2e
    retlw   0x34
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L226        ;(0x29a)
    movlw   0xd4
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0x13
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L227        ;(0x2fa)
    movf    0x50,W
    sublw   0x12
    bsf     0xa,3
    btfss   0x3,0
    goto    L228        ;(0x2f4)
    bsf     0xa,3
    call    L229        ;(0x2dd)
    movwf   0x4e
    bsf     0xa,3
    goto    L228        ;(0x2f4)
    movlw   0xa
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x50
    retlw   0x6f
    retlw   0x77
    retlw   0x65
    retlw   0x72
    retlw   0x20
    retlw   0x4f
    retlw   0x4e
    retlw   0x20
    retlw   0x50
    retlw   0x72
    retlw   0x65
    retlw   0x73
    retlw   0x73
    retlw   0x20
    retlw   0x5a
    retlw   0x45
    retlw   0x52
    retlw   0x4f
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L230        ;(0x2cd)
    clrwdt
    bsf     0xa,3
    btfsc   0x6,3
    goto    L227        ;(0x2fa)
    movlw   0x3
    movwf   0x23
    movlw   0x20
    clrf    0xa
    call    L18        ;(0x2f)
    movlw   0xc0
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L231        ;(0x336)
    movf    0x50,W
    sublw   0x13
    bsf     0xa,3
    btfss   0x3,0
    goto    L232        ;(0x330)
    bsf     0xa,3
    call    L233        ;(0x318)
    movwf   0x4e
    bsf     0xa,3
    goto    L232        ;(0x330)
    movlw   0xb
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x5a
    retlw   0x65
    retlw   0x72
    retlw   0x6f
    retlw   0x69
    retlw   0x6e
    retlw   0x67
    retlw   0x20
    retlw   0x65
    retlw   0x6c
    retlw   0x65
    retlw   0x63
    retlw   0x74
    retlw   0x72
    retlw   0x6f
    retlw   0x64
    retlw   0x65
    retlw   0x2e
    retlw   0x2e
    retlw   0x2e
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L234        ;(0x308)
    movlw   0x94
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L235        ;(0x369)
    movf    0x50,W
    sublw   0x13
    bsf     0xa,3
    btfss   0x3,0
    goto    L236        ;(0x363)
    bsf     0xa,3
    call    L237        ;(0x34b)
    movwf   0x4e
    bsf     0xa,3
    goto    L236        ;(0x363)
    movlw   0xb
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x53
    retlw   0x65
    retlw   0x74
    retlw   0x20
    retlw   0x44
    retlw   0x65
    retlw   0x70
    retlw   0x74
    retlw   0x68
    retlw   0x20
    retlw   0x43
    retlw   0x75
    retlw   0x74
    retlw   0x20
    retlw   0x44
    retlw   0x65
    retlw   0x70
    retlw   0x74
    retlw   0x68
    retlw   0x20
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L238        ;(0x33b)
    movlw   0xd4
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x20
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x2e
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    addwf   0x59,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    addwf   0x5a,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    addwf   0x58,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x22
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x20
    movwf   0x4e
    clrf    0x50
    clrwdt
    movlw   0xd
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L239        ;(0x39b)
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L240        ;(0x38f)
    bsf     0x6,1
    movlw   0x5
    clrf    0xa
    call    L50        ;(0x2e)
    bcf     0x6,2
    bcf     0x6,7
    movlw   0x32
    clrf    0xa
    call    L50        ;(0x2e)
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    clrwdt
    bsf     0xa,3
    btfsc   0x5,3
    goto    L241        ;(0x3a1)
    movlw   0xc0
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    bsf     0x6,1
    movlw   0xe8
    movwf   0x48
    movlw   0x3
    movwf   0x49
    movlw   0xc0
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x20
    movwf   0x4e
    clrf    0x50
    clrwdt
    movlw   0x14
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L242        ;(0x3ca)
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L243        ;(0x3be)
    movlw   0xdf
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    clrf    0x50
    clrwdt
    movlw   0x7
    subwf   0x50,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L98        ;(0x3f0)
    movf    0x50,W
    sublw   0x6
    bsf     0xa,3
    btfss   0x3,0
    goto    L244        ;(0x3ea)
    bsf     0xa,3
    call    L245        ;(0x3df)
    movwf   0x4e
    bsf     0xa,3
    goto    L244        ;(0x3ea)
    movlw   0xb
    movwf   0xa
    movf    0x50,W
    addwf   0x2,F
    retlw   0x77
    retlw   0x61
    retlw   0x69
    retlw   0x74
    retlw   0x69
    retlw   0x6e
    retlw   0x67
    bsf     0xa,3
    call    L25        ;(0x670)
    incf    0x50,F
    bsf     0xa,3
    btfss   0x3,2
    goto    L246        ;(0x3cf)
    clrwdt
    bsf     0xa,3
    btfsc   0x6,3
    goto    L98        ;(0x3f0)
    bcf     0x6,2
    movlw   0xe5
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movlw   0x20
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x22
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x5,W
    movwf   0x4c
    movlw   0x18
    andwf   0x4c,W
    movwf   0x5e
    clrwdt
    movf    0x5e,W
    sublw   0x0
    bsf     0xa,3
    btfsc   0x3,2
    goto    L247        ;(0x401)
    clrwdt
    bsf     0xa,3
    btfsc   0x5,3
    goto    L248        ;(0x428)
    bcf     0x6,1
    decf    0x51,F
    clrwdt
    movlw   0x2
    subwf   0x51,W
    bsf     0xa,3
    btfsc   0x3,0
    goto    L249        ;(0x420)
    movlw   0x65
    movwf   0x51
    movlw   0x1
    subwf   0x48,F
    movlw   0x0
    btfss   0x3,0
    addlw   0x1
    subwf   0x49,F
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    bsf     0xa,3
    goto    L250        ;(0x448)
    bcf     0x6,1
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    bsf     0x6,1
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    incf    0x51,F
    clrwdt
    movlw   0xc9
    subwf   0x51,W
    bsf     0xa,3
    btfss   0x3,0
    goto    L251        ;(0x442)
    movlw   0x65
    movwf   0x51
    incf    0x48,F
    btfsc   0x3,2
    incf    0x49,F
    movlw   0x5
    movwf   0x20
    clrf    0x21
    movlw   0x0
    clrf    0xa
    call    L127        ;(0x1)
    movlw   0x6
    clrf    0xa
    call    L50        ;(0x2e)
    movf    0x48,W
    movwf   0x3a
    movf    0x49,W
    movwf   0x3b
    movf    0x48,W
    movwf   0x20
    movf    0x49,W
    movwf   0x21
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L156        ;(0x4e)
    bsf     0xa,3
    btfss   0x3,2
    goto    L252        ;(0x463)
    movf    0x4a,W
    subwf   0x48,W
    movwf   0x3a
    movf    0x4b,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x49,W
    movwf   0x3b
    clrwdt
    bsf     0xa,3
    btfsc   0x6,3
    goto    L253        ;(0x46b)
    bsf     0xa,3
    call    L216        ;(0x5ae)
    bsf     0xa,3
    goto    L254        ;(0x4a3)
    movf    0x3a,W
    movwf   0x26
    movf    0x3b,W
    movwf   0x27
    movlw   0x4
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x42,W
    movwf   0x20
    movf    0x43,W
    movwf   0x21
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x44
    movf    0x21,W
    movwf   0x45
    movf    0x3a,W
    movwf   0x26
    movf    0x3b,W
    movwf   0x27
    movlw   0x6
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x42,W
    movwf   0x20
    movf    0x43,W
    movwf   0x21
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x46
    movf    0x21,W
    movwf   0x47
    movf    0x44,W
    addwf   0x46,W
    movwf   0x3c
    movf    0x45,W
    btfsc   0x3,0
    addlw   0x1
    addwf   0x47,W
    movwf   0x3d
    movf    0x3c,W
    movwf   0x20
    movf    0x3d,W
    movwf   0x21
    movf    0x41,W
    movwf   0x23
    movf    0x40,W
    clrf    0xa
    call    L156        ;(0x4e)
    bsf     0xa,3
    btfss   0x3,2
    goto    L247        ;(0x401)
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L18        ;(0x2f)
    bsf     0xa,3
    goto    L255        ;(0x1d0)
    movlw   0xdf
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movf    0x48,W
    movwf   0x20
    movf    0x49,W
    movwf   0x21
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L156        ;(0x4e)
    bsf     0xa,3
    btfss   0x3,2
    goto    L256        ;(0x4d4)
    movf    0x4a,W
    subwf   0x48,W
    movwf   0x3a
    movf    0x4b,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x49,W
    movwf   0x3b
    movlw   0x20
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    bsf     0xa,3
    goto    L257        ;(0x4e0)
    movf    0x48,W
    subwf   0x4a,W
    movwf   0x3a
    movf    0x49,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x4b,W
    movwf   0x3b
    movlw   0x2d
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x2e
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x3a,W
    movwf   0x26
    movf    0x3b,W
    movwf   0x27
    movlw   0x8
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x42,W
    movwf   0x20
    movf    0x43,W
    movwf   0x21
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x44
    movf    0x21,W
    movwf   0x45
    movf    0x3a,W
    movwf   0x26
    movf    0x3b,W
    movwf   0x27
    movlw   0x9
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x42,W
    movwf   0x20
    movf    0x43,W
    movwf   0x21
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x46
    movf    0x21,W
    movwf   0x47
    movf    0x44,W
    addwf   0x46,W
    movwf   0x3e
    movf    0x45,W
    btfsc   0x3,0
    addlw   0x1
    addwf   0x47,W
    movwf   0x3f
    movf    0x3a,W
    addwf   0x3e,W
    movwf   0x3c
    movf    0x3b,W
    btfsc   0x3,0
    addlw   0x1
    addwf   0x3f,W
    movwf   0x3d
    movf    0x3c,W
    movwf   0x26
    movf    0x3d,W
    movwf   0x27
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x3c
    movf    0x25,W
    movwf   0x3d
    movf    0x3c,W
    movwf   0x20
    movf    0x3d,W
    movwf   0x21
    movlw   0x10
    movwf   0x22
    movlw   0x27
    movwf   0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x53
    movlw   0x30
    addwf   0x53,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x53,W
    movwf   0x26
    clrf    0x27
    movlw   0x10
    movwf   0x22
    movlw   0x27
    movwf   0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x42,W
    subwf   0x3c,W
    movwf   0x44
    movf    0x43,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x3d,W
    movwf   0x45
    movf    0x44,W
    movwf   0x20
    movf    0x45,W
    movwf   0x21
    movlw   0xe8
    movwf   0x22
    movlw   0x3
    movwf   0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x54
    movlw   0x30
    addwf   0x54,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x54,W
    movwf   0x26
    clrf    0x27
    movlw   0xe8
    movwf   0x22
    movlw   0x3
    movwf   0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x46
    movf    0x25,W
    movwf   0x47
    movf    0x46,W
    subwf   0x44,W
    movwf   0x42
    movf    0x47,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x45,W
    movwf   0x43
    movf    0x42,W
    movwf   0x20
    movf    0x43,W
    movwf   0x21
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x55
    movlw   0x30
    addwf   0x55,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x55,W
    movwf   0x26
    clrf    0x27
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x46
    movf    0x25,W
    movwf   0x47
    movf    0x46,W
    subwf   0x42,W
    movwf   0x44
    movf    0x47,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x43,W
    movwf   0x45
    movf    0x44,W
    movwf   0x20
    movf    0x45,W
    movwf   0x21
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x57
    movlw   0x30
    addwf   0x57,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    return
    movlw   0xdf
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    movf    0x48,W
    movwf   0x20
    movf    0x49,W
    movwf   0x21
    movlw   0x3
    movwf   0x23
    movlw   0xe8
    clrf    0xa
    call    L156        ;(0x4e)
    bsf     0xa,3
    btfss   0x3,2
    goto    L258        ;(0x5cc)
    movf    0x4a,W
    subwf   0x48,W
    movwf   0x3a
    movf    0x4b,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x49,W
    movwf   0x3b
    movlw   0x20
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    bsf     0xa,3
    goto    L259        ;(0x5d8)
    movf    0x48,W
    subwf   0x4a,W
    movwf   0x3a
    movf    0x49,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x4b,W
    movwf   0x3b
    movlw   0x2d
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x30
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movlw   0x2e
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x3a,W
    movwf   0x26
    movf    0x3b,W
    movwf   0x27
    movlw   0x4
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x42,W
    movwf   0x20
    movf    0x43,W
    movwf   0x21
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x44
    movf    0x21,W
    movwf   0x45
    movf    0x3a,W
    movwf   0x26
    movf    0x3b,W
    movwf   0x27
    movlw   0x6
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x42,W
    movwf   0x20
    movf    0x43,W
    movwf   0x21
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x46
    movf    0x21,W
    movwf   0x47
    movf    0x44,W
    addwf   0x46,W
    movwf   0x3e
    movf    0x45,W
    btfsc   0x3,0
    addlw   0x1
    addwf   0x47,W
    movwf   0x3f
    movf    0x3e,W
    movwf   0x3c
    movf    0x3f,W
    movwf   0x3d
    movf    0x3c,W
    movwf   0x20
    movf    0x3d,W
    movwf   0x21
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x53
    movlw   0x30
    addwf   0x53,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x53,W
    movwf   0x26
    clrf    0x27
    movlw   0x64
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x42
    movf    0x25,W
    movwf   0x43
    movf    0x42,W
    subwf   0x3c,W
    movwf   0x44
    movf    0x43,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x3d,W
    movwf   0x45
    movf    0x44,W
    movwf   0x20
    movf    0x45,W
    movwf   0x21
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L68        ;(0x61)
    movwf   0x54
    movlw   0x30
    addwf   0x54,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    movf    0x54,W
    movwf   0x26
    clrf    0x27
    movlw   0xa
    movwf   0x22
    clrf    0x23
    clrf    0xa
    call    L69        ;(0x7d)
    movwf   0x46
    movf    0x25,W
    movwf   0x47
    movf    0x46,W
    subwf   0x44,W
    movwf   0x42
    movf    0x47,W
    btfss   0x3,0
    addlw   0x1
    subwf   0x45,W
    movwf   0x43
    movf    0x42,W
    movwf   0x55
    movlw   0x30
    addwf   0x55,W
    movwf   0x4e
    bsf     0xa,3
    call    L25        ;(0x670)
    return
    movlw   0x1
    movwf   0x5b
    bsf     0xa,3
    call    L260        ;(0x684)
    movlw   0x4
    clrf    0xa
    call    L50        ;(0x2e)
    return
    clrf    0x5b
    bsf     0xa,3
    call    L260        ;(0x684)
    movlw   0x4
    clrf    0xa
    call    L50        ;(0x2e)
    return
    movlw   0xc
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    return
    movlw   0xd
    movwf   0x4e
    bsf     0xa,3
    call    L21        ;(0x668)
    return
    sleep
    bsf     0xa,3
    goto    L261        ;(0x681)
    movf    0x5b,W
    movwf   0x5d
    call    L262        ;(0x68b)
    movf    0x4e,W
    movwf   0x5d
    call    L262        ;(0x68b)
    return
    bcf     0xb,5
    bcf     0xb,7
    clrf    0x1
    clrwdt
    bsf     0x3,5
    movlw   0x58
    movwf   0x1
    bcf     0x3,5
    movlw   0x8
    movwf   0x52
    bcf     0x5,0
    clrf    0x1
    bcf     0xb,2
    btfss   0xb,2
    goto    L263        ;(0x698)
    bcf     0xb,2
    rlf     0x5d,F
    bcf     0x5,0
    btfsc   0x3,0
    bsf     0x5,0
    btfss   0xb,2
    goto    L264        ;(0x69f)
    bcf     0xb,2
    decfsz  0x52,F
    goto    L265        ;(0x69b)
    bsf     0x5,0
    btfss   0xb,2
    goto    L266        ;(0x6a5)
    return
    bsf     0x5,2
    return
    bcf     0x5,2
    return
    bsf     0x5,1
    return
    bcf     0x5,1
    return

; end of start
;--------------------------------------------------------------------------------------------------

    END
