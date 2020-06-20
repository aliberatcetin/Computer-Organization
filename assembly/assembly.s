    .data
input_palindrome_string : .space 100
first_matrix_start_address : .space 1000
second_matrix_start_address : .space 1000
message : .asciiz "Welcome to our MIPS project!\nMain Menu:\n1. Square Root Approximate\n2. Matrix Multiplication\n3. Palindrome\n4. Exit\nPlease select an option: "
byMessage : .asciiz "Program ends. Bye :)"
not_palindrome : .asciiz " is not palindrome.\n"
is_palindrome  : .asciiz " is palindrome.\n"
palindrome_input_text : .asciiz "Enter an input string: "
break_line : .asciiz "\n"
double_break_line : .asciiz "\n\n"
multiplication_matrix : .asciiz "\nMultiplication Matrix : \n"
space : .asciiz " "
square_input_text : .asciiz "Enter the number of iteration for the series: "
first_matrix_input_text : .asciiz "Enter the first matrix : "
second_matrix_input_text : .asciiz "Enter the second matrix : "
first_dimension_input_text : .asciiz "Enter the first dimension of first matrix : "
second_dimension_input_text : .asciiz "Enter the second dimension of first matrix : "
char_a : .asciiz "a: "
char_b : .asciiz "b: "

    .text
    .globl main



matrix_mul: #(a0,a1,a2,a3), first_matrix[],second_matrix[],dimension1,dimension2
    
    move $t0,$a0#store arguments into temp registers
    move $t1,$a1
    move $t2,$a2
    move $t3,$a3
    

    li $t4,0 # i
    li $t7,0 # blank character counter for first matrix
    first_matrix_length_loop:# finds first matrix length by counting spaces to use for efficient memory allocation
        add $t5,$t0,$t4 # t1 = &first_matrix[i]
        lbu $t6,($t5)   # first_matrix[i]

        addi $t4,$t4,1   # i = i+1
        
        beq $t6,32,increment_first_matrix_space_count # increment matrix length by one
        
        control_first_matrix_length_loop: 
            bne $t6,10,first_matrix_length_loop #if t6='|n' it means end of input-matrix string
            j end_first_matrix_length_loop

    increment_first_matrix_space_count:
            addi $t7,$t7,1 # increment number count
            j control_first_matrix_length_loop # loop back
    
    end_first_matrix_length_loop:
        addi $t7,$t7,1 # "1 2 3" has 2 spaces but 3 numbers. Finally increment by one.

    li $t4,0 # i
    li $t8,0 # blank character counter for second matrix
    second_matrix_length_loop:# finds second matrix length by counting spaces to use for efficient memory allocation
        add $t5,$t1,$t4 # t1 = &second_matrix[i]
        lbu $t6,($t5)   # second_matrix[i]

        addi $t4,$t4,1   # i = i+1
        
        beq $t6,32,increment_second_matrix_space_count

        control_second_matrix_length_loop:
            bne $t6,10,second_matrix_length_loop
            j end_second_matrix_length_loop
    
    increment_second_matrix_space_count:
        addi $t8,$t8,1 # increment number count
        j control_second_matrix_length_loop # loop back

    end_second_matrix_length_loop:
        addi $t8,$t8,1 # "1 2 3" has 2 spaces but 3 numbers. Finally increment by one.
    

    #$t7 = length of first matrix
    #$t8 = length of second matrix

    div $s3,$t8,$t3 # calculating K = second_matrix_length / N


    sll $a0,$t7,2 # number of bytes for N integer
    li $v0,9 #malloc syscall trap
    syscall
    move $a2,$v0  #a2 = starting address of first integer array first_matrix[]

    sll $a0,$t8,2 # number of bytes for N integer
    li $v0,9 #malloc syscall trap
    syscall
    move $a3,$v0 #a3 = starting addres of second integer array second_matrix[]

    li $t4,0 #i
    li $t5,0 #current number
    li $t7,10#decimal coefficient
    li $s0,0 #counter for first integer matrix
    fill_first_matrix_loop:
        add $t6,$t0,$t4 # t1 = &first_input_matrix[i]
        lbu $t6,($t6)   # first_input_matrix[i]

        
        beq $t6,32,add_to_first_integer_matrix # if t6=' ' add current integer to the integer matrix
        beq $t6,10,add_to_first_integer_matrix # if t6='\n' it means last integer, also add current integer to the integer matrix

    
        mult	$t5, $t7			# current_number * 10
        mflo	$t5					# current_number = current_number * 10
        
        addi	$t8, $t6, -48			# $t8(new digit) = $t6 - 48 char to int
    	add		$t5, $t5, $t8		# $t5 = $t5 + $t8 adds new digit to the current number

    
        control_fill_first_matrix_loop:
            addi $t4,$t4,1 # i=i+1
            bne $t6,10,fill_first_matrix_loop # if current digit(character) is not '\n' loop back
            j end_fill_first_matrix_loop


    add_to_first_integer_matrix:   
        sll $t9,$s0,2 # $t9 = i
        add $t9,$a2,$t9 # $t9 = &first_matrix[i]
        sw $t5,($t9)    # store $t5 into $t9(address of i'th element)
        
        addi $s0,$s0,1 # increment first_matrix index for the next number

        li $t5,0 # clear $t5 for the calculation of next number
        j control_fill_first_matrix_loop #control filling loop

    end_fill_first_matrix_loop:

    li $t4,0 #i
    li $t5,0 #current number
    li $t7,10#decimal coefficient
    li $s0,0 #counter for second integer matrix
    fill_second_matrix_loop:
        add $t6,$t1,$t4 # t1 = &second_input_matrix[i]
        lbu $t6,($t6)   # second_input_matrix[i]

        
        beq $t6,32,add_to_second_integer_matrix # if t6=' ' add current integer to the integer matrix
        beq $t6,10,add_to_second_integer_matrix # if t6='\n' it means last integer, also add current integer to the integer matrix

    
        mult	$t5, $t7			# current_number * 10
        mflo	$t5					# current_number = current_number * 10
        
        addi	$t8, $t6, -48			# $t8(new digit) = $t6 - 48 char to int
    	add		$t5, $t5, $t8		# $t5 = $t5 + $t8 adds new digit to the current number

    
        control_fill_second_matrix_loop:
            addi $t4,$t4,1 # i=i+1
            bne $t6,10,fill_second_matrix_loop # if current digit(character) is not '\n' loop back
            j end_fill_second_matrix_loop


    add_to_second_integer_matrix:   
        sll $t9,$s0,2 # $t9 = i
        add $t9,$a3,$t9 # $t9 = &second_matrix[i]
        sw $t5,($t9)    # store $t5 into $t9(address of i'th element)
        
        addi $s0,$s0,1 # increment second_matrix index for the next number

        li $t5,0 # clear $t5 for the calculation of next number
        j control_fill_second_matrix_loop #control filling loop

    end_fill_second_matrix_loop:

    #$a2 is first_matrix
    #$a3 is second_matrix from now on
    #t2 m
    #t3 n
    #s3 k
    li $t4,0  #a 
    li $t5,0  #b
    li $t6,0  #c
    
    la $a0,multiplication_matrix
    li $v0,4
    syscall
    a_to_m_loop:
        li $t5,0 #clear b
        b_to_k_loop:
            li $t6,0 #clear c
            li $t9,0 #clear sum
            c_to_n_loop:
                mult	$t4, $t3			# a*n
                mflo	$t8					# $t8 = a*n
                add $t8,$t8,$t6             # $t8 = $t8 + c
                sll $t8,$t8,2               # $t8 = 4*$t8 number of bytes required to shift to access [a][c]
                
                add $t8,$a2,$t8             # $t8 = &first_matrix[a][c]
                lw $t8,($t8)                # $t8 = first_matrix[a][c]

                mult	$t6, $s3			# c*k
                mflo	$t7					# $t7 = c*k
                add $t7,$t7,$t5             # $t7 = $t7 + b
                sll $t7,$t7,2               # $t7 = 4*$t7 number of bytes required to shift to access [c][b]

                add $t7,$a3,$t7             # $t7 = &second_matrix[c][b]
                lw $t7,($t7)
                
                mult	$t7, $t8			# $t7 * $81 = Hi and Lo registers
                mflo	$t7					# copy 7o to $t2
                
                add $t9,$t9,$t7

            addi $t6,$t6,1 # c = c + 1
            bne $t6,$t3,c_to_n_loop

            li $v0,1 
            move $a0,$t9 #result for an index
            syscall

        la $a0,space
        li $v0,4
        syscall

        addi $t5,$t5,1 # b = b + 1
        bne $s3,$t5,b_to_k_loop
        
        la $a0,break_line
        li $v0,4
        syscall

    addi $t4,$t4,1 # a = a + 1
    bne $t2,$t4,a_to_m_loop

    la $a0,break_line
    li $v0,4
    syscall
    jr $ra


palindrome: #(str[])
    move $t0,$a0 #store string start address

    li $t2,0 #i
    lower_case_loop:
        add $t4,$t0,$t2 # t4=&str[i] 
        lbu $a0, ($t4)  # a0 = str[i]

        li $t7,64 #upper letter ascii character lower bound
        slti $t5,$a0,91 # if ascii < 91 t5 = 1
        slt $t6,$t7,$a0 # if ascii>=65 t6 = 1
        beq $t5,$t6,lower_case #if character is uppercase
        
        loop_contrrol:
            beq $a0,10,end_lower_case_loop #if character is '\n' enter
        
        add $t2,$t2,1 # i=i+1
        j lower_case_loop #loop back

    
    lower_case: 
        addi $a0,$a0,32 # a0 = lowercase(a0)
        sb $a0,($t4)    # str[i] = a0
        j loop_contrrol

    end_lower_case_loop:

    li $t8,0        # '\0' ascii
    add $t9,$t2,$t0 # adress of last character of the input string
    sb $t8,($t9)    # str[lastCharacterIndex] = '\0'


    srl $t3, $t2 , 1 #string middle element index
    sub $t3,$t3,1  
    move $t6,$t3   #t6=t3 popping start address
    andi $t4,$t2,1 #strlength_even_or_odd = str_length % 2
   
    beq $t4,1 odd  #t4 = isLengthOdd(strlength_even_or_odd)

    even:
        addi $t6,$t6,1 #str comparing start addrees +1
        j palindrome_check_loop
    
    odd:
        addi $t6,$t6,2 # str comparing start address +2

    palindrome_check_loop:

        add $t4,$t0,$t3 # t4 = &str[middle to start] #lower part
        add $t5,$t0,$t6 # t5 = &str[middle to end]   #upper part

        lbu $a0,($t4)   # a0 = str[midle to start]
        lbu $t2,($t5)   # t2 = str[middle to end] iterate-str
        
        add $t6,$t6,1   # decrement index of lower port
        sub $t3,$t3,1   # increment index of upper part
        
        bne $a0,$t2,L_not_palindrome # if a0!=t2

        slt $t8,$t3,$zero # if t3 >= 0, t8=0
        beq $t8,$zero,palindrome_check_loop # if t8=1, break
       

    L_is_palindrome:
        la $t1,is_palindrome # print is palindrome string
        j end_palindrome_loop

    L_not_palindrome:
        la $t1,not_palindrome #print not palindrome string

    end_palindrome_loop:
        li $v0,4
        la $a0, break_line # puts \n
        syscall

        move $a0,$t0
        syscall

        move $a0,$t1
        syscall

        la $a0, break_line # puts \n
        syscall
        jr $ra
    
        

square_root: #(n)
    li $t0,1 #a
    li $t1,1 #b
    move $t2,$a0 #store argument into $t2
    
    sll $a0,$a0,2 #4 bytes for each integer

    li $v0 9 #malloc sys trap
    syscall
    move $t3,$v0 #store first array's start adress(a), a[]

    li $v0 9 #malloc sys trap
    syscall
    move $t4,$v0 #store second array's start address(b) b[]

    li $t5,0 # i


    compute_loop:
        sll $t6,$t5,2   #i to byte for accessing array element
        add $t6,$t6,$t3 #index of A's array
        sw $t0, ($t6)
        
        sll $t6,$t5,2   #i to byte for accessing array element
        add $t6,$t6,$t4 #index of B's array
        sw $t1, ($t6)

        move $t7,$t0 # save old a, A=a

        sll $t0,$t1,1 # a=2b
        add $t0,$t0,$t7 # a=a+A(old a)

        add $t1,$t1,$t7 # b=A(old a)+b

        add $t5,$t5,1 #i=i+1
        bne $t5,$t2,compute_loop# if i != $a0 (iteration)

    li $v0,4
    la $a0,char_a
    syscall
    li $t5,0 # i
    print_loop_a:
        sll $t6,$t5,2   #i to byte for accessing array element
        add $t6,$t6,$t3 # t6 = &a[i]
        lw $a0, ($t6)   # a0 = a[i]
        
        li $v0,1        #print integer syscall trap
        syscall

        la $a0,space    #put space between numbers
        li $v0,4        
        syscall

        add $t5,$t5,1 #i=i+1

        bne $t5,$t2,print_loop_a# if i != n (iteration)

        la $a0,break_line #break line for b array
        li $v0,4
        syscall

    la $a0,char_b
    syscall
    
    li $t5,0 # i
    print_loop_b:
        sll $t6,$t5,2   #i to byte for accessing array element
        add $t6,$t6,$t4 # t6 = &b[i]
        lw $a0, ($t6)   # a0 = b[i]
        
        li $v0,1        #syscall trap for integers
        syscall

        la $a0,space
        li $v0,4
        syscall

        add $t5,$t5,1 #i=i+1

        bne $t5,$t2,print_loop_b# if i != n (iteration)

        la $a0, double_break_line
        li $v0, 4
        syscall

    jr $ra


main:

loop:

    la $a0, message # menu message
    li $v0, 4       # string trap
    syscall

    li $v0, 5
    syscall

    sle $t3,$v0,$zero      # test if <0
    bne $t3,$zero,exit     # go to Exit if <0
    slt $t3,$v0,4          # test if <4
    beq $t3,$zero,exit     # go to Exit if >=4
    
    beq $v0,1,L_square_root #local Labels
    beq $v0,2,L_matrixMult    #Local Labels
    beq $v0,3,L_palindrome  #Local Labels


L_square_root:
    la $a0,square_input_text #print input message
    li $v0, 4                #system call trap for integer input
    syscall


    li $v0, 5                #system call trap for integer input
    syscall

    move $a0,$v0             #set argument for square_root procedure
    jal square_root          #procedure call for square_root function       
    
    j loop  #loop back to the menu

L_matrixMult: 
    la $a0,first_matrix_input_text # print first matrix input text
    li $v0,4
    syscall

    li $v0,8                          # string input syscall trap
    la $a0,first_matrix_start_address # first matrix start address
    li $a1,1000                       # max character limit
    syscall

    move $t0,$a0                      # store start address of first matrix into t0

    la $a0,second_matrix_input_text   # print second matrix input text
    li $v0,4                         
    syscall

    li $v0,8                           
    la $a0,second_matrix_start_address 
    li $a1,1000
    syscall

    move $a1,$a0                       #store start address of second matrix into a1, second parameter

    la $a0,first_dimension_input_text  # first dimension input text
    li $v0,4
    syscall

    li $v0,5                        
    syscall

    move $a2,$v0                       # store first dimension into a2, third parameter

    la $a0,second_dimension_input_text  # second dimension input text
    li $v0,4
    syscall

    li $v0,5                        
    syscall

    move $a3,$v0                      # store second dimension into a3, fourth parameter
    move $a0,$t0                      # restore a0 from t0, first parameter

    jal matrix_mul
    j loop  #loop back to the menu

L_palindrome:
    la $a0, palindrome_input_text # palindrome input string
    li $v0,4                      #syscall print string trap
    syscall
    

    la $a0,input_palindrome_string #set the start address for input string
    li $a1,100 #limit to maximum number of characters
    li $v0,8   #input string sys call trap
    syscall

    jal palindrome #procedure call for palindrome function
    j loop         #loop back to the menu

exit:
    la $a0, byMessage
    li $v0,4
    syscall
    li $v0, 10
    syscall