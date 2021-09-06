; ID1 208593970 ID2 312385594

.orig x3000

	LEA R0,FIRSTARRAY ; R0 holds the msg of printing first array
	PUTS
	LEA R1,ARRAY1 ; R1 points to the address of array1
	JSR FILL_ARRAY 

	LEA R0,SECONDARRAY ; R0 hold the msg of printing second array
	PUTS
	LEA R1,ARRAY2 ; R1 points to the address of array2
	JSR FILL_ARRAY	
	
	LEA R0,ARRAY2 ; R0 points to the first place in array2
	NOT R0,R0
	ADD R0,R0,#1 ; R0 <- (-R0)
	ADD R1,R1,R0 ; R1 hold the address of the last place in array2, R1 <- (R1-R0)
	AND R3,R3,#0 
	ADD R3,R3,R1 ; R3 holds the length of the array (in our case len of array1 = len of array2)

	LEA R0,ENTERMATRIX ; R0 holds the msg of printing matrix
	PUTS 
 	LD R0,NEWLINE 
	OUT

	LD R1,MATRIXADDRESS ; R1 holds the address of the matrix
	JSR FILL_ARRAY
	LD R0,MATRIXADDRESS ; R0 holds the address of the matrix 
	NOT R0,R0
	ADD R0,R0,#1 ; R0 <- (-R0) 
	ADD R2,R1,R0 ; R2 holds the length of rows (in this case rows=cols)
	AND R5,R5,#0
	ADD R5,R5,R2 ; R5 holds the length of rows (in this case rows=cols) 
	ADD R2,R2,#-1 ; R2-- counter
	BR LOOP_MATRIX
		
	LOOP_MATRIX ; loop for filling the matrix 
		JSR FILL_ARRAY 
		ADD R2,R2,#-1 
		BRz SUB5
		BR LOOP_MATRIX

 
SUB5 ; sub that comapres between the two arrays

	LEA R1,ARRAY1 ; R1 holds the address of array1
	LEA R2,ARRAY2 ; R2 holds the address of array2
	JSR IsSmaller
	AND R4,R4,#0
	ADD R4,R4,R0 ; R4 holds 0 or 1 

	LEA R0,ARRAYS 
	PUTS
	ADD R4,R4,#0 ; checking if R0 is 0 or 1
	BRz FLAG1_IsSmaller
	BRp FLAG2_IsSmaller

	FLAG1_IsSmaller ; array1>array2 or array1=array2 (lexographically)
		LEA R0,F
		PUTS
		LD R0,NEWLINE
		OUT
		BR SUB1

	FLAG2_IsSmaller ; array1<array2
		LEA R0,T
		PUTS
		LD R0,NEWLINE
		OUT
		BR SUB1

SUB1 ; sub that checks if matrix is symmetric

	LEA R0,SYMMETRIC
	PUTS
	
	LD R1,MATRIXADDRESS ; R1 points to the address of the matrix
	LD R0,MATRIXADDRESS ; R0 points to the address of the matrix
	ADD R2,R5,#0 ; R2 holds the number of rows
	JSR IsSymmetric
	ADD R0,R0,#0 ; R0 hold 0 or 1
	BRz FLAG1_IsSymmetric
	BRp FLAG2_IsSymmetric

	FLAG1_IsSymmetric ; the matrix is not symmetric (R0 holds 0)
		LEA R0,F
		PUTS
		LD R0,NEWLINE
		OUT
		BR SUB2

	FLAG2_IsSymmetric ; the matrix is symmetric (R0 holds 1)
		LEA R0,T
		PUTS
		LD R0,NEWLINE
		OUT
		BR SUB2

SUB2 ; sub that checks if the diagonal value is 0
	LEA R0,ISZERO
	PUTS

	AND R3,R3,#0 ; R3 holds the zero value that we want to check  
	LD R1,MATRIXADDRESS ; R1 holds the address of the matrix
	JSR DiagonalValue
	
	ADD R0,R0,#0 ; R0 holds 0 or 1
	BRz FLAG1_DiagonalValue
	BRp FLAG2_DiagonalValue

	FLAG1_DiagonalValue ; the diagonal value is not zero (R1=0)
		LEA R0,F
		PUTS
		LD R0,NEWLINE
		OUT
		BR SUB3

	FLAG2_DiagonalValue ; the diagonal value is zero (R0=0)
		LEA R0,T
		PUTS
		LD R0,NEWLINE
		OUT
		BR SUB3

SUB3 ; sub that checks if all the matrix values is positive

	LEA R0,ISNOTNEGATIVE
	PUTS

	LD R1,MATRIXADDRESS ; R1 holds the address of the matrix 
	JSR IsNonNegative

	ADD R0,R0,#0 ; R0 holds 0 or 1
	BRz FLAG1_IsNonNegative
	BRp FLAG2_IsNonNegative

	FLAG1_IsNonNegative ; the matrix has negative values (R0=0)
		LEA R0,F
		PUTS
		LD R0,NEWLINE
		OUT
		BR SUB4

	FLAG2_IsNonNegative ; the matrix has only positive values (R0=1)
		LEA R0,T
		PUTS
		LD R0,NEWLINE
		OUT
		BR SUB4

SUB4 ; sub that checks if triangle inequality holds to all values of the matrix
	LEA R0,TR
	PUTS

	LD R1,MATRIXADDRESS ; R1 holds the address of the matrix
	JSR TriangleInequalityHolds 

        Check_and_Print

		ADD R0,R0,#0 ; R0 holds 0 or 1
		BRz FLAG1_TRIANGLE
		BRp FLAG2_TRIANGLE

	FLAG1_TRIANGLE ; R0=0
		LEA R0,F
		PUTS
		LD R0,NEWLINE
		OUT
		BR FINISH

	FLAG2_TRIANGLE ; R0=1
		LEA R0,T 
		PUTS
		LD R0,NEWLINE
		OUT
		BR FINISH

FINISH
			
HALT
	NEWLINE .FILL #10
	ARRAY1 .BLKW #10 #0
	ARRAY2 .BLKW #10 #0
	MATRIXADDRESS .FILL MATRIX
	FIRSTARRAY .STRINGZ "Enter array1: "
	SECONDARRAY .STRINGZ "Enter array2: "
	ENTERMATRIX .STRINGZ "Enter a matrix: "
	ARRAYS .STRINGZ "array1 < array2: "
	TR .STRINGZ "The triangle-inequality holds: "
	T .STRINGZ "True!"
	F .STRINGZ "False!"
	SYMMETRIC .STRINGZ "The matrix is symmetric: "
	ISZERO .STRINGZ "The diagonal is all zeros: "
	ISNOTNEGATIVE .STRINGZ "The matrix is non-negative: "

;;;;;;;;

R0_SAVE_FILL_ARRAY .FILL #0
R2_SAVE_FILL_ARRAY .FILL #0
R3_SAVE_FILL_ARRAY .FILL #0
R4_SAVE_FILL_ARRAY .FILL #0
R5_SAVE_FILL_ARRAY .FILL #0
R6_SAVE_FILL_ARRAY .FILL #0
R7_SAVE_FILL_ARRAY .FILL #0	

FILL_ARRAY
	
	ST R0,R0_SAVE_FILL_ARRAY 
	ST R2,R2_SAVE_FILL_ARRAY
	ST R3,R3_SAVE_FILL_ARRAY
	ST R4,R4_SAVE_FILL_ARRAY
	ST R5,R5_SAVE_FILL_ARRAY
	ST R6,R6_SAVE_FILL_ARRAY
	ST R7,R7_SAVE_FILL_ARRAY

	LD R2,MINUS ; R2=45
	LD R3,SPACE ; R3=32
	LD R4,ENTER ; R4=10
	LD R5,ZERO ; R5=48

	LEA R6,HELP_ARRAY
	
	NOT R2,R2
	ADD R2,R2,#1 ; R2=-45

	NOT R3,R3
	ADD R3,R3,#1 ; R3=-32

	NOT R4,R4
	ADD R4,R4,#1 ; R4=-10

	NOT R5,R5
	ADD R5,R5,#1 ; R5=-48


	LOOP ; loop for input 

		GETC 
		OUT
		ADD R0,R0,R3 ; check if input is space
		BRz LOOP

		NOT R3,R3
		ADD R3,R3,#1
	
		ADD R0,R0,R3 ; R0 the original value
	
		NOT R3,R3
		ADD R3,R3,#1

		ADD R0,R0,R4 ; check if input is new line
		BRz RET_FILL_ARRAY

		NOT R4,R4
		ADD R4,R4,#1

		ADD R0,R0,R4 ; R0 the original value

		NOT R4,R4
		ADD R4,R4,#1

		ADD R0,R0,R2 ; check if input is minus 
		BRz COUNTER

		NOT R2,R2
		ADD R2,R2,#1

		ADD R0,R0,R2 ; R0 the original value
		
		NOT R2,R2
		ADD R2,R2,#1

		ADD R0,R0,R5
		STR R0,R6,#0 ; store the input in help array

		AND R2,R2,#0
		ADD R2,R2,#1 ; R2++
		BR LOOP2
		
		LOOP2 ; continuing with the input

			GETC 
			OUT
			ADD R0,R0,R3 ; check if input is space
			BRnp NOTENTER
			LEA R6,HELP_ARRAY ; R6 holds the address of the help array
			AND R4,R4,#0 ; R4=0
			BR ARRAY_TO_INT1

			NOTENTER ; the input is not space

				NOT R3,R3
				ADD R3,R3,#1

				ADD R0,R0,R3 ; R0 holds the original value

				NOT R3,R3
				ADD R3,R3,#1

				ADD R0,R0,R4 ; check if input is enter 
				BRnp DIGITS

				NOT R4,R4
				ADD R4,R4,#1

				ADD R0,R0,R4 ; R0 holds the original value 

				AND R4,R4,#0

				LEA R6,HELP_ARRAY ; R6 holds the address of the help array
				BR ARRAY_TO_INT2

			DIGITS ; check if the number is more than one digit
				NOT R4,R4
				ADD R4,R4,#1

				ADD R0,R0,R4 ; R0 holds the original value

				NOT R4,R4
				ADD R4,R4,#1
				
				ADD R6,R6,#1 ; R6++
				ADD R0,R0,R5  
				STR R0,R6,#0 ; store the input in R6
				ADD R2,R2,#1 ; R2++
				BR LOOP2
			
			ARRAY_TO_INT1

				LDR R0,R6,#0 ; load R6 in R0 
				ADD R4,R4,R0 ; R4=R0
				AND R3,R3,#0
				ADD R3,R3,#10 ; R3=10
				ADD R2,R2,#-1 ; r2--
				BRz ONEDIGIT1
				BR MOREDIGITS1


				MOREDIGITS1 ; the input is more than one digit
					AND R5,R5,#0
					ADD R5,R5,R4 ; R5=R4 (the first digit)
					ADD R6,R6,#1 ; R6++
					
					LOOP3
						ADD R3,R3,#-1 ; R3--
						BRz ARRAY_TO_INT1
						ADD R4,R4,R5 ; R4=R4+R5
						BR LOOP3
			
				ONEDIGIT1 ; the input is one digit
					STR R4,R1,#0 ; store the result in first place in the array
					ADD R1,R1,#1 ; R1++
					
					LD R2,MINUS ; R2=45
					LD R3,SPACE ; R3=32
					LD R4,ENTER ; R4=10
					LD R5,ZERO ; R5=48
				
					NOT R2,R2
					ADD R2,R2,#1 ; R2=-45

					NOT R3,R3
					ADD R3,R3,#1 ; R3=-32

					NOT R4,R4
					ADD R4,R4,#1 ; R4=-10

					NOT R5,R5
					ADD R5,R5,#1 ; R5=-48

					BR LOOP

			ARRAY_TO_INT2

				LDR R0,R6,#0 ; load the R6 in R0
				ADD R4,R4,R0 ; R4=R4+R0
				AND R3,R3,#0
				ADD R3,R3,#10 ; R3=10
				ADD R2,R2,#-1 ; R2--
				BRz ONEDIGIT2
				BR MOREDIGITS2


				MOREDIGITS2 ; the input is more than one digit
					AND R5,R5,#0
					ADD R5,R5,R4 ; R5=R4
					ADD R6,R6,#1 ; R6++
					
					LOOP4
						ADD R3,R3,#-1 ; R4=3--
						BRz ARRAY_TO_INT2
						ADD R4,R4,R5
						BR LOOP4
			
				ONEDIGIT2 ; the input is one digit

					STR R4,R1,#0 ; storing R4 in arary1 
					ADD R1,R1,#1 ; R1++
					
					LD R2,MINUS ; R2=45
					LD R3,SPACE ; R3=32
					LD R4,ENTER ; R4=10
					LD R5,ZERO ; R5=48
				
					NOT R2,R2
					ADD R2,R2,#1 ; R2=-45

					NOT R3,R3
					ADD R3,R3,#1 ; R3=-32

					NOT R4,R4
					ADD R4,R4,#1 ; R4=-10

					NOT R5,R5
					ADD R5,R5,#1 ; R5=-48

					BR RET_FILL_ARRAY
			
			COUNTER 
				AND R2,R2,#0
				BR NEG

			NEG ; the input is minus

				GETC 
				OUT
				ADD R0,R0,R3 ; check if R0 is space
				BRnp NOTENTER2 ; the input is not space
				LEA R6,HELP_ARRAY ; R6 holds the address of the help array
				AND R4,R4,#0 ; R4=0
				BR ARRAY_TO_INT3

				NOTENTER2 ; the input is not space, check if enter or not 
					NOT R3,R3
					ADD R3,R3,#1

					ADD R0,R0,R3 ; R0 holds the original value

					NOT R3,R3
					ADD R3,R3,#1

					ADD R0,R0,R4 ; check if input is enter
					BRnp DIGITS2

					NOT R4,R4
					ADD R4,R4,#1

					ADD R0,R0,R4 ; R0 holds the original value

					AND R4,R4,#0

					LEA R6,HELP_ARRAY
					BR ARRAY_TO_INT4

				DIGITS2 ; continuing to take inputs and calling NEG
					NOT R4,R4
					ADD R4,R4,#1

					ADD R0,R0,R4

					NOT R4,R4
					ADD R4,R4,#1
					
					ADD R0,R0,R5
					STR R0,R6,#0 ; store R0 in first place in help array
					ADD R6,R6,#1 ; R6++
					ADD R2,R2,#1 ; R2++
					BR NEG
			 
				ARRAY_TO_INT3 ; the input is space
					LDR R0,R6,#0 ; load R6 value to R0
					ADD R4,R4,R0
					AND R3,R3,#0
					ADD R3,R3,#10
					ADD R2,R2,#-1 ; R2-- (number of digits)
					BRz ONEDIGIT3
					BR MOREDIGITS3

				MOREDIGITS3
					AND R5,R5,#0
					ADD R5,R5,R4 
					ADD R6,R6,#1
					
					LOOP6 ; R4 <- R4*10
						ADD R3,R3,#-1
						BRz ARRAY_TO_INT3
						ADD R4,R4,R5
						BR LOOP6
			
				ONEDIGIT3 ; the input is one digit
					NOT R4,R4
					ADD R4,R4,#1 ; R4 is the input

					STR R4,R1,#0 ; store R4 in first place in the array
					ADD R1,R1,#1
						
					LD R2,MINUS ; R2=45
					LD R3,SPACE ; R3=32
					LD R4,ENTER ; R4=10
					LD R5,ZERO ; R5=48
	
					NOT R2,R2
					ADD R2,R2,#1 ; R2=-45

					NOT R3,R3
					ADD R3,R3,#1 ; R3=-32

					NOT R4,R4
					ADD R4,R4,#1 ; R4=-10

					NOT R5,R5
					ADD R5,R5,#1 ; R5=-48
					BR LOOP

				ARRAY_TO_INT4 ; the input is enter
					LDR R0,R6,#0 ; load value of R6 to R0
					ADD R4,R4,R0
					AND R3,R3,#0
					ADD R3,R3,#10
					ADD R2,R2,#-1 ; R2-- (number of digits)
					BRz ONEDIGIT4
					BR MOREDIGITS4


					MOREDIGITS4
						AND R5,R5,#0
						ADD R5,R5,R4
						ADD R6,R6,#1
				
						LOOP7
							ADD R3,R3,#-1
							BRz ARRAY_TO_INT4
							ADD R4,R4,R5 ; R4 <- R4*10
							BR LOOP7
			
					ONEDIGIT4
						NOT R4,R4
						ADD R4,R4,#1 ; R4 holds the negative value 
						STR R4,R1,#0 ; store R4 to first place in array1
						ADD R1,R1,#1 
								
						LD R2,MINUS ; R2=45
						LD R3,SPACE ; R3=32
						LD R4,ENTER ; R4=10
						LD R5,ZERO ; R5=48
								
						NOT R2,R2
						ADD R2,R2,#1 ; R2=-45

						NOT R3,R3
						ADD R3,R3,#1 ; R3=-32

						NOT R4,R4
						ADD R4,R4,#1 ; R4=-10

						NOT R5,R5
						ADD R5,R5,#1 ; R5=-48

						BR RET_FILL_ARRAY

RET_FILL_ARRAY

	LD R0,R0_SAVE_FILL_ARRAY
	LD R2,R2_SAVE_FILL_ARRAY
	LD R3,R3_SAVE_FILL_ARRAY
	LD R4,R4_SAVE_FILL_ARRAY
	LD R5,R5_SAVE_FILL_ARRAY
	LD R6,R6_SAVE_FILL_ARRAY
	LD R7,R7_SAVE_FILL_ARRAY

	
	RET
;;;;;;;;;

HELP_ARRAY .BLKW #5
SPACE .FILL #32
ENTER .FILL #10
ZERO .FILL #48
MINUS .FILL #45

;;;;;;;;

R1_SAVE_IsSmaller .FILL #0
R2_SAVE_IsSmaller .FILL #0
R3_SAVE_IsSmaller .FILL #0
R4_SAVE_IsSmaller .FILL #0
R5_SAVE_IsSmaller .FILL #0
R6_SAVE_IsSmaller .FILL #0
R7_SAVE_IsSmaller .FILL #0

IsSmaller
	ST R1,R1_SAVE_IsSmaller
	ST R2,R2_SAVE_IsSmaller
	ST R3,R3_SAVE_IsSmaller
	ST R4,R4_SAVE_IsSmaller
	ST R5,R5_SAVE_IsSmaller
	ST R6,R6_SAVE_IsSmaller
	ST R7,R7_SAVE_IsSmaller

	WHILE ; loop for comparing values

		LDR R5,R1,#0 ; R5 holds the first value in array1
		LDR R4,R2,#0 ; R4 holds the first value in array2
		NOT R4,R4
		ADD R4,R4,#1 ; R4 <- (-R4)

		ADD R5,R5,R4 ; R5=R5-R4 check if the value in array1 < the value in array2
		BRn SMALLER
		BRz SAME
		BRp NOTSMALLER

	SAME ; the values in the arrays are equal

		ADD R3,R3,#-1 ; R3-- 
		BRz NOTSMALLER ; we reached the end of the array
		ADD R1,R1,#1 ; R1++
		ADD R2,R2,#1 ; R2++
		BR WHILE

	SMALLER ; array1 < array2
		AND R0,R0,#0
		ADD R0,R0,#1 ; R0=1
		BR RET_IsSmaller		

	NOTSMALLER ; array1=array2 or array1>array2 (lexographically)
		AND R0,R0,#0 ; R0=0
		BR RET_IsSmaller
		
		
RET_IsSmaller
	
	LD R4,R4_SAVE_IsSmaller
	LD R5,R5_SAVE_IsSmaller
	LD R6,R6_SAVE_IsSmaller
	LD R7,R7_SAVE_IsSmaller
	
	RET
;;;;;;;;

R1_SAVE_IsSymmetric .FILL #0
R2_SAVE_IsSymmetric .FILL #0
R3_SAVE_IsSymmetric .FILL #0
R4_SAVE_IsSymmetric .FILL #0
R5_SAVE_IsSymmetric .FILL #0
R6_SAVE_IsSymmetric .FILL #0
R7_SAVE_IsSymmetric .FILL #0

IsSymmetric
	
	ST R1,R1_SAVE_IsSymmetric	
	ST R2,R2_SAVE_IsSymmetric
	ST R3,R3_SAVE_IsSymmetric
	ST R4,R4_SAVE_IsSymmetric
	ST R5,R5_SAVE_IsSymmetric
	ST R6,R6_SAVE_IsSymmetric
	ST R7,R7_SAVE_IsSymmetric
	
	AND R3,R3,#0
	ADD R3,R3,R2 ; R3=R2 (number of rows)
	
	AND R4,R4,#0
	ADD R4,R4,R2 ; R4=R2 (number of rows)
	
	LEA R6,HELP_MATRIX ; R6 holds the address of the help matrix

	FILL_SECOND_MATRIX ; filling the help matrix rows then coloumns
		LDR R5,R0,#0 ; load R0 to R5
		STR R5,R6,#0 ; store R5 in R6 (help matrix)
		ADD R6,R6,#1 ; R6++
		ADD R0,R0,R2 ; R0=R0+number of rows
		ADD R3,R3,#-1 ; R3--
		BRz WHILE_SECOND_MATRIX
		BR FILL_SECOND_MATRIX

		WHILE_SECOND_MATRIX ; continuing to fill the help matrix
			ADD R4,R4,#-1 ; R4--
			BRz LENGTH
			NOT R4,R4
			ADD R4,R4,#1
			ADD R0,R2,R4 ; R0=R2+R4 (filling rows first which means first (0,0) then (1,0) then (2,0) ...)
			ADD R0,R0,R1 
			NOT R4,R4	
			ADD R4,R4,#1
			ADD R4,R4,#0
			ADD R3,R2,#0 ; R3=R2 number of rows
			BR FILL_SECOND_MATRIX

	LENGTH ; length of the matrix (n*n) in this case rows*rows

		ADD R3,R2,#0
		ADD R4,R2,#0
		
		MULTIPLY
			ADD R3,R3,#-1
			BRz COMPARE
			ADD R4,R4,R2
			BR MULTIPLY 
									
	COMPARE ; compare between the two matrixes

		LEA R3,HELP_MATRIX ; R3 holds the address of the help matrix
			
		LOOP_COMPARE
			ADD R4,R4,#-1 ; R4--
			BRz SYMM
 
		 	LDR R5,R1,#0 ; load first value in array1 to R5
			LDR R6,R3,#0 ; load first value in array1 to R6
				
			NOT R6,R6
			ADD R6,R6,#1 ; R6 <- (-R6)
			
			ADD R1,R1,#1 ; R1++
			ADD R3,R3,#1 ; R3++
				
			ADD R5,R5,R6
			BRz LOOP_COMPARE ; the two values are equal
			BR NOT_SYMM

		SYMM ; the matrix is symmetric (R0=1)
			AND R0,R0,#0
			ADD R0,R0,#1
			BR RET_IsSymmetric

		NOT_SYMM ; the matrix is not symmetric (R0=0)
			AND R0,R0,#0
			BR RET_IsSymmetric

RET_IsSymmetric

	LD R1,R1_SAVE_IsSymmetric
	LD R2,R2_SAVE_IsSymmetric
	LD R3,R3_SAVE_IsSymmetric
	LD R4,R4_SAVE_IsSymmetric
	LD R5,R5_SAVE_IsSymmetric
	LD R6,R6_SAVE_IsSymmetric
	LD R7,R7_SAVE_IsSymmetric
	
	RET
;;;;;;;;;

HELP_MATRIX .BLKW #100

;;;;;;;;;

R1_SAVE_DiagonalValue .FILL #0
R2_SAVE_DiagonalValue .FILL #0
R3_SAVE_DiagonalValue .FILL #0
R4_SAVE_DiagonalValue .FILL #0
R5_SAVE_DiagonalValue .FILL #0
R6_SAVE_DiagonalValue .FILL #0
R7_SAVE_DiagonalValue .FILL #0
		
DiagonalValue

	ST R1,R1_SAVE_DiagonalValue
	ST R2,R2_SAVE_DiagonalValue
	ST R3,R3_SAVE_DiagonalValue
	ST R4,R4_SAVE_DiagonalValue
	ST R5,R5_SAVE_DiagonalValue
	ST R6,R6_SAVE_DiagonalValue
	ST R7,R7_SAVE_DiagonalValue

	ADD R6,R2,#0

	LOOP_DiagonalValue ; loop for checking if all the diagonal values are 0
		LDR R4,R1,#0 ; load first value in the matrix to E4
		ADD R4,R4,#0 ; 
		BRnp NOTSAME_DiagonalValue ; R4!=0
		ADD R1,R1,R2 ; continuing to check the diagonal 
		ADD R1,R1,#1 ; R1++
		ADD R6,R6,#-1 ; R6--
		BRz SAME_DiagonalValue
		BR LOOP_DiagonalValue
			
		NOTSAME_DiagonalValue ; the diagonal is not 0 (R0=0)
			AND R0,R0,#0
			BR RET_DiagonalValue

		SAME_DiagonalValue ; the diagonal is 0 (R0=1)
			AND R0,R0,#0
			ADD R0,R0,#1
			BR RET_DiagonalValue
RET_DiagonalValue

	LD R1,R1_SAVE_DiagonalValue
	LD R2,R2_SAVE_DiagonalValue
	LD R3,R3_SAVE_DiagonalValue
	LD R4,R4_SAVE_DiagonalValue
	LD R5,R5_SAVE_DiagonalValue
	LD R6,R6_SAVE_DiagonalValue
	LD R7,R7_SAVE_DiagonalValue
	
	RET

;;;;;;;;;

R1_SAVE_IsNonNegative .FILL #0
R2_SAVE_IsNonNegative .FILL #0
R3_SAVE_IsNonNegative .FILL #0
R4_SAVE_IsNonNegative .FILL #0
R5_SAVE_IsNonNegative .FILL #0
R6_SAVE_IsNonNegative .FILL #0
R7_SAVE_IsNonNegative .FILL #0

IsNonNegative
	ST R1,R1_SAVE_IsNonNegative
	ST R2,R2_SAVE_IsNonNegative
	ST R3,R3_SAVE_IsNonNegative
	ST R4,R4_SAVE_IsNonNegative
	ST R5,R5_SAVE_IsNonNegative
	ST R6,R6_SAVE_IsNonNegative
	ST R7,R7_SAVE_IsNonNegative

	AND R3,R3,#0
	ADD R4,R2,#0 ; R4=R2 number of rows
	
	MULT	
		ADD R3,R3,R2 ; R3 hold the length of the matrix (rows*rows)
		ADD R4,R4,#-1
		BRz CHECK_IF_POS
		BR MULT

	CHECK_IF_POS ; loop for checking if all matrix values are positive
		LDR R5,R1,#0 ; load first value in matrix to R5
		ADD R5,R5,#0 ; check if R5 is negative/positive
		BRn NEGATIVE

		ADD R3,R3,#-1 ; R3--
		BRz POSITIVE

		ADD R1,R1,#1 ; R1++
		BR CHECK_IF_POS
	
	POSITIVE ; all values are positive (R0=1)
		AND R0,R0,#0
		ADD R0,R0,#1
		BR RET_IsNonNegative

	NEGATIVE ; the matrix has negative values (R0=0)
		AND R0,R0,#0
		BR RET_IsNonNegative


RET_IsNonNegative
	
	LD R1,R1_SAVE_IsNonNegative
	LD R2,R2_SAVE_IsNonNegative
	LD R3,R3_SAVE_IsNonNegative
	LD R4,R4_SAVE_IsNonNegative
	LD R5,R5_SAVE_IsNonNegative
	LD R6,R6_SAVE_IsNonNegative
	LD R7,R7_SAVE_IsNonNegative
	
	RET
;;;;;;;;

TriangleInequalityHolds 

  ST R0,R0_SV
  ST R1,R1_SV  ; Matrix Pointer
  ST R2,R2_SV  ;Array row's number
  ST R3,R3_SV  ; i Index
  ST R4,R4_SV  ; j Index
  ST R5,R5_SV  ; k Index
  ST R6,R6_SV  ; Another Matrix pointer  
  ST R7,R7_SV
  LD R3,ZERO_0
  LD R4,ZERO_0
  LD R5,ZERO_0
  NOT R2,R2
  ADD R2,R2,#1
  ST R2,Neg_Rows_number  ; The negative Value of R2 (Row's Number)

  I_LooP 
        
        LD R4,ZERO_0    ; j=0
  	LD R2,Neg_Rows_number 
  	ADD R2,R2,R3 
        BRZP Check_R0   ; If i>=row's Number => check R0 and Print the suitable note
     
        

 J_LooP   
     	 LD R5,ZERO_0      ; k=0
   	 Check_If_Equal_To_i_Index
    	 ADD R2,R4,#0     
     	 ADD R0,R4,#0
     	 NOT R2,R2
     	 ADD R2,R2,#1 
     	 ADD R2,R2,R3      ; check if j=i 
     	 BRZ Increase_J_1  ; if j=i then j++
         Continue_J_1       
         ADD R4,R0,#0      
     	 BRNP Check_If_its_Bigger_than_Max_Index  ; check if j>=row's number
   	 
  
  Check_If_its_Bigger_than_Max_Index
         LD R2,Neg_Rows_number
         ADD R2,R2,R4
         BRZP I_LooP_Increase  ;if j>=row's number then i++ and change the values of j and k
         
      
 K_LooP
         
         ADD R5,R5,#0  
	 CHECK_IF_EQUAL_TO_J_OR_I
  	 ADD R2,R5,#0
  	 ADD R0,R5,#0
  	 NOT R2,R2
         ADD R2,R2,#1 
  	 ADD R2,R2,R4     ; check if k=j
	 BRZ Increase_K_1
         Continue_K_1
         ADD R5,R0,#0
	 BRNP Check_If_equal_to_i
	 

Check_If_equal_to_i
  	ADD R2,R5,#0
        NOT R2,R2
        ADD R2,R2,#1 
  	ADD R2,R2,R3    	          ; check if k=i 
	BRZ Increase_K_2
        Continue_K_2
        ADD R5,R0,#0
        ADD R2,R5,#0
        NOT R2,R2
        ADD R2,R2,#1 
        ADD R2,R2,R4  			  ;check if k++ = j 
        BRZ CHECK_IF_EQUAL_TO_J_OR_I
        BRP END_OF_K_CHECKING
        
        
END_OF_K_CHECKING
        LD R2,Neg_Rows_number     
  	ADD R2,R5,R2                        ; check if K >= Row's Number 
  	BRZP J_LooP_Increase                ; If (Yes) then j++     
  	BRN Search_for_triangle_inequality  ; If (No) then start searching for Triangle Inequality 
;;;;;;;;;;;;;;;;


Search_for_triangle_inequality 
 
;a[i,j]

  ADD R6,R1,#0   ; Another Matrix pointer
  LD R2,R2_SV    ; ROW'S Number
  ADD R6,R6,R4   ; ARR+J
  ADD R0,R3,#0
  JSR MUL
  ADD R6,R6,R0   ;ARR+J+(I*COLS)
  LDR R0,R6,#0
  ST R0,First_Val

;a[j,k]

  ADD R6,R1,#0
  ADD R6,R6,R5  ;ARR+k
  ADD R0,R4,#0
  JSR MUL
  ADD R6,R6,R0  ;ARR+k+(j*COLS)
  LDR R0,R6,#0
  ST R0,Sec_Val

;a[k,i]

  ADD R6,R1,#0    
  ADD R6,R6,R3     ;ARR+i
  ADD R0,R5,#0
  JSR MUL
  ADD R6,R6,R0     ;ARR+i+(k*COLS)
  LDR R0,R6,#0
  ST R0,Third_Val
  JSR TriangleInequality
  LD R3,Triangle_Result
  ADD R0,R3,#0
  LD R3,SAVE_i
  ADD R0,R0,#0
  BRZ Check_R0
  BRP K_Loop_Increase

;;;;;;;;;;;;

 Increase_J_1
	
	ADD R0,R0,#1
	BR Continue_J_1
  RET
;;;;;;;;;;;;
Increase_K_1
	
	ADD R0,R0,#1
        BR Continue_K_1
	
  RET
;;;;;;;;;;;;
Increase_K_2
	
	ADD R0,R0,#1
	BR Continue_K_2
  RET
;;;;;;;;;;;;
 I_LooP_Increase
 	
	ADD R3,R3,#1
 	BR I_LooP
;;;;;;;;;;;;
 J_LooP_Increase
	ADD R4,R4,#1
	BR J_LooP
;;;;;;;;;;;;
 K_Loop_Increase
	ADD R5,R5,#1
	BR K_LooP
;;;;;;;;;;;;
 Check_R0
	JSR Check_and_Print


 R7_Inc .FILL #0
 ZERO_0 .FILL #0
 ONE .FILL #1
 TWO .FILL #2
 Neg_Rows_number .FILL #0     
 First_Val .FILL #0
 Sec_Val .FILL #0
 Third_Val .FILL #0
 R0_SV   .FILL #0
 R1_SV   .FILL #0
 R2_SV   .FILL #0
 R3_SV   .FILL #0
 R4_SV   .FILL #0
 R5_SV   .FILL #0
 R6_SV   .FILL #0
 R7_SV   .FILL #0

;;;;;;;;;;;;


TriangleInequality ; R0+R1>=R2 , R1+R2>=R0 , R2+R0>=R1

				
		ST R7,R7_SAVE_TRIANGLE
		ST R0,R0_SAVE_TRIANGLE	
		ST R1,R1_SAVE_TRIANGLE
		ST R2,R2_SAVE_TRIANGLE
                ST R3,SAVE_i
                ST R4,R4_SAVE_TRIANGLE
		AND R3,R3,#0 ; initiating R3 to be 0
		AND R4,R4,#0 ; initiating R4 to be 0
                LD R0,First_Val
                LD R1,Sec_Val
                LD R2,Third_Val
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
        ST R3,Triangle_Result
	LD R0,R0_SAVE_TRIANGLE
	LD R1,R1_SAVE_TRIANGLE
	LD R2,R2_SAVE_TRIANGLE
        LD R3,SAVE_i
	LD R4,R4_SAVE_TRIANGLE
	LD R7,R7_SAVE_TRIANGLE

	RET

R0_SAVE_TRIANGLE .FILL #0
R1_SAVE_TRIANGLE .FILL #0
R2_SAVE_TRIANGLE .FILL #0
SAVE_i .FILL #0
R4_SAVE_TRIANGLE .FILL #0
R7_SAVE_TRIANGLE .FILL #0
Triangle_Result .FILL #0

;;;;;;;;;;;;
MUL
        
       ST R0,R0_SV 
       ST R2,R2_SV       
       ST R3,R3_SV 
       ST R7,R7_SV
       AND R3,R3,#0      ; R3 = Mul Result
       ADD R0,R0,#0
       BRZ Return 
       FOR
       ADD R2,R2,#0 
       BRZ Return
       ADD R3,R3,R0
       ADD R2,R2,#-1
       BRP FOR 
 Return
       ADD R0,R3,#0       
       LD R3,R3_SV
       LD R2,R2_SV     
       LD R7,R7_SV

  RET
;;;;;;;;;;;;;;

MATRIX .BLKW #100 #0

;;;;;;;;;;;;;;
.END	