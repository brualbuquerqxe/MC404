
	.text
	.global swap_int
	.global swap_short
	.global swap_char

swap_int:

	lw      t0, 0(a0)  # t1 = aux
	lw      t1, 0(a1)  # *b

	sw      t1, 0(a0)  # *a = *b
	sw      t0, 0(a1)  # aux = *b

	li      a0, 0      # Retorno
	ret

swap_short:

	lh      t0, 0(a0)  # t1 = aux
	lh      t1, 0(a1)  # *b

	sh      t1, 0(a0)  # *a = *b
	sh      t0, 0(a1)  # aux = *b

	li      a0, 0      # Retorno
	ret

swap_char:

	lb      t0, 0(a0)  # t1 = aux
	lb      t1, 0(a1)  # *b

	sb      t1, 0(a0)  # *a = *b
	sb      t0, 0(a1)  # aux = *b

	li      a0, 0      # Retorno
	ret
