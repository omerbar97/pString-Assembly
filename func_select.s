# 315318766 Omer Bar
    .section    .rodata
format_c:     .string "%c\n"
format_d:     .string "%d"
format_L31:   .string "first pstring length: %d, second pstring length: %d\n"
format_L32:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n" 
format_ERROR: .string "invalid option!\n"
format_L35:   .string "length: %d, string: %s\n"
format_L37:   .string "compare result: %d\n"

    .align 8
.JTab:
    .quad   .L30    # defalut
    .quad   .L31    # print size. 
    .quad   .L32    # replaceChar
    .quad   .L33    # replaceChar
    .quad   .L34    # None jump to default
    .quad   .L35    # pstrijcpy
    .quad   .L36    # swapCase
    .quad   .L37    # pstrijcmp

.text
    .global run_func
.type run_func, @function
run_func:
    pushq   %rbp                # saving register %rbp to the stack
    pushq   %r12                # address of the first struct
    pushq   %r13                # address of the second struct
    pushq   %r14
    pushq   %r15
    movq    %rsp, %rbp          # moving address in %rsp to point to beigining of stack

                                # in %rdi, the menu choice
                                # in %rsi, first struct address
                                # in %rdx, second struct address

    movq    %rsi, %r12          # memory of first struct is in: %r12.
    movq    %rdx, %r13          # memory of second struct is in: %r13.


    subq    $30, %rdi           # for convinune to work with number choice 1-7.    
    cmpl    $7, %edi            # comapring the value 7 with the number for default.
    ja      .L30                # jumping to default in case %rdi is more then 7
    jmp     *.JTab( ,%edi, 8)   # moving the the currect jumping label



.L31:                           # print pString size
    movq    %r12, %rdi          # moving the address of the first struct.
    call    pstrlen             # calculating the size of first struct string.
    movq    %rax, %r12          # saving result in %r12.

    movq    %r13, %rdi          # moving the address of the second struct.
    call    pstrlen             # calculating the size of the second string.
    movq    %rax, %r13          # saving result in %r13.

    movq    $format_L31, %rdi   # print format for L31 label.
    movq    %r12, %rsi          # first struct to %rsi.
    movq    %r13, %rdx          # second struct to %rdx.

    xorq    %rax, %rax          # setting %rax to 0. 
    call    printf

    jmp     .finish


.L32:                            # replaceChar in case the menu choice is 32 or 33.
.L33:
    # getting old char
    subq    $16, %rsp            # setting memory space in stack for first char.
    movq    $format_c, %rdi      # setting %rdi to get char.
    leaq    (%rsp), %rsi         # memory location of first char is in %rsp.
    xorq    %rax, %rax
    call    scanf

    movq    %rsi, %r14           # saving result of old char in: %r14.

    movq    $format_c, %rdi      # setting %rdi to get char.
    leaq    (%rsp), %rsi         # memory location of overright the old char in memory.
    xorq    %rax, %rax           # setting %rax to 0.
    call    scanf

    movq    %rsi, %r15           # saving result of new char in: %r12.
    
    # summary:
    # in %r14 old char.
    # in %r15 new char.
    
    # in %r12, %r13 first and second struct respectavliy.

    # setting function argument
    
    movq    %r12, %rdi           # address of first struct
    movq    %r14, %rsi           # old char.
    movq    %r15, %rdx           # new char.

    call    replaceChar          # call replaceChar on first struct.

    movq    %r13, %rdi           # address of second struct
    movq    %r14, %rsi           # old char.
    movq    %r15, %rdx           # new char.

    call    replaceChar          # call replaceChar on second struct.

    # printing the result:

    movq    $format_L32, %rdi    # format print.
    movq    %r14, %rsi           # old char.
    movq    %r15, %rdx           # new char.
    leaq    1(%r12), %rcx        # first string.
    leaq    1(%r13), %r8         # second string.

    call    printf

    jmp     .finish


.L34:                            # None jump to default.
    jmp .L30

.L35:                            # pstrijcpy
    # r12 - first struct - dst.
    # r13 - second struct - src.

    # getting 2 number i, j into %r14, %r15 respectavlie.
    subq    $16, %rsp            # making space in stack memroy for number i.
    movq    $format_d, %rdi      # format for scanf. "%d\n"
    leaq    (%rsp), %rsi         # for scanf second argument.
    xorq    %rax, %rax           # %rax =  0
    call    scanf              

    xorq    %r14, %r14           # resting %r14 = 0.
    movb    (%rsp), %r14b        # in %r14 = i.

    subq    $16, %rsp            # making space in stack memroy for number j.
    movq    $format_d, %rdi      # format for scanf. "%d\n"
    leaq    (%rsp), %rsi         # for scanf second argument.
    xorq    %rax, %rax           # %rax =  0
    call    scanf                

    xorq    %r15, %r15           # resting %r15 = 0
    movb    (%rsp), %r15b        # in %r15 = j.

    # setting arguments for pstrijcpy function.
    # first argument in %rdi - pointer to the destination struct.
    # second argument in %rsi - pointer to the src struct.
    # third argument in %rdx - the number i.
    # forth argument in %r8 - the number j.

    movq    %r12, %rdi           # dst struct into %rdi.
    movq    %r13, %rsi           # src struct into %rsi.
    movq    %r14, %rdx           # %rdx = i.
    movq    %r15, %r8            # %r8 = j.

    call    pstrijcpy

    # in %rax the return address of pstring dst
    movq    $format_L35, %rdi    # print format.
    xorq    %rsi, %rsi           # reseting %rsi to be 0.
    movb    (%rax), %sil         # moving the string size into %rsi.
    leaq    1(%rax), %rdx        # third argument is the pointer to the string.
    call    printf

    movq    $format_L35, %rdi    # print format.
    xorq    %rsi, %rsi           # reseting %rsi to be 0.
    movb    (%r13), %sil         # moving the string size into %rsi.
    leaq    1(%r13), %rdx        # third argument is the pointer to the string.
    call    printf

    jmp     .finish              # breaking the switch case.

.L36:                            # swapCase

    # r12 - first struct
    # r13 - second struct

    # calling swapCase:
    # in %rdi the pointer to the pstring.

    leaq    (%r12), %rdi         # %rdi first argument in function swapCase.
    call    swapCase

    # printing the of first pstring. return address from function in %rax.
    movq    $format_L35, %rdi    # for printf.
    xorq    %rsi, %rsi           # for printf.
    movb    (%rax), %sil         # string size.
    leaq    1(%rax), %rdx        # first string pointer.
    call    printf

    leaq    (%r13), %rdi         # %rdi first argument in function swapCase.
    call    swapCase

    # printing the of second pstring. return address from function in %rax.
    movq    $format_L35, %rdi    # for printf.
    xorq    %rsi, %rsi           # for printf.
    movb    (%rax), %sil         # string size.
    leaq    1(%rax), %rdx        # first string pointer.
    call    printf

    jmp     .finish              # breaking the switch case.

.L37:                            # pstrijcmp

    # r12 - first struct - dst.
    # r13 - second struct - src.

    # getting 2 number i, j into %r14, %r15 respectavlie.
    subq    $16, %rsp            # making space in stack memroy for number i.
    movq    $format_d, %rdi      # format for scanf. "%d\n"
    leaq    (%rsp), %rsi         # for scanf second argument.
    xorq    %rax, %rax           # %rax =  0
    call    scanf              

    xorq    %r14, %r14           # resting %r14 = 0.
    movb    (%rsp), %r14b        # in %r14 = i.

    subq    $16, %rsp            # making space in stack memroy for number j.
    movq    $format_d, %rdi      # format for scanf. "%d\n"
    leaq    (%rsp), %rsi         # for scanf second argument.
    xorq    %rax, %rax           # %rax =  0
    call    scanf                

    xorq    %r15, %r15           # resting %r15 = 0
    movb    (%rsp), %r15b        # in %r15 = j.


    # setting pstrijcmp register function argument.
    # in %rdi - pointer to first pstring.
    # in %rsi - pointer to second pstring.
    # in %rdx - the number i.
    # in %r8 - the number j.

    movq    %r12, %rdi           # in %rdi - pointer to first pstring.
    movq    %r13, %rsi           # in %rsi - pointer to second pstring.
    movq    %r14, %rdx           # the number i.
    movq    %r15, %r8            # the number j.

    call    pstrijcmp

    # result in %rax.
    movq    $format_L37, %rdi    # for printf format.
    movq    %rax, %rsi           # compare result.
    call    printf

    jmp     .finish              # breaking the switch case.


.L30:                            # default.
    # printing invaild input:
    movq    $format_ERROR, %rdi  # %rdi = "invalid input!\n"
    xorq    %rax, %rax           # resets before printf.
    call    printf

.finish:

    # end switch case program.

    movq    %rbp, %rsp      # restoring old stack frame, #rsp points to %rbp
    pop     %r15
    pop     %r14
    pop     %r13
    pop     %r12
    pop     %rbp            # getting the old stack frame before the function started.
    ret
