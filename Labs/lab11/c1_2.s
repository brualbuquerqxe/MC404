	.text
	.global my_function

my_function:

	addi    sp, sp, -20      # Cria espaço na pilha

	sw      ra, 16(sp)       # Salva o endereço de retorno na pilha
	sw      a0, 12(sp)       # Salva o valor de a na pilha
	sw      a1, 8(sp)        # Salva o valor de b na pilha
	sw      a2, 4(sp)        # Salva o valor de c na pilha

	add     a0, a0, a1       # a0 = a + b
	lw      a1, 12(sp)       # a1 = a

	call    mystery_function # Chama a função misteriosa (retorna em a0)

	li      a4, -1           # Subtração
	mul     a0, a0, a4       # a0 = - resultado da função misteriosa

	lw      a2, 4(sp)        # a2 = c
	lw      a3, 8(sp)        # a3 = b

	add     a0, a0, a2       # a0 = - resultado + c
	add     a0, a0, a3       # a0 = b - resultado + c

	sw      a0, 0(sp)        # Salva aux na pilha (a0 = aux)
	lw      a1, 8(sp)        # b

	call    mystery_function # Chama a função misteriosa (retorna em a0)

	lw      a1, 4(sp)        # c
	lw      a2 , 0(sp)       # aux
	li      a4, -1           # Subtração

	mul     a0, a0, a4       # a0 = - resultado da função misteriosa

	add     a0, a0, a1       # a0 = - resultado + c
	add     a0, a0, a2       # a0 = aux - resultado + c

	lw      ra, 16(sp)       # Restaura o endereço de retorno
	addi    sp, sp, 20       # Restaura o ponteiro da pilha
	ret                      # Retorna para o chamador
