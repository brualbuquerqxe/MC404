	.text
	.global operation

operation:

	add     a0, a1, a2 # b + c

	li      a1, -1     #Subtração

	mul     a5, a5, a1 # -f

	add     a0, a0, a5 # b + c -f

	add     a0, a0, a7 # b + c -f + h

	lw      a2, 8(sp)  # k

	add     a0, a0, a2 # b + c -f + h + k

	lw      a2, 16(sp) # m

	mul     a2, a2, a1 # -m

	add     a0, a0, a2 # b + c -f + h + k -m

	ret                # Retorna a0