	.text
	.global operation

operation:

	li      a0, 1            # a
	li      a1, -2           # b
	li      a2, 3            # c
	li      a3, -4           # d
	li      a4, 5            # e
	li      a5, -6           # f
	li      a6, 7            # g
	li      a7, -8           # h
	addi    sp, sp, -28      # Aloca espaço na pilha
	li      t1, 9            # i
	sw      t1, 0(sp)
	li      t1, -10          # j
	sw      t1, 4(sp)
	li      t1, 11           # k
	sw      t1, 8(sp)
	li      t1, -12          # l
	sw      t1, 12(sp)
	li      t1, 13           # m
	sw      t1, 16(sp)
	li      t1, -14          # n
	sw      t1, 20(sp)
	sw      ra, 24(sp)       # Salva o endereço de retorno

	call    mystery_function # Chama a função misteriosa

	lw      ra, 24(sp)       # Restaura o endereço de retorno
	addi    sp, sp, 28       # Desaloca espaço na pilha
	ret                      # Retorna para o chamador