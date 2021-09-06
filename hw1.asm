; ID1 312385594 ID2 208593970

.orig x3000

;;;;;;;;;;;;;;;;;;;;

R0_SAVE_MUL .FILL #0
R1_SAVE_MUL .FILL #0
R7_SAVE_MUL .FILL #0
	
Mul ; R2 = R0 * R1
		ST R7,R7_SAVE_MUL
		ST R0,R0_SAVE_MUL	
		ST R1,R1_SAVE_MUL
		
		AND R2,R2,#0 ; initiating R2 to zero
	
		ADD R1,R1,#0 
		BRz R1_ZERO_MUL ; checking if R1 is zero

		ADD R0,R0,#0
		BRz R0_ZERO_MUL ; checking if R1 is zero
		BRp R0_POS_MUL ; checking if R1 is positive
		BRn R0_NEG_MUL ; checking if R1 is negative

	R0_ZERO_MUL ; R0=0
		AND R2,R2,#0 ; R2=0
		BRz RetMul ; if R2=0 end program

	R1_ZERO_MUL ; R1=0 
		AND R2,R2,#0 ; R2=0
		BRz RetMul ; if R2=0 end program

	R0_POS_MUL ; R0 is positive
		ADD R2,R2,R1 ; R2=R2+R1
		ADD R0,R0,#-1 ; R0-- (to reach 0)
		BRp R0_POS_MUL ; do while R0 is positive
		BRz RetMul ; if R0=0 then end program 

	R0_NEG_MUL ; R0 is negative
		ADD R2,R2,R1 ; R2=R2+R1
		ADD R0,R0,#1 ; R0++ (to reach 0)
		BRn R0_NEG_MUL ; do while R0 is negative
		NOT R2,R2
		ADD R2,R2,#1 ; flip the sign of R2
		ADD R0,R0,#0 
		BRz RetMul ; if R0=0 then end program
	

RetMul 
	LD R0,R0_SAVE_MUL
	LD R1,R1_SAVE_MUL
	LD R7,R7_SAVE_MUL

	RET

;;;;;;;;;;;;;;;;;;;;

R0_SAVE_DIV .FILL #0
R1_SAVE_DIV .FILL #0
R7_SAVE_DIV .FILL #0

Div ; R2 = R0/R1 , R3 = R0 % R1

		ST R7,R7_SAVE_DIV
		ST R0,R0_SAVE_DIV	
		ST R1,R1_SAVE_DIV

		AND R2,R2,#0 ; initiating R2 to zero
		AND R3,R3,#0 ; initiating R3 to zero

		ADD R0,R0,#0
		BRp R0_POS_DIV ; checking if R0 is positive
		BRn R0_NEG_DIV ; checking if R0 is negative
		BRz R0_ZERO_DIV ; checking if R0 is zero

	R0_POS_DIV ; R0 is positive

		ADD R1,R1,#0
		BRp R1_NOT1 ; if R1 is positive then flip it to negative 
		BRn R0_POS_R1_NEG ; if negative then do what's in label R0 positive R1 negative
		BRz R1_ZERO_DIV ; if zero do what's in label R1 zero

	R1_NOT1 ; flip over R1 from positive to negative
		NOT R1,R1
		ADD R1,R1,#1
		BRn R0_R1_POS ; if R1 is negative do what's in label R0 R1 positive

	R0_NEG_DIV ; R0 is negative
		NOT R0,R0
		ADD R0,R0,#1 ; now R0 is positive
		ADD R1,R1,#0
		BRp R1_NOT2 ; if R1 is positive then flip it to negative
		BRn R0_R1_NEG ; if R1 is negative then do what's in label R0 R1 negative

	R1_NOT2 ; flip R1 from positive to negative
		NOT R1,R1
		ADD R1,R1,#1
		BRn R0_NEG_R1_POS ; now R1 is negative then do what's in label R0 negative R1 positive

	R0_ZERO_DIV	; R0=0
		ADD R2,R2,#0 ; R2=0
		ADD R3,R3,#0 ; R3=0
		BRz RetDiv

	R0_R1_POS ; R0 R1 are positive (input)
		ADD R0,R0,R1 ; R0=R0+R1 (in this case R1 is negative)
		BRzp R2_PLUS1 ; while R0>=0 R2++, R2 is the quotient
		NOT R1,R1 
		ADD R1,R1,#1 ; now R1 is positive
		ADD R3,R0,R1 ; R0 negative R1 positive so R3 is the remainder
		BRzp RetDiv

	R2_PLUS1 ; counter for the quotient
		ADD R2,R2,#1 ; R2++
		BRnzp R0_R1_POS

	R0_POS_R1_NEG ; R0 positive R1 negative (input)
		ADD R0,R0,R1 ; R0=R0+R1
		BRzp R2_PLUS2 ; while R0>=0 R2++, R2 is the quotient
		NOT R1,R1
		ADD R1,R1,#1 ; now R1 is positive
		ADD R3,R0,R1 ; R0 negative R1 positive so R3 is the remainder
		NOT R2,R2
		ADD R2,R2,#1 ; now R2 is negative
		BRnzp RetDiv

	R2_PLUS2 ; R2 is the quotient
		ADD R2,R2,#1 ; R2++
		BRnzp R0_POS_R1_NEG ; loop

	R0_NEG_R1_POS ; R0 negative R1 positive (input)
		ADD R0,R0,R1 ; R0=R0+R1
		BRzp R2_PLUS3 ; while R0>=0 R2++, R2 is the quotient
		NOT R1,R1
		ADD R1,R1,#1 ; now R1 is negative
		ADD R3,R0,R1 ; R0 negative R1 positive so R3 is the remainder
		NOT R2,R2
		ADD R2,R2,#1 ; now R2 is negative 
		BRnzp RetDiv

	R2_PLUS3 ; R2 is the quotient
		ADD R2,R2,#1 ; R2++
		BRnzp R0_NEG_R1_POS ; loop

	R0_R1_NEG ; R0 R1 negative (input)
		ADD R0,R0,R1 ; R0=R0+R1 
		BRzp R2_PLUS4 ; while R0>=0 R2++, R2 is the quotient
		NOT R1,R1
		ADD R1,R1,#1 ; now R1 is positive 
		ADD R3,R0,R1 ; R0 negative R1 positive so R3 is the remainder
		BRzp RetDiv

	R2_PLUS4 ; R2 is the quotient
		ADD R2,R2,#1 ; R2++
		BRnzp R0_R1_NEG ; loop

	R1_ZERO_DIV ; R1=0 (dividing by 0)
		ADD R2,R2,#-1 ; R2=-1
		ADD R3,R3,#-1 ; R3=-1

RetDiv
	LD R0,R0_SAVE_DIV
	LD R1,R1_SAVE_DIV
	LD R7,R7_SAVE_DIV

	RET

;;;;;;;;;;;;;;;;;;;;;;;;;

R0_SAVE_TRIANGLE .FILL #0
R1_SAVE_TRIANGLE .FILL #0
R2_SAVE_TRIANGLE .FILL #0
R7_SAVE_TRIANGLE .FILL #0

TriangleInequality ; R0+R1>=R2 , R1+R2>=R0 , R2+R0>=R1
		
		ST R7,R7_SAVE_TRIANGLE
		ST R0,R0_SAVE_TRIANGLE	
		ST R1,R1_SAVE_TRIANGLE
		ST R2,R2_SAVE_TRIANGLE

		AND R3,R3,#0 ; initiating R3 to be 0
		AND R4,R4,#0 ; initiating R4 to be 0

	TriangleInequality1

		ADD R4,R0,R1 ; R4=R0+R1
		NOT R2,R2
		ADD R2,R2,#1 ; flip the sign of R2
		ADD R4,R4,R2 ; R4=R4+R2 (R2 is negative) (check if R4-R2>0)
		BRzp TriangleInequality2 ; if R4-R2>=0 (first condition is true) 
		BRn RetTriangle ; else end loop (first condition is false)

	TriangleInequality2

		AND R4,R4,#0 ; initiating R4 to be 0 again for the second condition
		NOT R2,R2	
		ADD R2,R2,#1 ; flip the sign of R2 again for the second use
		ADD R4,R0,R2 ; R4=R0+R2 
		NOT R1,R1
		ADD R1,R1,#1 ; flip the sign of R1
		ADD R4,R4,R1 ; R4=R4+R1 (R1 is negative) (check if R4-R1>0) 
		BRzp TriangleInequality3 ; if R4-R1>=0 (second condition is true)
		BRn RetTriangle ; else end loop (second condition is false)
 
	TriangleInequality3

		AND R4,R4,#0 ; initiating R4 to be 0 again for the third condition
		NOT R1,R1
		ADD R1,R1,#1 ; flip the sign of R1 again for the third use
		ADD R4,R1,R2  ; R4=R1+R2
		NOT R0,R0  
		ADD R0,R0,#1 ; flip the sign of R0
		ADD R4,R4,R0 ; R4=R4+R0 (R0 is negative) (check if R4-R0>0)
		BRzp R3_1 ; if R4-R0>=0 (third condition is true). R3 indicated that triangle inequality exists
		BRn RetTriangle ; else end loop (third condition is false)

	R3_1
		ADD R3,R3,#1 ; R3=1 triangle inequality exists

RetTriangle

	LD R0,R0_SAVE_TRIANGLE
	LD R1,R1_SAVE_TRIANGLE
	LD R2,R2_SAVE_TRIANGLE
	LD R7,R7_SAVE_TRIANGLE

	RET

.END
