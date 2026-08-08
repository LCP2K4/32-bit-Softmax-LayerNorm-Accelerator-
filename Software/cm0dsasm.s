						PRESERVE8
                		THUMB

        				AREA	RESET, DATA, READONLY	  			; First 32 WORDS is VECTOR TABLE
        				EXPORT 	__Vectors
					
__Vectors		    	DCD		0x00003FFC
        				DCD		Reset_Handler
        				DCD		0  			
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD 	0
        				DCD		0
        				DCD		0
        				DCD 	0
        				DCD		0
        				
        				; External Interrupts
						        				
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
        				DCD		0
	AREA |.text|, CODE, READONLY



ACCER_CTRL_ADDR	   EQU 0x54000000
ACCER_MEM_ADDR     EQU 0x54000004
ACCER_MODE_ADDR    EQU 0x54000008
ACCER_ROW_ADDR     EQU 0x5400000C
ACCER_COL_ADDR     EQU 0x54000010

Reset_Handler   PROC
                GLOBAL Reset_Handler
                ENTRY
				BL  ACCER_INIT

Loop_Forever    B   Loop_Forever
                ENDP

ACCER_INIT PROC
		PUSH {LR}
		
		MOVS R0, #0x02
		BL	CONTROL
		
		MOVS R0, #0x00
		BL CONTROL
		
		MOVS R0, #0x00
		BL  MEM
		
		MOVS R0, #0x00
		BL  MODE
		
		MOVS R0, #0x20
		BL  ROW
		
		MOVS R0, #0x20
		BL  COL
		
		MOVS R0, #0x01
	    BL  CONTROL
		
		
		POP {PC}
		ENDP
		
CONTROL PROC
		PUSH {R1, LR}
		LDR R1, =ACCER_CTRL_ADDR
		STR R0, [R1]
		POP {R1, PC}
		ENDP

MEM		PROC
		PUSH {R1, LR}
		LDR R1, =ACCER_MEM_ADDR
		STR R0, [R1]
		POP {R1, PC}
		ENDP

MODE 	PROC
		PUSH {R1, LR}
		LDR R1, =ACCER_MODE_ADDR
		STR R0, [R1]
		POP {R1, PC}
		ENDP
			
ROW 	PROC
		PUSH {R1, LR}
		LDR R1, =ACCER_ROW_ADDR
		STR R0, [R1]
		POP {R1, PC}
		ENDP

COL 	PROC
		PUSH {R1, LR}
		LDR R1, =ACCER_COL_ADDR
		STR R0, [R1]
		POP {R1, PC}
		ENDP
        
		ALIGN 4
        END