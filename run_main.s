# 315318766 Omer Bar
      .section .rodata 
format_d:     .string "%d" # unsigned number
format_s:     .string "%s" # string


.text
    .global run_main
.type run_main, @function
run_main:
    pushq   %rbp                # saving register %rbp to the stack
    pushq   %rbx                # saving caller register
    pushq   %r12                # saving caller register
    pushq   %r13                # saving caller register
    pushq   %r14                # saving caller register
    movq    %rsp, %rbp          # moving address in %rsp to point to beigining of stack                 
       

    # ------ getting struct number 1 ------

                                # getting the size of the first STRING:
    subq    $256, %rsp          # setting location in the memory stack for the first pstring, 1 byte for length, 255 for string.
    movq    $format_d, %rdi     # moving to %rdi format for scanf.
    leaq    (%rsp), %rsi        # putting the address of %rsp into %rsi to insert the value of string size.
    xorq    %rax, %rax          # resets %rax for scanf
    call    scanf               # scanf to get the string size

                                # getting string for first struct.
    leaq    (%rsp), %r12        # setting the first struct to be held by register %r12
    movb    (%rsp), %r14b       # saving the result in temporary register.
    leaq    1(%r12), %rsi       # incrementing the address by one.
    movq    $format_s, %rdi     # setting print format for string.
    xorq    %rax, %rax          # resets rax before scanf.
    call    scanf
    
    movb    %r14b, (%r12)        # moving the number we got from scanf inside the address of the struct.

    # ------ getting struct number 2 ------
    
    subq    $256, %rsp          # setting the location of the second struct.
    movq    $format_d, %rdi     # moving to %rdi format for scanf.
    leaq    (%rsp), %rsi        # putting the address of %rsp into %rsi to insert the value of string size.
    xorq    %rax, %rax          # resets %rax for scanf
    call    scanf               # scanf to get the string size

                                # getting string for first struct.
    leaq    (%rsp), %r13        # setting the first struct to be held by register %r13
    movb    (%rsp), %r14b       # saving the result in temporary register.
    leaq    1(%r13), %rsi       # the address of the beggining of the string is %r13 + 1.

    movq    $format_s, %rdi     # setting print format for string.
    leaq    1(%r13), %rsi
    xorq    %rax, %rax          # resets rax before scanf.
    call    scanf        

    movb    %r14b, (%r13)       # moving the number we got from scanf inside the address of the struct.
                                # to summary: in register %r12 there is the address of the first struct, first byte is for the number, second for string.
                                # in register %r13 there is the address of the second struct, first byte is for the number, second for string.
                                
                                # ------ getting menu choice ------
    subq    $16, %rsp           # allocating stack memory for the menu choice
    movq    $format_d, %rdi     # setting %rdi to catch int.
    movq    %rsp, %rsi  
    movq    %rsp, %r14          # saving the address of the number.
    xorq    %rax, %rax
    call    scanf               
                                # in %r12 - address of the first struct.
                                # in %r13 - address of the second struct.
                                # in %r14 - address of the menu choice.

    movq    (%r14), %rdi        # first argument to the function. (menu choice)
    leaq    (%r12), %rsi        # second argument to the function. (first struct address)
    leaq    (%r13), %rdx        # third argument to the function. (second struct address)
    

    call    run_func

    movq    %rbp, %rsp      # restoring old stack frame, #rsp points to %rbp
    pop     %r14            # restoring caller register.
    pop     %r13            # restoring caller register.
    pop     %r12            # restoring caller register.
    pop     %rbx            # pop the old #rbx from the stack and saving it inside %rbx, caller safe.
    pop     %rbp            # getting the old stack frame before the function started.
    ret
    
# end run_main function.

