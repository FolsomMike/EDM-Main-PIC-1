    bsf     STATUS,RP0      ; bank 1

    movwf   LCDScratch0     ; store character

    movf    LCDBufferPtr,W
    movwf   FSR             ; point to next buffer position

    movf    LCDScratch0,W   ; retrieve character

    movwf   INDF            ; store character in buffer

    incf    LCDBufferCnt,F  ; count characters placed in the buffer
    incf    LCDBufferPtr,F  ; point to next buffer position
    
    bcf     STATUS,RP0      ; bank 0


;wip mks - next is temporary, forces each character to print immediately, waiting until it is printed

; prepare the interrupt routine for printing

    bsf     STATUS,RP0      ; bank 1

    movlw   LCDBuffer0
    movwf   LCDBufferPtr
    bsf     LCDFlags,startBit
    bsf     LCDFlags,LCDBusy    ; set this bit last to make sure everything set up before interrupt

loopWBL1:                   ; loop until interrupt routine finished writing character

    btfsc   LCDFlags,LCDBusy
    goto    loopWBL1

    bcf     STATUS,RP0      ; bank 0

;end of wip

    return
