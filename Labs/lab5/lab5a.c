/* --- Principais descritores de arquivos --- */

// Arquivo de entrada
#define STDIN 0

// Saída dos dados
#define STDOUT 1

// Saída de erro!
#define STDERR 2

/* --- Declara as principais funções --- */

// Leitura do dado de entrada
int read(int __fd, const void *__buf, int __n);

// Impressão do dado
void write(int __fd, const void *__buf, int __n);

// Encerra o programa
void exit(int code);

// Função que transforma string em número binário
void numero_binario(char *buffer_entrada, int caracter1, int caracter2, int tamanho, char *buffer_binario);

// Função que converte um número decimal negativo para binário
void negbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Função que converte um número decimal positivo para binário
void posbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Junta os números binários conforme regra do enunciado
void empacotamento(char *numero1, char *numero2, char *numero3, char *numero4, char *numero5, int tamanho, char *buffer_hexadecimal);

// Função que calcula o tamanho de uma string
int tamanho_string(const char *s);

// Função que converte um número binário para hexadecimal (retirada do livro)
void hex_code(int val);

/* --- Principais funções --- */

/* Função principal */
int main()
{
	// Buffer de entrada, o qual sempre será uma string
	char buffer_entrada[32];

	// Tamanho da buffer de entrada
	int tamanho = read(STDIN, buffer_entrada, 32);

	// Posição do primeiro caracter do número
	int posicao_inicial = 0;

	// Primeiro número da entrada (adicionei + 1 pq tem o "/0" ou "/n")
	char buffer_primeiro[33];

	// Converte o primeiro número em binário
	numero_binario(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_primeiro);

	// Posição do primeiro caracter do número
	posicao_inicial += 6;

	// Segundo número da entrada (adicionei + 1 pq tem o "/0" ou "/n")
	char buffer_segundo[33];

	// Converte o segundo número em binário
	numero_binario(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_segundo);

	// Posição do primeiro caracter do número
	posicao_inicial += 6;

	// Terceiro número da entrada
	char buffer_terceiro[33];

	// Converte o terceiro número em binário
	numero_binario(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_terceiro);

	// Posição do primeiro caracter do número
	posicao_inicial += 6;

	// Quarto número da entrada
	char buffer_quarto[33];

	// Converte o quarto número em binário
	numero_binario(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_quarto);

	// Posição do primeiro caracter do número
	posicao_inicial += 6;

	// Quinto número da entrada
	char buffer_quinto[33];

	// Converte o quinto número em binário
	numero_binario(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_quinto);

	// Buffer para o número hexadecimal
	char buffer_hexadecimal[33];

	// Empacota os números binários e imprime o valor hexadecimal
	empacotamento(buffer_primeiro, buffer_segundo, buffer_terceiro, buffer_quarto, buffer_quinto, 32, buffer_hexadecimal);
}

/* Função que transforma string em número binário */
void numero_binario(char *buffer_entrada, int caracter1, int caracter2, int tamanho, char *binario)
{
	// Número decimal começa como zero (será acumulado)
	unsigned int decimal = 0;

	// Para cada caractere, verificamos se é um dígito
	for (int i = caracter1 + 1; i < caracter2; i++)
	{
		char caracter = buffer_entrada[i];
		if (caracter >= '0' && caracter <= '9')
		{
			decimal = decimal * 10 + (caracter - '0');
		}
		// Se não for um dígito, chegou no final da string
		else if (caracter == '\n' || caracter == '\0' || caracter == ' ')
		{
			break;
		}
	}

	if (buffer_entrada[caracter1] == '-')
		// Se o número for negativo, devemos usar o complemento de 2
		negbin(decimal, binario, tamanho);
	else
		// Se o número for positivo, será apenas a conversão para binário
		posbin(decimal, binario, tamanho);
}

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

/* Junta os números binários conforme regra do enunciado */
void empacotamento(char *numero1, char *numero2, char *numero3, char *numero4, char *numero5, int tamanho, char *buffer_hexadecimal)
{
	// Definição do número binário
	char binario[33];

	for (int i = 0; i < tamanho; i++)
	{
		if (0 <= i && i < 11)
			// Escreve os algarismos do quinto número inserido
			binario[i] = numero5[i + 21];
		else if (11 <= i && i < 16)
			// Escreve os algarismos do quarto número inserido
			binario[i] = numero4[i + 16];
		else if (16 <= i && i < 21)
			// Escreve os algarismos do terceiro número inserido
			binario[i] = numero3[i + 11];
		else if (21 <= i && i < 29)
			// Escreve os algarismos do segundo número inserido
			binario[i] = numero2[i + 3];
		else if (29 <= i && i < 32)
			// Escreve os algarismos do primeiro número inserido
			binario[i] = numero1[i];
	}

	// Adiciona o terminador de string
	binario[tamanho] = '\0';

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

/* Função que converte um número binário para hexadecimal (retirada do livro)*/
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