rax = [rbp +8 *3]
rbx = [rbp + 8 * (3 + rax)]

flat_list
    list_size = 0 
    rax = list
    while (rax != nil)
        push (car rax)
        rax = (cdr rax)
        list_size++

    for (i = 0; i < list_size / 2; i++)
        temp = [rsp + 8 *(list_size - i -1)]
        [rsp + 8 *(list_size - i - 1)] = [rsp + 8 * i]
        [rsp + 8 * i] = temp



   argc = [rbp + 8 * 3]

for (rdi = (3+argc-1) ; i > 4 ; rdi--)
    push [rbp+8*(rdi)]
    rsi++;