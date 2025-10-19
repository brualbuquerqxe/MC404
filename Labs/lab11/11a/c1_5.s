	.text
	.global operation

operation:

	lw      t0, 0(sp)        # i
	lw      t1, 4(sp)        # j
	lw      t2, 8(sp)        # k
	lw      t3, 12(sp)       # l
	lw      t4, 16(sp)       # m
	lw      t5, 20(sp)       # n

	addi    sp, sp, -28      # Vou alocar de a0 até a7
	sw      ra, 24(sp)       # Endereço pra retornar
	sw      a0, 20(sp)       # a
	sw      a1, 16(sp)       # b
	sw      a2, 12(sp)       # c
	sw      a3, 8(sp)        # d
	sw      a4, 4(sp)        # e
	sw      a5, 0(sp)        # f

	mv      t6, a6           # g

	mv      a0, t5           # n
	mv      a1, t4           # m
	mv      a2, t3           # l
	mv      a3, t2           # k
	mv      a4, t1           # j
	mv      a5, t0           # i
	mv      a6, a7           # h
	mv      a7, t6           # g

	call    mystery_function # Chama a função misteriosa

	lw      ra, 24(sp)       # Restaura o endereço de retorno
	addi    sp, sp, 28       # Desaloca espaço na pilha
	ret                      # Retorna para o chamador
