;--------------------------------------------------------------------------------------------------
; Project:  OPT EDM Notch Cutter -- LCD PIC software
; Date:     2/29/12
; Revision: 1.0
;
; IMPORTANT: When programming the PIC in the notch cutter, turn the Electrode Current switch to
; Off and the Electrode Motion switch to Setup.
;
; Normally, the programming header for the LCD PIC is not installed on the board.  It can be
; installed in the Main PIC socket, programmed, and then moved to the LCD PIC socket.
;
; Overview:
;
; This program reads serial data sent by the Main PIC and displays it on the LCD.
;
; There are two PIC controllers on the board -- the Main PIC and the LCD PIC.  This code is
; for the LCD PIC.  The Main PIC sends data to the LCD PIC via a serial data line for display
; on the LCD.
;
;--------------------------------------------------------------------------------------------------
;
; Revision History:
;
; 1.0   Some code and concepts used from source code disassembled from hex object code version ?.? 
;       from original author.
;
;--------------------------------------------------------------------------------------------------
;
;