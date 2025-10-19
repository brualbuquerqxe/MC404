
	.text
	.global middle_value_int
	.global middle_value_short
	.global middle_value_char
	.global value_matrix

middle_value_int:

	li      a3, 2              # Divisor
	div     a4, a1, a3         # a4 = middle = n/2
	slli    a4, a4, 2          # Já que é inteiro e ocupa 4 bytes

	add     a5, a0, a4         # Muda a posição no array

	lw      a0, 0(a5)          # Retorna o valor
	ret

middle_value_short:

	li      a3, 2              # Divisor
	div     a4, a1, a3         # a4 = middle = n/2
	slli    a4, a4, 1          # Já que é inteiro e ocupa 2 bytes

	add     a5, a0, a4         # Muda a posição no array

	lw      a0, 0(a5)          # Retorna o valor
	ret

middle_value_char:

	li      a3, 2              # Divisor
	div     a4, a1, a3         # a4 = middle = n/2

	add     a5, a0, a4         # Muda a posição no array

	lw      a0, 0(a5)          # Retorna o valor
	ret

value_matrix:
	li      a3, 42             # Máximo de colunas
	mul     a1, a1, a3         # Quanto tem que andar do endereço
	add     a1, a1, a2         # Soma quantas colunas tem que andar na última linha

	slli    a1, a1, 2          # Já que é inteiro

	add     a1, a0, a1         # Anda

	lw      a0, 0(a1)          # Retorna o valor encontrado
	ret
