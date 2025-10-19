	.text
	.global node_creation

node_creation:
	addi    sp, sp, -12

	sw      ra, 8(sp)        # Precisa ser o último acessado

	li      t1, -12
	sh      t1, 6(sp)
	li      t1, 64
	sb      t1, 5(sp)
	li      t1, 25
	sb      t1, 4(sp)
	li      t1, 30
	sw      t1, 0(sp)

	mv      a0, sp

	call    mystery_function

	lw      ra, 8(sp)
	addi    sp, sp, 12       # Restaura a pilha
	ret
