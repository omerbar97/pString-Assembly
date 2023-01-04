# 315318766 Omer Bar
    .section    .rodata
format_ERROR: .string "invalid input!\n"

.text
    .global pstrlen
.type pstrlen, @function
pstrlen:
    pushq   %rbp                # saving register %rbp to the stack
    movq    %rsp, %rbp    

    # function register information arguments: 
    # in %rdi the struct address, need to return the size of the string.

    xorq    %rax, %rax          # setting %rax to zero.
    movb    (%rdi), %al         # the value of the string size inside the first address of the pstring.

    movq    %rbp, %rsp          # restoring old stack frame, #rsp points to %rbp
    pop     %rbp                # getting the old stack frame before the function started.
    ret

# ------------------------- end function pstrlen ------------------------- 



    .global replaceChar
.type replaceChar, @function
replaceChar:
    pushq   %rbp                # saving register %rbp to the stack            
    movq    %rsp, %rbp       

    # function register information arguments: 
    # in %rdi - address of the struct.
    # in %rsi - old char
    # in %rdx - new char

    leaq    (%rdi), %rax        # saving return address of the pstring.

.LOOP_REPLACE_CHAR:
    leaq    1(%rdi), %rdi       # setting the address of %rdi to point to the next char in the string.
    cmpb    $0, (%rdi)          # if the value in %rdi is 0 we at '\0'.
    jz      .DONE_LOOP_REPLACE

    cmpb    %sil, (%rdi)        # in case the char is the same as old char replacing the value.
    jz      .REPLACE            # replacing the char.
    jmp     .LOOP_REPLACE_CHAR  # jumping to the begging of the loop.

.REPLACE:    
    movb    %dl, (%rdi)         # rewriting the value in the address %rdi of the new char.
    jmp     .LOOP_REPLACE_CHAR  # jumping to the begging of the loop.

.DONE_LOOP_REPLACE:

    # in %rax the return address of the pstring that was sent to the function.

    movq    %rbp, %rsp      # restoring old stack frame, #rsp points to %rbp
    pop     %rbp            # getting the old stack frame before the function started.
    ret

# ------------------------- end function replaceChar ------------------------- 


    .global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    pushq   %rbp                # saving register %rbp to the stack     
    pushq   %r15                # saving caller register.
    pushq   %r14                # saving caller register.
    movq    %rsp, %rbp     

    # function register information arguments: 
    # first argument in %rdi - pointer to the destination struct.
    # second argument in %rsi - pointer to the src struct.
    # third argument in %rdx - the number i.
    # forth argument in %r8 - the number j.

    leaq    (%rdi), %r14        # saving the address of dst in %r14.

    # checking if i and j are valid # 0 <= i,j <= first struct size && second strcut size.
    cmpq    $0, %rdx            # in case the value is less then zero jumping to error.
    jl      .ERROR              # jump less. (Signed <)       
    cmpq    %r8, %rdx           # in case the value is less\equal to zero jumping to error.
    jg      .ERROR              # j must be greater or equal to i. -->  i <= j. jump greator (Signed >)
    cmpb    %r8b, (%rdi)        # in case the value j is more then the first string size.
    jl      .ERROR              # the size of the j must be less then the entire first string. jump less. (Signed <)
    cmpb    %r8b, (%rsi)        # in case the value j is more then the size of second string.
    jle     .ERROR              # the size of the j must be less then the entire second string. jump less equal (Signed <=)

    # end input checks.

    # setting the string to copy.
    leaq    1(%rdi, %rdx, 1), %rdi    # moving to address: %rdi = %rdi + 1*%rdx + 1 -> pointing to begging of first string.
    leaq    1(%rsi, %rdx, 1), %rsi    # moving to address: %rsi = %rsi + 1*%rdx + 1 -> pointing to begging of second string.

.LOOP_COPY:
    xorq    %r15, %r15
    movb    (%rsi), %r15b       # temporary storing the byte for transfer.
    movb    %r15b, (%rdi)       # rewriting the new value in %rdi.
    addq    $1, %rdx            # incrementing i++.
    leaq    1(%rdi), %rdi       # incrementing the pointer of dsc.
    leaq    1(%rsi), %rsi       # incrementing the pointer of src.
    cmpb    %r8b , %dl          # %dl is part of %rdx         
    jle     .LOOP_COPY          # if i <= j jump to beginning of loop.

    jmp     .DONE_PSTRIJCPY     # finish copying.

.ERROR:
    # need to print here error.
    movq    $format_ERROR, %rdi # for printf.
    xorq    %rax, %rax          # for printf.
    call    printf


.DONE_PSTRIJCPY:
    movq    %r14, %rax      # this function return the pointer to dst.
    movq    %rbp, %rsp      # restoring old stack frame, #rsp points to %rbp
    pop     %r14            # restoring the value in %r14.
    pop     %r15            # restoring the value in %r15.
    pop     %rbp            # getting the old stack frame before the function started.
    ret

# ------------------------- end function pstrijcpy ------------------------- 

    .global swapCase
.type swapCase, @function
swapCase:
    pushq   %rbp                # saving register %rbp to the stack    
    pushq   %r12                # saving caller register.
    movq    %rsp, %rbp   

    # function register argument information:
    # in %rdi the pointer to the pstring.

    leaq    (%rdi), %r12        # %r12 = pointer to the pstring.
    leaq    1(%rdi), %rdi       # %rdi pointer++

.LOOP_SWAP_CASE:
    xorq    %r8, %r8            # r8 = 0
    movb    (%rdi), %r8b        # saving the char in %rdi.
    cmpb    $91, %r8b           # if %r8b is UPPER CASE then the ascii value is between 65 to 90
    js     .TO_LOWER            # result is negative means %r8b - 91 < 0
    cmpb    $97, %r8b           # if %r8b is LOWER CASE then the ascii value is between 97 to 122
    jns    .TO_UPPER            # result is not negative means %r8b - 97 >= 0
    jmp    .DONE_CHANGE         # in case the value is not a letter.


.TO_LOWER:
   # need to check if it is above 65:
    cmpb    $65, %r8b           # if %r8b - 65 >= 0 value is okay. changing to lower letter.
    jns     .CHANGE_TO_LOWER    # changing the value.
    jmp     .DONE_CHANGE


.CHANGE_TO_LOWER:
    addb    $32, %r8b           # changing the value of %r8b to be lower case, + 32.
    jmp     .DONE_CHANGE

.TO_UPPER:
    # need to check if it is lower then 123:
    cmpb    $123, %r8b           # if %r8b - 123 < 0 value is okay. changing to lower letter.
    js     .CHANGE_TO_UPPER      # changing the value.
    jmp    .DONE_CHANGE

.CHANGE_TO_UPPER:
    subb    $32, %r8b           # changing the value of %r8b to be lower case, + 32.
    jmp     .DONE_CHANGE


.DONE_CHANGE:
    movb    %r8b, (%rdi)        # rewriting the value at %rdi.
    leaq    1(%rdi), %rdi       # incrementing the pointer by 1.
    cmpb    $0, (%rdi)          # if the end of string was reach the value is 0.
    je      .DONE_LOOP_SWAPCASE
    jmp     .LOOP_SWAP_CASE

.DONE_LOOP_SWAPCASE:
    
    leaq    (%r12), %rax        # return value is the struct pointer. %rax = %r12
    movq    %rbp, %rsp          # restoring old stack frame, #rsp points to %rbp
    pop     %r12
    pop     %rbp                # getting the old stack frame before the function started.
    ret

# ------------------------- end function swapCase ------------------------- 

    .global pstrijcmp
.type pstrijcmp, @function
pstrijcmp:
    pushq   %rbp                # saving register %rbp to the stack     
    pushq   %r15           
    pushq   %r14            
    movq    %rsp, %rbp     

    # function register argument information:
    # in %rdi - pointer to first pstring.
    # in %rsi - pointer to second pstring.
    # in %rdx - the number i.
    # in %r8 - the number j.

    # this function returns:
    # pstr1[i:j] > pstr2[i:j] return 1;
    # pstr1[i:j] < pstr2[i:j] return -1;
    # pstr1[i:j] = pstr2[i:j] return 0;
    # #error with the index return -2.

    # checking the input i, j.

    # checking if i and j are valid # 0 <= i,j <= first struct size && second strcut size.
    cmpq    $0, %rdx            # in case the value is less then zero jumping to error.
    jl      .ERROR2             # jump less. (Signed <)       
    cmpq    %r8, %rdx           # in case the value is less\equal to zero jumping to error.
    jg     .ERROR2              # j must be greater or equal to i. -->  i <= j. jump greator (Signed >)
    cmpb    %r8b, (%rdi)        # in case the value j is more then the first string size.
    jl      .ERROR2             # the size of the j must be less then the entire first string. jump less. (Signed <)
    cmpb    %r8b, (%rsi)        # in case the value j is more then the size of second string.
    jle     .ERROR2             # the size of the j must be less then the entire second string. jump less equal (Signed <=)

    # end input checks.

    # setting the string to compare.
    leaq    1(%rdi, %rdx, 1), %rdi    # moving to address: %rdi = %rdi + 1*%rdx + 1
    leaq    1(%rsi, %rdx, 1), %rsi    # moving to address: %rsi = %rsi + 1*%rdx + 1

    # by default retuning %rax = 0 if all the values are equal.
    movq    $0, %rax

.COMPARE_LOOP:
    xorq    %r14, %r14                # temporary byte to hold the pstr1[i] value.
    xorq    %r15, %r15                # temporary byte to hold the pstr1[i] value.
    movb    (%rdi), %r14b              # %r14b = pstr1[i]
    movb    (%rsi), %r15b              # %r15b = pstr2[i]

    cmpb    %r14b, %r15b              # %r15b - %r14b = ?
                                      # 3 cases:
                                      # 1. %r15b - %r14b > 0 means r15 above r14 in ascii order 
                                      #     therefore returning -1.
                                      # 2. %r15b - %r14b < 0 means r14 above r15 in ascii order 
                                      #     therefore returning 1.
                                      # 3. %r15b - %r14b = 0 means r15 equal to r14 in ascii order 
                                      #     therefore returning continue the loop until the end.

    jz      .EQUAL
    ja      .PSTR2_ABOVE
    jb      .PSTR1_ABOVE


.EQUAL:
    leaq    1(%rdi), %rdi             # moving the pointer of the first string.
    leaq    1(%rsi), %rsi             # moving the pointer of the second string.

    # reminder:
    # in %rdx the index i.
    # in %r8 the index j.

    addq    $1, %rdx                  # incrementing the value of %rdx by 1.
    cmpq    %r8, %rdx                 # %rdx - r8 <= 0 need's to happend to continue the loop.
    jle     .COMPARE_LOOP
    jmp     .DONE_CMP

.PSTR1_ABOVE:
    movq    $1, %rax                  # setting return value to be 1.
    jmp     .DONE_CMP


.PSTR2_ABOVE:
    movq    $-1, %rax                 # setting return value to be 1.
    jmp     .DONE_CMP

.ERROR2:
    # printing invalid input.
    movq    $format_ERROR, %rdi       # for printf.
    call    printf
    movq    $-2, %rax                 # error return value is -2.

.DONE_CMP:

    movq    %rbp, %rsp      # restoring old stack frame, #rsp points to %rbp
    pop     %r14
    pop     %r15
    pop     %rbp            # getting the old stack frame before the function started.
    ret

# ------------------------- end function pstrijcmp ------------------------- 
