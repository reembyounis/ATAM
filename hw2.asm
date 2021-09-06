; ID1 208593970 ID2 312385594
.orig x3000
	
	LD R1,c
	LD R3,ZEROASCII
	LD R4,NINEASCII

	AND R5,R5,#0
	AND R6,R6,#0

	JSR INPUT
	ADD R5,R5,R2 ; R5 holds the first number     
	JSR INPUT
	ADD R6,R6,R2 ; R6 hold the second number

	AND R0,R0,#0
	ADD R0,R0,R5
	JSR Div1  ; print first number
	
	LEA R0,SPACE
	PUTS ; print space
	LEA R0,STAR
	PUTS ; print *
	LEA R0,SPACE
	PUTS ; print space

	AND R0,R0,#0
	ADD R0,R0,R6
	JSR Div1  ; print the second number
	
	LEA R0,SPACE
	PUTS ; print space
	LEA R0,EQUAL
	PUTS ; print =
	LEA R0,SPACE
	PUTS ; print space

	AND R0,R0,#0
	AND R1,R1,#0
	
	ADD R0,R0,R5 ; R0 IS THE FIRST NUMBER
	ADD R1,R1,R6 ; R1 IS THE SECOND NUMBER
	JSR Mul ; R2=R0*R1
	
	AND R0,R0,#0
	ADD R0,R0,R2 ; R0=R2
	JSR Div1 ; print the result

HALT
	INTEGER .STRINGZ "Enter an integer number: "
	c .FILL #10	
        STAR .STRINGZ "*"
        EQUAL .STRINGZ "="
	SPACE .STRINGZ " "
	ZEROASCII .FILL #48
	NINEASCII .FILL #57
;;;;;;;;;;

R0_SAVE_INPUT .FILL #0
R1_SAVE_INPUT .FILL #0
R3_SAVE_INPUT .FILL #0
R4_SAVE_INPUT .FILL #0
R5_SAVE_INPUT .FILL #0
R6_SAVE_INPUT .FILL #0
R7_SAVE_INPUT .FILL #0	

INPUT

	ST R0,R0_SAVE_INPUT 
	ST R1,R1_SAVE_INPUT
	ST R3,R3_SAVE_INPUT
	ST R4,R4_SAVE_INPUT
	ST R5,R5_SAVE_INPUT
	ST R6,R6_SAVE_INPUT
	ST R7,R7_SAVE_INPUT

	LEA R6,ARRAY ; R6 is array of len 6

	AND R5,R5,#0	
	ADD R5,R5,#6 ; counter R5=6
	NOT R5,R5
	ADD R5,R5,#1 ; R5=-6

	NOT R1,R1
	ADD R1,R1,#1 ; R1=-10

	LEA R0,INTEGER ; print the first msg
	PUTS
	

FIRSTLOOP
	GETC ; first input
	OUT	
	ADD R0,R0,R1
	BRz NO_INPUT

	NOT R1,R1
	ADD R1,R1,#1
	ADD R0,R0,R1
	NOT R1,R1
	ADD R1,R1,#1

	NOT R3,R3
	ADD R3,R3,#1 ; R3=-48 
	ADD R0,R0,R3 ; R0=R0-48
	ADD R0,R0,#3 ; checking if first input is minus
	BRz NEG 
	ADD R0,R0,#-3 
	BRn NOT_NUMBER1 ; R0 is not between 48 and 57 
	NOT R3,R3
	ADD R3,R3,#1 ; R3=48
	ADD R0,R0,R3 ; R0 the original input
	NOT R4,R4
	ADD R4,R4,#1
	ADD R0,R0,R4
	BRp NOT_NUMBER2
	NOT R4,R4
	ADD R4,R4,#1
	ADD R0,R0,R4
	STR R3,R6,#0 ; R6[0]<--R3=0 in case R0 is positive then first place in the array holds 0 (which means number is positive)
	ADD R6,R6,#1 ; R6++
	STR R0,R6,#0 ; R6[1]<--R0, R0 first input
	ADD R6,R6,#1 ; R6[2]
	ADD R5,R5,#2 ; counter=-4
	BR SECONDLOOP
	
NEG ; input is negative 
	NOT R3,R3
	ADD R3,R3,#1 ; R3=48
	ADD R0,R0,R3 ; R0=48
	ADD R0,R0,#-3 ; R0=45	
	STR R0,R6,#0 ; R6[0]<--R0="-" first place in the array holds minus (which means number is negative)	
	ADD R6,R6,#1 ; R6++
	ADD R5,R5,#1 ; counter=-5
	BR SECONDLOOP

	
SECONDLOOP
	GETC ; input
	OUT
	ADD R0,R0,R1 ; R0=R0-10
	BRz ARRAY_TO_INT

	ADD R5,R5,#0 ; in case R5>6 this means the number is overflowed
	BRz OVER

	NOT R1,R1
	ADD R1,R1,#1 ; R1=10
	ADD R0,R0,R1 ; R0 now is the original input
	NOT R1,R1
	ADD R1,R1,#1 ; R1=-10

	NOT R3,R3
	ADD R3,R3,#1 ; R3=-48
	ADD R0,R0,R3 ; R0=R0-48
	BRn NOT_NUMBER1
	
	NOT R3,R3
	ADD R3,R3,#1 ; R3=48
	ADD R0,R0,R3 ; R0 now is the original input
	
	NOT R4,R4
	ADD R4,R4,#1 ; R4=-57
	ADD R0,R0,R4 ; R0=R0-57
	BRp NOT_NUMBER2 
	NOT R4,R4
	ADD R4,R4,#1 ; R4=57
	ADD R0,R0,R4 ; R0 now is the original input

	STR R0,R6,#0 ; R6<--R0, store R0 in the array 
	ADD R6,R6,#1 ; R6++

	ADD R5,R5,#1 ; R5--
	BR SECONDLOOP

NOT_NUMBER1 ; continuing to take inputs untill enter
	GETC
	OUT
	ADD R0,R0,R1 ; R0=R0-10
	BRnp NOT_NUMBER1
	LEA R0,NOTANUMBER ; R0 the msg that input is not a number
	PUTS
	NOT R3,R3
	ADD R3,R3,#1 ; R3=48
	AND R5,R5,#0	
	ADD R5,R5,#6 ; counter R5=6
	NOT R5,R5
	ADD R5,R5,#1 ; R5=-6
	LEA R6,ARRAY ; loading the array into R6 
	BR FIRSTLOOP

NOT_NUMBER2 ; continue to take inputs until enter
	GETC
	OUT
	ADD R0,R0,R1 ; R0=R0-10
	BRnp NOT_NUMBER2
	LEA R0,NOTANUMBER ; R0 the msg that input is not a number
	PUTS	
	NOT R4,R4
	ADD R4,R4,#1 ; R4=57
	AND R5,R5,#0	
	ADD R5,R5,#6 ; R5=6
	NOT R5,R5
	ADD R5,R5,#1 ; R5=-6
	LEA R6,ARRAY ; R6 points to the first place in array
	BR FIRSTLOOP
	
	OVER ; continue to take inputs until enter
		GETC
		OUT
		ADD R0,R0,R1 ; R0=R0-10
		BRnp OVER 
		LEA R0,OVERFLOW ; R0 holds the msg that input is not a number 
		PUTS
		LEA R6,ARRAY ; R6 points to the first place in array	
		AND R5,R5,#0	
		ADD R5,R5,#6 ; R5=6
		NOT R5,R5
		ADD R5,R5,#1 ; R5=-6
		BR FIRSTLOOP ; back to first loop to take another input


NO_INPUT ; when the input is just enter
	LEA R0,NOINPUT ; R0 holds the msg that input is invalid
 	PUTS
	BR FIRSTLOOP ; back to first loop for valid input


ARRAY_TO_INT ; checking if the number we have in array 6 is overflow, if not printing it as an integer

	NOT R6,R6
	ADD R6,R6,#1 ; R6 holds the last address in the array (negative)
	LEA R7,ARRAY ; R7 points to the first place in array 
	ADD R5,R5,#0 ; if R5=6 then check if overflow which means number>32767 or number<-32768
	BRz CHECK_IF_OVER
	BRn R5NEG

	R5NEG
		ADD R5,R5,#6 ; R5 holds the length of the array
		NOT R5,R5
		ADD R5,R5,#1 
		BR POSORNEG


	CHECK_IF_OVER
		ADD R5,R5,#6 ; R5 holds the length of the array (in this case R5=6) 
		NOT R5,R5
		ADD R5,R5,#1 

		NOT R3,R3 
		ADD R3,R3,#1 ; R3=-48

		LDR R0,R7,#1 ; R0 holds the second char in the array 
		ADD R0,R0,R3 ; R0=R0-48
		ADD R0,R0,#-3 ; check if R0>3 which means overflow
		BRp OVER2
		BRz FIRST_IS_THREE
		NOT R3,R3
		ADD R3,R3,#1 ; R3=48
		BR POSORNEG

	FIRST_IS_THREE
		LDR R0,R7,#2 ; R0 holds the third char in the array
		ADD R0,R0,R3 ; R0=R0-48
		ADD R0,R0,#-2 ; check if R0>2 which means overflow
		BRp OVER2
		BRz SECOND_IS_TWO
		NOT R3,R3
		ADD R3,R3,#1 ; R3=48
		BR POSORNEG

	SECOND_IS_TWO
		LDR R0,R7,#3 ; R0 holds the fourth char in the array
		ADD R0,R0,R3 ; R0=R0-48
		ADD R0,R0,#-7 ; check if R0>7 which means overflow
		BRp OVER2
		BRz THIRD_IS_SEVEN
		NOT R3,R3
		ADD R3,R3,#1 ; R3=48
		BR POSORNEG

	THIRD_IS_SEVEN
		LDR R0,R7,#4 ; R0 holds the fifth char in the array
		ADD R0,R0,R3 ; R0=R0-48
		ADD R0,R0,#-6 ; check if R0>6 which means overflow
		BRp OVER2
		BRz FOURTH_IS_SIX
		NOT R3,R3
		ADD R3,R3,#1 ; R3=48 
		BR POSORNEG

	FOURTH_IS_SIX
		LDR R0,R7,#0 ; R0 hold "-" (for negative number) or 0 (for psitive number)
		ADD R0,R0,R3 ; check if num is positive or negative 
		BRz FOURTH_IS_SIX_POS
		BR FOURTH_IS_SIX_NEG

		FOURTH_IS_SIX_POS ; for the case number>32767
			LDR R0,R7,#5 ; R0 holds the sixth char in the array
			ADD R0,R0,R3
			ADD R0,R0,#-8 ; check if R0>=8 which means overflow
			BRzp OVER2 ; number>=32768
			NOT R3,R3
			ADD R3,R3,#1 ; R3=48
			BR POSORNEG

		FOURTH_IS_SIX_NEG ; for the case number<-32768
			LDR R0,R7,#5 ; R0 holds the sixth char in the array
			ADD R0,R0,R3
			ADD R0,R0,#-9 ; check if R0>=9 which means overflow
			BRzp OVER2 ; number<-32768
			NOT R3,R3
			ADD R3,R3,#1 ; R3=48
			BR POSORNEG
		

	OVER2 
		LEA R0,OVERFLOW ; R0 holds the msg that input is overflow 
		PUTS
		NOT R3,R3
		ADD R3,R3,#1 ; R3=-48
		LEA R6,ARRAY ; R6 points to the first place in the array 
		AND R5,R5,#0	
		ADD R5,R5,#6 ; R5=6
		NOT R5,R5
		ADD R5,R5,#1 ; R5=-6
		BR FIRSTLOOP

POSORNEG ; check if the number is negative or positive
	AND R1,R1,#0
	AND R2,R2,#0
	LDR R0,R7,#0 ; R0 hold the first char in the array which is "-" or 0
	ADD R5,R5,#1 ; R5 is negative, counter for the array
	NOT R3,R3
	ADD R3,R3,#1 ; R3=-48
	ADD R0,R0,R3 ; R0=R0-48
	BRz POS 
	BR NEGATIVE

POS ; the number is positive
	LDR R0,R7,#1 ; R0 holds the first number in the array (second char)
	ADD R0,R0,R3 ; R0=R0-48
	ADD R2,R2,R0 ; R2=R2+R0
	ADD R0,R2,#0 ; R0=R2
	ADD R7,R7,#1 ; R7++
	ADD R5,R5,#1 ; R5 is negative, counter for the array
	BRz RETINPUT 
	AND R1,R1,#0
	ADD R1,R1,#9 ; R1=9
	NOT R1,R1
	ADD R1,R1,#1 ; R1=-9
	BR MULBY10POS

MULBY10POS
	ADD R2,R2,R0 ; R2=R2+R0
	ADD R1,R1,#1 ; R1++ (R1 is negative)
	BRn MULBY10POS
	BR POS

NEGATIVE ; the number is positive
	LDR R0,R7,#1 ; R0 holds the first number in the array (second char)
	ADD R0,R0,R3 ; R0=R0-48
	ADD R2,R2,R0 ; R2=R2+R0
	ADD R0,R2,#0 ; R0=R2
	ADD R7,R7,#1 ; R7++
	ADD R5,R5,#1 ; R5 is negative, counter for the array
	BRz MINUSR2 
	AND R1,R1,#0
	ADD R1,R1,#9 ; R1=9
	NOT R1,R1
	ADD R1,R1,#1 ; R1=-9
	BR MULBY10NEG	

	
	MULBY10NEG
		ADD R2,R2,R0 ; R2=R2+R0
		ADD R1,R1,#1 ; R1++ (R1 is negative)
		BRn MULBY10NEG
		BR NEGATIVE

	MINUSR2
		NOT R2,R2
		ADD R2,R2,#1 ; R2 is negative
		BR RETINPUT

		
RETINPUT

	LD R0,R0_SAVE_INPUT
	LD R1,R1_SAVE_INPUT
	LD R3,R3_SAVE_INPUT
	LD R4,R4_SAVE_INPUT
	LD R5,R5_SAVE_INPUT
	LD R6,R6_SAVE_INPUT
	LD R7,R7_SAVE_INPUT
	
	ARRAY .BLKW #6
	OVERFLOW .STRINGZ "Error! Number overflowed! Please enter again: "
	NOTANUMBER .STRINGZ "Error! You didn't enter a number. Please enter again: "
	NOINPUT .STRINGZ "Invalid input! Please enter again: "
	
	RET
;;;;;;;;;;

	
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
;;;;;;;;
R0_SAVE_DIV .FILL #0
R1_SAVE_DIV .FILL #0
R2_SAVE_DIV .FILL #0
R3_SAVE_DIV .FILL #0
R4_SAVE_DIV .FILL #0
R5_SAVE_DIV .FILL #0
R6_SAVE_DIV .FILL #0
R7_SAVE_DIV .FILL #0

Div1 

	ST R0,R0_SAVE_DIV
	ST R1,R1_SAVE_DIV
	ST R2,R2_SAVE_DIV
	ST R3,R3_SAVE_DIV
	ST R4,R4_SAVE_DIV
	ST R5,R5_SAVE_DIV
	ST R6,R6_SAVE_DIV
	ST R7,R7_SAVE_DIV

	LEA R4,ARRAY2
	ADD R4,R4,#4        ; ADDING 4 WILL FILL THE ARRAY IN A REVERSE WAY
	AND R6,R6,#0        ; COUNT DIGIT'S NUMBER 
	AND R5,R5,#0
	ADD R0,R0,#0
	BRN NEG_NUM


Div ; R2 = R0/R1 , R3 = R0 % R1

		AND R2,R2,#0 ; initiating R2 to zero
		AND R3,R3,#0 ; initiating R3 to zero
		AND R1,R1,#0
		ADD R1,R1,#10

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
	ADD R6,R6,#1     ; COUNTER++
        STR R3,R4,#0     ; STORE THE FIRST NUMBER IN THE LAST PLACE 
        ADD R4,R4,#-1    
        ADD R0,R2,#0     ; R0 = R0/10
        BRZ PRINT        ; IF R0=0 THEN STOP THE DIVISION PROCESS AND Print the whole number
        BR Div

PRINT	
	ADD R5,R5,#0
	BRP PRINT_MINUS

PRINT_THE_POSITIVE_VALUE
	LD R2,DECIMAL ; R2=48
	LEA R4,ARRAY2              
	ADD R4,R4,#4 ; R4 POINTS TO THE LAST PLACE IN THE ARRAY
	ADD R3,R6,#0 ; R3=-R6
	NOT R3,R3
	ADD R3,R3,#1
	ADD R4,R4,R3             
	ADD R4,R4,#1 ;R4= R4-R3+1 , R4 POINTS TO THE FISRT DIGIT OF THE NUMBER

FOR ; PRINT LOOP
	LDR R0,R4,#0
	ADD R0,R0,R2
	OUT
	ADD R4,R4,#1
	ADD R6,R6,#-1
	BRP FOR
        

RETPRINT

	LD R0,R0_SAVE_DIV
	LD R1,R1_SAVE_DIV
	LD R2,R2_SAVE_DIV
	LD R3,R3_SAVE_DIV
	LD R4,R4_SAVE_DIV
	LD R5,R5_SAVE_DIV
	LD R6,R6_SAVE_DIV
	LD R7,R7_SAVE_DIV
	
	ARRAY2 .BLKW #5
	DECIMAL .FILL #48
	MINUS .STRINGZ "-" 
RET

PRINT_MINUS
	LEA R0,MINUS
	PUTS
	BR PRINT_THE_POSITIVE_VALUE

NEG_NUM  
	ADD R5,R5,#1
	NOT R0,R0
	ADD R0,R0,#1
        BR Div

;;;;;;;;;;
.END