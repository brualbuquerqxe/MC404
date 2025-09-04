/* --- Principais descritores de arquivos --- */

// Arquivo de entrada
#define STDIN 0

// Saída dos dados
#define STDOUT 1

// Saída de erro!
#define STDERR 2

/* --- Declara a estrutura usada para ler as instâncias  --- */

// Enumeração dos possíveis tipos de instrução
typedef enum InstType
{
	R,
	I,
	S,
	B,
	U,
	J
} InstType;

// Estrutura com os dados da instrução
typedef struct InstData
{
	int opcode,
		rd,
		rs1,
		rs2,
		imm,
		funct3,
		funct7;
	InstType type; // Define o tipo de instrução.
} InstData;

/* --- Declara as principais funções --- */

// Leitura do dado de entrada
int read(int __fd, const void *__buf, int __n);

// Impressão do dado
void write(int __fd, const void *__buf, int __n);

// Encerra o programa
void exit(int code);

// Função que converte um número binário para hexadecimal (retirada do livro)
void hex_code(int val);

// Função que compara os primeiros caracteres de duas strings
int strcmp_custom(char *str1, char *str2, int n_char);

// Função que transforma string em número binário
void numero_binario(int decimal, int tamanho, char *binario);

// Parses a string with a RISC-V instruction and fills an InstData struct with the instruction's data.
void get_inst_data(char inst[], InstData *data);

// Função que calcula o tamanho de uma string
int tamanho_string(const char *s);

// Função que converte um número decimal negativo para binário */
void negbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Função que converte um número decimal positivo para binário
void posbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Função que empacota uma instrução do tipo R
void empacotamento_R(char *funct7, char *rs2, char *rs1, char *funct3, char *rd, char *opcode);

// Função que empacota uma instrução do tipo I
void empacotamento_I(char *imm, char *rs1, char *funct3, char *rd, char *opcode);

// Função que empacota uma instrução do tipo S
void empacotamento_S(char *imm, char *rs2, char *rs1, char *funct3, char *opcode);

// Função que empacota uma instrução do tipo B
void empacotamento_B(char *imm, char *rs2, char *rs1, char *funct3, char *opcode);

// Função que empacota uma instrução do tipo U
void empacotamento_U(char *imm, char *rd, char *opcode);

void _start();

/* --- As principais funções --- */

int main()
{
	/*
		Use the provided functions and the previously implemented pack function to pack the contents
		of a RISC-V instruction on a single int variable, paying attention to each instruction's
		particularities and print the final result using the hex_code function.
	*/

	// Buffer de entrada, o qual sempre será uma string
	char buffer_entrada[32];

	// Tamanho da buffer de entrada
	int tamanho = read(STDIN, buffer_entrada, 32);

	// Inicializa os dados da instância de entrada
	InstData data;

	// Descobre qual foi o comando usado
	get_inst_data(buffer_entrada, &data);

	// Buffer para o opcode
	char buffer_opcode[8];

	// Buffer para o rd
	char buffer_rd[6];

	// Buffer para o rs1
	char buffer_rs1[6];

	// Buffer para o rs2
	char buffer_rs2[6];

	// Buffer para o imm
	char buffer_imm[33];

	// Buffer para o funct3
	char buffer_funct3[4];

	// Buffer para o funct7
	char buffer_funct7[8];

	// Número binário do opcode
	numero_binario(data.opcode, 7, buffer_opcode);

	// Número binário do rd
	numero_binario(data.rd, 5, buffer_rd);

	// Número binário do rs1
	numero_binario(data.rs1, 5, buffer_rs1);

	// Número binário do rs2
	numero_binario(data.rs2, 5, buffer_rs2);

	write(STDOUT, buffer_rs2, tamanho_string(buffer_rs2));
	write(STDOUT, "fora do else", tamanho_string("fora do else"));

	// Número binário do imm
	numero_binario(data.imm, 32, buffer_imm);

	// Número binário do funct3
	numero_binario(data.funct3, 3, buffer_funct3);

	// Número binário do funct7
	numero_binario(data.funct7, 7, buffer_funct7);

	if (data.type == R)
	{
		// Empacota instrução do tipo R
		empacotamento_R(buffer_funct7, buffer_rs2, buffer_rs1, buffer_funct3, buffer_rd, buffer_opcode);
	}
	else if (data.type == I)
	{
		// Empacotamento final
		empacotamento_I(buffer_imm, buffer_rs1, buffer_funct3, buffer_rd, buffer_opcode);
	}
	else if (data.type == S)
	{
		write(STDOUT, buffer_rs2, tamanho_string(buffer_rs2));
		write(STDOUT, "teste2", tamanho_string("teste2"));

		// Empacotamento final
		empacotamento_S(buffer_imm, buffer_rs2, buffer_rs1, buffer_funct3, buffer_opcode);
	}
	else if (data.type == U)
	{
		// Empacotamento final
		empacotamento_U(buffer_imm, buffer_rd, buffer_opcode);
	}
	else if (data.type == B)
	{
		empacotamento_B(buffer_imm, buffer_rs2, buffer_rs1, buffer_funct3, buffer_opcode);
	}

	return 0;
}

/* Função que informa que o programa foi concluído (extraída do livro) */
void exit(int code)
{
	__asm__ __volatile__(
		"mv a0, %0           # return code\n"
		"li a7, 93           # syscall exit (93) \n"
		"ecall"
		:			// Output list
		: "r"(code) // Input list
		: "a0", "a7");
}

/* Função que chama a função principal do programa (extraída do livro) */
void _start()
{
	int ret_code = main();
	exit(ret_code);
}

/* Junta os números binários conforme regra do enunciado */
void empacotamento_R(char *funct7, char *rs2, char *rs1, char *funct3, char *rd, char *opcode)
{
	// Definição do número binário
	char binario[33];

	for (int i = 0; i < 32; i++)
	{
		if (i < 7)
			binario[i] = funct7[i];
		else if (7 <= i && i < 12)
			binario[i] = rs2[i - 7];
		else if (12 <= i && i < 17)
			binario[i] = rs1[i - 12];
		else if (17 <= i && i < 20)
			binario[i] = funct3[i - 17];
		else if (20 <= i && i < 25)
			binario[i] = rd[i - 20];
		else
			binario[i] = opcode[i - 25];
	}
	binario[32] = '\0'; // terminador

	// Converte o número binário para inteiro para ser lido por hex_code
	unsigned int numero = 0;
	for (int i = 0; i < 32; i++)
	{
		// Como se multiplicasse por 2 (move para esquerda)
		numero <<= 1;

		if (binario[i] == '1')
			// Coloca o último bit do número em 1
			numero |= 1;
	}

	// Converte de binário para hexadecimal
	hex_code(numero);
}

/* Junta os números binários conforme regra do enunciado */
void empacotamento_I(char *imm, char *rs1, char *funct3, char *rd, char *opcode)
{
	// Definição do número binário
	char binario[33];

	for (int i = 0; i < 32; i++)
	{
		if (i < 12)
			binario[i] = imm[i];
		else if (12 <= i && i < 17)
			binario[i] = rs1[i - 12];
		else if (17 <= i && i < 20)
			binario[i] = funct3[i - 17];
		else if (20 <= i && i < 25)
			binario[i] = rd[i - 20];
		else
			binario[i] = opcode[i - 25];
	}
	binario[32] = '\0'; // terminador

	// Converte o número binário para inteiro para ser lido por hex_code
	unsigned int numero = 0;
	for (int i = 0; i < 32; i++)
	{
		// Como se multiplicasse por 2 (move para esquerda)
		numero <<= 1;

		if (binario[i] == '1')
			// Coloca o último bit do número em 1
			numero |= 1;
	}

	// Converte de binário para hexadecimal
	hex_code(numero);
}

/* Junta os números binários conforme regra do enunciado */
void empacotamento_S(char *imm, char *rs2, char *rs1, char *funct3, char *opcode)
{
	// Definição do número binário
	char binario[33];

	for (int i = 0; i < 32; i++)
	{
		if (i < 7)
			binario[i] = imm[20 + i];
		else if (7 <= i && i < 12)
			binario[i] = rs2[i - 7];
		else if (12 <= i && i < 17)
			binario[i] = rs1[i - 12];
		else if (17 <= i && i < 20)
			binario[i] = funct3[i - 17];
		else if (20 <= i && i < 25)
			binario[i] = imm[i + 7];
		else
			binario[i] = opcode[i - 25];
	}
	binario[32] = '\0'; // terminador

	write(STDOUT, binario, tamanho_string(binario));
	write(STDOUT, "\n", 1);

	// Converte o número binário para inteiro para ser lido por hex_code
	unsigned int numero = 0;
	for (int i = 0; i < 32; i++)
	{
		// Como se multiplicasse por 2 (move para esquerda)
		numero <<= 1;

		if (binario[i] == '1')
			// Coloca o último bit do número em 1
			numero |= 1;
	}

	// Converte de binário para hexadecimal
	hex_code(numero);
}

/* Junta os números binários conforme regra do enunciado */
void empacotamento_B(char *imm, char *rs2, char *rs1, char *funct3, char *opcode)
{
	// Definição do número binário
	char binario[33];

	for (int i = 0; i < 32; i++)
	{
		if (i < 6)
			binario[i] = imm[10 - i];
		else if (i == 6)
			binario[i] = imm[11];
		else if (6 < i && i < 12)
			binario[i] = rs2[i - 7];
		else if (12 <= i && i < 17)
			binario[i] = rs1[i - 12];
		else if (17 <= i && i < 20)
			binario[i] = funct3[i - 17];
		else if (20 <= i && i < 24)
			binario[i] = imm[24 - i];
		else if (i == 24)
			binario[i] = imm[11];
		else
			binario[i] = opcode[i - 25];
	}
	binario[32] = '\0'; // terminador

	// Converte o número binário para inteiro para ser lido por hex_code
	unsigned int numero = 0;
	for (int i = 0; i < 32; i++)
	{
		// Como se multiplicasse por 2 (move para esquerda)
		numero <<= 1;

		if (binario[i] == '1')
			// Coloca o último bit do número em 1
			numero |= 1;
	}

	// Converte de binário para hexadecimal
	hex_code(numero);
}

/* Junta os números binários conforme regra do enunciado */
void empacotamento_U(char *imm, char *rd, char *opcode)
{
	// Definição do número binário
	char binario[33];

	for (int i = 0; i < 32; i++)
	{
		if (i < 20)
			binario[i] = imm[i];
		else if (20 <= i && i < 25)
			binario[i] = rd[i - 20];
		else
			binario[i] = opcode[i - 25];
	}
	binario[32] = '\0'; // terminador

	// Converte o número binário para inteiro para ser lido por hex_code
	unsigned int numero = 0;
	for (int i = 0; i < 32; i++)
	{
		// Como se multiplicasse por 2 (move para esquerda)
		numero <<= 1;

		if (binario[i] == '1')
			// Coloca o último bit do número em 1
			numero |= 1;
	}

	// Converte de binário para hexadecimal
	hex_code(numero);
}

/* Função que lê os dados de entrada (extraída do livro) */
int read(int __fd, const void *__buf, int __n)
{
	int ret_val;
	__asm__ __volatile__(
		"mv a0, %1           # file descriptor\n"
		"mv a1, %2           # buffer \n"
		"mv a2, %3           # size \n"
		"li a7, 63           # syscall read code (63) \n"
		"ecall               # invoke syscall \n"
		"mv %0, a0           # move return value to ret_val\n"
		: "=r"(ret_val)					  // Output list
		: "r"(__fd), "r"(__buf), "r"(__n) // Input list
		: "a0", "a1", "a2", "a7");
	return ret_val;
}

/* Função que escreve na saída (extraída do livro) */
void write(int __fd, const void *__buf, int __n)
{
	__asm__ __volatile__(
		"mv a0, %0           # file descriptor\n"
		"mv a1, %1           # buffer \n"
		"mv a2, %2           # size \n"
		"li a7, 64           # syscall write (64) \n"
		"ecall"
		:								  // Output list
		: "r"(__fd), "r"(__buf), "r"(__n) // Input list
		: "a0", "a1", "a2", "a7");
}

/* Função que converte um número binário para hexadecimal (retirada do livro) */
void hex_code(int val)
{
	char hex[11];
	unsigned int uval = (unsigned int)val, aux;

	hex[0] = '0';
	hex[1] = 'x';
	hex[10] = '\n';

	for (int i = 9; i > 1; i--)
	{
		aux = uval % 16;
		if (aux >= 10)
			hex[i] = aux - 10 + 'A';
		else
			hex[i] = aux + '0';
		uval = uval / 16;
	}
	write(1, hex, 11);
}

/* Função que compara os primeiros caracteres de duas strings */
int strcmp_custom(char *str1, char *str2, int n_char)
{
	for (int i = 0; i < n_char; i++)
	{
		if (str1[i] < str2[i])
			return -1;
		else if (str1[i] > str2[i])
			return 1;
	}
	return 0;
}

// Reads a string of characters representing a number in decimal base from a buffer, converts to int and updates the number of chars read from the buffer.
int dec_to_int(char buffer[], int *read_chars)
{
	int neg = 0, val = 0, curr;
	if (buffer[0] == '-')
		neg = 1;

	curr = neg;
	while (buffer[curr] >= '0' && buffer[curr] <= '9')
	{
		val = val * 10;
		val = val + buffer[curr] - '0';
		curr++;
	}
	if (neg == 1)
		val = -val;
	*read_chars += curr + 1;
	return val;
}

// Gets the register id from a buffer and updates the number of chars read.
int get_register(char buffer[], int *read_chars)
{
	int curr = 0;
	while (buffer[curr] != 'x')
	{
		curr++;
	}
	curr++;
	*read_chars += curr;

	*read_chars += 1;
	return dec_to_int(&buffer[curr], read_chars);
}

// Gets the immediate value from a buffer and updates the number of chars read.
int get_immediate(char buffer[], int *read_chars)
{
	int curr = 0;

	while (!((buffer[curr] >= '0' && buffer[curr] <= '9') || buffer[curr] == '-'))
	{
		curr++;
	}
	*read_chars += curr;
	return dec_to_int(&buffer[curr], read_chars);
}

// Parsing of instruction with format rd_imm.
void rd_imm(char buffer[], int *rd, int *imm, int start)
{
	*rd = get_register(&buffer[start], &start);
	*imm = get_immediate(&buffer[start], &start);
}

// Parsing of instruction with format r1_r2_imm.
void r1_r2_imm(char buffer[], int *r1, int *r2, int *imm, int start)
{
	*r1 = get_register(&buffer[start], &start);
	*r2 = get_register(&buffer[start], &start);
	*imm = get_immediate(&buffer[start], &start);
}

// Parsing of instruction with format r1_imm_r2.
void r1_imm_r2(char buffer[], int *r1, int *r2, int *imm, int start)
{
	*r1 = get_register(&buffer[start], &start);
	*imm = get_immediate(&buffer[start], &start);
	*r2 = get_register(&buffer[start], &start);
}

// Parsing of instruction with format r1_r2_r3.
void r1_r2_r3(char buffer[], int *r1, int *r2, int *r3, int start)
{
	*r1 = get_register(&buffer[start], &start);
	*r2 = get_register(&buffer[start], &start);
	*r3 = get_register(&buffer[start], &start);
}

// Parses a string with a RISC-V instruction and fills an InstData struct with the instruction's data.
void get_inst_data(char inst[], InstData *data)
{
	int opcode = 0,
		rd = 0,
		rs1 = 0,
		rs2 = 0,
		imm = 0,
		funct3 = 0,
		funct7 = 0;
	InstType type = I;
	if (strcmp_custom(inst, "lui", 3) == 0)
	{
		// lui rd, IMM
		// OPCODE = 0110111 = 55
		rd_imm(inst, &rd, &imm, 3);
		opcode = 55, type = U;
	}
	else if (strcmp_custom(inst, "auipc ", 6) == 0)
	{
		// auipc rd, IMM
		// OPCODE = 0010111 = 23
		rd_imm(inst, &rd, &imm, 5);
		opcode = 23, type = U;
	}
	else if (strcmp_custom(inst, "jal ", 4) == 0)
	{
		// jal rd, IMM
		// OPCODE = 1101111 = 111
		rd_imm(inst, &rd, &imm, 3);
		opcode = 111, type = J;
	}
	else if (strcmp_custom(inst, "jalr ", 5) == 0)
	{
		// jalr rd, IMM(rs1)
		// OPCODE = 1100111 = 103  FUNCT3 = 0
		r1_imm_r2(inst, &rd, &rs1, &imm, 4);
		opcode = 103, type = I;
	}
	else if (strcmp_custom(inst, "beq ", 4) == 0)
	{
		// beq rs1, rs2, IMM
		// OPCODE = 1100011 = 99 FUNCT3 = 0
		r1_r2_imm(inst, &rs1, &rs2, &imm, 3);
		opcode = 99, type = B;
	}
	else if (strcmp_custom(inst, "bne ", 4) == 0)
	{
		// bne rs1, rs2, IMM
		// OPCODE = 1100011 = 99 FUNCT3 = 1
		r1_r2_imm(inst, &rs1, &rs2, &imm, 3);
		opcode = 99, funct3 = 1, type = B;
	}
	else if (strcmp_custom(inst, "blt ", 4) == 0)
	{
		// blt rs1, rs2, IMM
		// OPCODE = 1100011 = 99 FUNCT3 = 4
		r1_r2_imm(inst, &rs1, &rs2, &imm, 3);
		opcode = 99, funct3 = 4, type = B;
	}
	else if (strcmp_custom(inst, "bge ", 4) == 0)
	{
		// bge rs1, rs2, IMM
		// OPCODE = 1100011 = 99 FUNCT3 = 5
		r1_r2_imm(inst, &rs1, &rs2, &imm, 3);
		opcode = 99, funct3 = 5, type = B;
	}
	else if (strcmp_custom(inst, "bltu ", 5) == 0)
	{
		// bltu rs1, rs2, IMM
		// OPCODE = 1100011 = 99 FUNCT3 = 6
		r1_r2_imm(inst, &rs1, &rs2, &imm, 4);
		opcode = 99, funct3 = 6, type = B;
	}
	else if (strcmp_custom(inst, "bgeu ", 5) == 0)
	{
		// bgeu rs1, rs2, IMM
		// OPCODE = 1100011 = 99 FUNCT3 = 7
		r1_r2_imm(inst, &rs1, &rs2, &imm, 4);
		opcode = 99, funct3 = 7, type = B;
	}
	else if (strcmp_custom(inst, "lb ", 3) == 0)
	{
		// lb rd, IMM(rs1)
		// OPCODE = 0000011 = 3 FUNCT3 = 0
		r1_imm_r2(inst, &rd, &rs1, &imm, 2);
		opcode = 3;
	}
	else if (strcmp_custom(inst, "lh ", 3) == 0)
	{
		// lh rd, IMM(rs1)
		// OPCODE = 0000011 = 3 FUNCT3 = 1
		r1_imm_r2(inst, &rd, &rs1, &imm, 2);
		opcode = 3, funct3 = 1;
	}
	else if (strcmp_custom(inst, "lw ", 3) == 0)
	{
		// lw rd, IMM(rs1)
		// OPCODE = 0000011 = 3 FUNCT3 = 2
		r1_imm_r2(inst, &rd, &rs1, &imm, 2);
		opcode = 3, funct3 = 2;
	}
	else if (strcmp_custom(inst, "lbu ", 4) == 0)
	{
		// lbu rd, IMM(rs1)
		// OPCODE = 0000011 = 3 FUNCT3 = 4
		r1_imm_r2(inst, &rd, &rs1, &imm, 3);
		opcode = 3, funct3 = 4;
	}
	else if (strcmp_custom(inst, "lhu ", 4) == 0)
	{
		// lhu rd, IMM(rs1)
		// OPCODE = 0000011 = 3 FUNCT3 = 5
		r1_imm_r2(inst, &rd, &rs1, &imm, 3);
		opcode = 3, funct3 = 5;
	}
	else if (strcmp_custom(inst, "sb ", 3) == 0)
	{
		// sb rs2, IMM(rs1)
		// OPCODE = 0100011 = 35 FUNCT3 = 0
		r1_imm_r2(inst, &rs2, &rs1, &imm, 2);
		opcode = 35, type = S;
	}
	else if (strcmp_custom(inst, "sh ", 3) == 0)
	{
		// sh rs2, IMM(rs1)
		// OPCODE = 0100011 = 35 FUNCT3 = 1
		r1_imm_r2(inst, &rs2, &rs1, &imm, 2);
		opcode = 35, funct3 = 1, type = S;
	}
	else if (strcmp_custom(inst, "sw ", 3) == 0)
	{
		// sw rs2, IMM(rs1)
		// OPCODE = 0100011 = 35 FUNCT3 = 2
		r1_imm_r2(inst, &rs2, &rs1, &imm, 2);
		opcode = 35, funct3 = 2, type = S;
	}
	else if (strcmp_custom(inst, "addi ", 5) == 0)
	{
		// addi rd, rs1, IMM
		// OPCODE = 0010011 = 19 FUNCT3 = 0
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19;
	}
	else if (strcmp_custom(inst, "slti ", 5) == 0)
	{
		// slti rd, rs1, IMM
		// OPCODE = 0010011 = 19 FUNCT3 = 2
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19, funct3 = 2;
	}
	else if (strcmp_custom(inst, "sltiu ", 6) == 0)
	{
		// sltiu rd, rs1, IMM
		// OPCODE = 0010011 = 19 FUNCT3 = 3
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19, funct3 = 3;
	}
	else if (strcmp_custom(inst, "xori ", 5) == 0)
	{
		// xori rd, rs1, IMM
		// OPCODE = 0010011 = 19 FUNCT3 = 4
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19, funct3 = 4;
	}
	else if (strcmp_custom(inst, "ori ", 4) == 0)
	{
		// ori rd, rs1, IMM
		// OPCODE = 0010011 = 19 FUNCT3 = 6
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19, funct3 = 6;
	}
	else if (strcmp_custom(inst, "andi ", 5) == 0)
	{
		// andi rd, rs1, IMM
		// OPCODE = 0010011 = 19 FUNCT3 = 7
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19, funct3 = 7;
	}
	else if (strcmp_custom(inst, "slli ", 5) == 0)
	{
		// slli rd, rs1, shamt
		// OPCODE = 0010011 = 19 FUNCT3 = 1
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19, imm = imm % 32, funct3 = 1;
	}
	else if (strcmp_custom(inst, "srli ", 5) == 0)
	{
		// srli rd, rs1, shamt
		// OPCODE = 0010011 = 19 FUNCT3 = 5
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19, imm = imm % 32, funct3 = 5;
	}
	else if (strcmp_custom(inst, "srai ", 5) == 0)
	{
		// srai rd, rs1, shamt
		// OPCODE = 0010011 = 19 FUNCT3 = 5
		r1_r2_imm(inst, &rd, &rs1, &imm, 4);
		opcode = 19, imm = imm % 32 + 1024, funct3 = 5, funct7 = 32;
	}
	else if (strcmp_custom(inst, "add ", 4) == 0)
	{
		// add rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 0  FUNCT7 = 0
		r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
		opcode = 51, type = R;
	}
	else if (strcmp_custom(inst, "sub ", 4) == 0)
	{
		// sub rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 0  FUNCT7 = 32
		r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
		opcode = 51, funct7 = 32, type = R;
	}
	else if (strcmp_custom(inst, "sll ", 4) == 0)
	{
		// sll rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 1  FUNCT7 = 0
		r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
		opcode = 51, funct3 = 1, type = R;
	}
	else if (strcmp_custom(inst, "slt ", 4) == 0)
	{
		// slt rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 2  FUNCT7 = 0
		r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
		opcode = 51, funct3 = 2, type = R;
	}
	else if (strcmp_custom(inst, "sltu ", 5) == 0)
	{
		// sltu rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 3  FUNCT7 = 0
		r1_r2_r3(inst, &rd, &rs1, &rs2, 4);
		opcode = 51, funct3 = 3, type = R;
	}
	else if (strcmp_custom(inst, "xor ", 4) == 0)
	{
		// xor rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 4  FUNCT7 = 0
		r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
		opcode = 51, funct3 = 4, type = R;
	}
	else if (strcmp_custom(inst, "srl ", 4) == 0)
	{
		// srl rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 5  FUNCT7 = 0
		r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
		opcode = 51, funct3 = 5, type = R;
	}
	else if (strcmp_custom(inst, "sra ", 4) == 0)
	{
		// sra rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 5  FUNCT7 = 32
		r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
		opcode = 51, funct3 = 5, funct7 = 32, type = R;
	}
	else if (strcmp_custom(inst, "or ", 3) == 0)
	{
		// or rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 6  FUNCT7 = 0
		r1_r2_r3(inst, &rd, &rs1, &rs2, 2);
		opcode = 51, funct3 = 6, type = R;
	}
	else if (strcmp_custom(inst, "and ", 4) == 0)
	{
		// and rd, rs1, rs2
		// OPCODE = 0110011 = 51 FUNCT3 = 7  FUNCT7 = 0
		r1_r2_r3(inst, &rd, &rs1, &rs2, 3);
		opcode = 51, funct3 = 7, type = R;
	}
	data->opcode = opcode;
	data->rd = rd;
	data->rs1 = rs1;
	data->rs2 = rs2;
	data->imm = imm;
	data->funct3 = funct3;
	data->funct7 = funct7;
	data->type = type;
	return;
}

/* Função que transforma string em número binário */
void numero_binario(int decimal, int tamanho, char *binario)
{
	if (decimal < 0)
	{
		// Se o número for negativo, devemos usar o complemento de 2
		decimal = decimal * -1;
		negbin(decimal, binario, tamanho);
	}
	else
		// Se o número for positivo, será apenas a conversão para binário
		posbin(decimal, binario, tamanho);
}

/* Função que calcula o tamanho de uma string */
int tamanho_string(const char *s)
{
	// Tamanho começa com 0
	int len = 0;
	// Percorre a string até encontrar o terminador
	while (s[len] != '\0')
	{
		// Avança para o próximo caractere
		len++;
	}
	return len;
};

/*Função que converte um número decimal negativo para binário */
void negbin(unsigned int numero_decimal, char *buffer_binario, int tamanho)
{

	// Número de dígitos do número binário (máximo 32 bits)
	int digitos = tamanho;

	// Vetor que armazenará o número contrário
	unsigned int numero_contrario[digitos];

	// Inicializa o dividendo (número que será dividido)
	unsigned int dividendo = numero_decimal;

	// Converte decimal para binário (pela divisão por 2)
	for (int i = 0; i < digitos; i++)
	{
		// Guarda o resto da divisão por 2
		numero_contrario[i] = dividendo % 2;
		// Atualiza o dividendo para a próxima iteração
		dividendo = dividendo / 2;
	}

	// Inverte o vetor para formar o número final
	for (int i = 0; i < digitos; i++)
	{
		buffer_binario[i] = '0' + numero_contrario[digitos - i - 1];
	}

	buffer_binario[digitos] = '\0'; // terminador de string

	// Complemento de 2: mantenho tudo igual até chegar no primeiro 1
	int i = digitos - 1;
	while (i >= 0 && buffer_binario[i] == '0')
	{
		i--;
	}

	// Inverto todos os valores seguintes (1 -> 0 e 0 -> 1)
	for (i = i - 1; i >= 0; i--)
	{
		if (buffer_binario[i] == '0')
		{
			buffer_binario[i] = '1';
		}
		else if (buffer_binario[i] == '1')
		{
			buffer_binario[i] = '0';
		}
	}
}
/*Função que converte um número decimal positivo para binário */
void posbin(unsigned int numero_decimal, char *buffer_binario, int tamanho)
{

	// Número de dígitos do número binário (máximo 32 bits)
	int digitos = tamanho;

	// Vetor que armazenará o número contrário
	unsigned int numero_contrario[digitos];

	// Inicializa o dividendo (número que será dividido)
	unsigned int dividendo = numero_decimal;

	// Converte decimal para binário (pela divisão por 2)
	for (int i = 0; i < digitos; i++)
	{
		// Guarda o resto da divisão por 2
		numero_contrario[i] = dividendo % 2;
		// Atualiza o dividendo para a próxima iteração
		dividendo = dividendo / 2;
	}

	// Precisamos remover os zeros à esquerda
	int j = digitos - 1;

	// Inverte o vetor até o bit mais significativo encontrado
	int posicao = 0;
	for (int i = j; i >= 0; i--)
	{
		buffer_binario[posicao] = '0' + numero_contrario[i];
		posicao = posicao + 1;
	}

	// Indica que chegou ao fim
	buffer_binario[posicao] = '\0';
};