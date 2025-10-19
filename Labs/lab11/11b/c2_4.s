	.text
	.global node_op

node_op:
	lw      t0, 0(a0)  # a
	lb      t1, 4(a0)  # b
	lb      t2, 5(a0)  # c
	lh      t3, 6(a0)  # d

	li      t4, -1     # Subtração

	mul     a0, t2, t4 # -c

	add     a0, a0, t0 # a -c
	add     a0, a0, t1 # a + b -c
	add     a0, a0, t3 # a + b -c + d

	ret                # Retorna a0