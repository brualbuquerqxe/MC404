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

// Função que transforma string em número decimal
void decimal_numero(char *buffer_entrada, int caracter1, int caracter2, int tamanho, char *buffer_binario);

// Função que converte um número decimal negativo para binário
void negbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Função que converte um número decimal positivo para binário
void posbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Junta os números binários conforme regra do enunciado
void empacotamento(char *numero1, char *numero2, char *numero3, char *numero4, char *numero5, int tamanho, char *buffer_hexadecimal);

// Função que converte binário em hexadecimal
void binhex(char *buffer_binario, char *buffer_hexadecimal);

// Função que calcula o tamanho de uma string
int tamanho_string(const char *s);

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

	// Primeiro número da entrada
	char buffer_primeiro[33];

	decimal_numero(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_primeiro);

	write(STDOUT, buffer_primeiro, tamanho_string(buffer_primeiro));
	write(STDOUT, "\n", 1);

	// Posição do primeiro caracter do número
	posicao_inicial += 6;

	// Segundo número da entrada
	char buffer_segundo[33];

	decimal_numero(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_segundo);

	write(STDOUT, buffer_segundo, tamanho_string(buffer_segundo));
	write(STDOUT, "\n", 1);

	// Posição do primeiro caracter do número
	posicao_inicial += 6;

	// Terceiro número da entrada
	char buffer_terceiro[33];
	decimal_numero(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_terceiro);

	write(STDOUT, buffer_terceiro, tamanho_string(buffer_terceiro));
	write(STDOUT, "\n", 1);

	// Posição do primeiro caracter do número
	posicao_inicial += 6;

	// Quarto número da entrada
	char buffer_quarto[33];
	decimal_numero(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_quarto);

	write(STDOUT, buffer_quarto, tamanho_string(buffer_quarto));
	write(STDOUT, "\n", 1);

	// Posição do primeiro caracter do número
	posicao_inicial += 6;

	// Quinto número da entrada
	char buffer_quinto[33];
	decimal_numero(buffer_entrada, posicao_inicial, posicao_inicial + 5, 32, buffer_quinto);

	write(STDOUT, buffer_quinto, tamanho_string(buffer_quinto));
	write(STDOUT, "\n", 1);

	// Buffer para o número hexadecimal
	char buffer_hexadecimal[33];

	// Empacota os números binários.
	empacotamento(buffer_primeiro, buffer_segundo, buffer_terceiro, buffer_quarto, buffer_quinto, tamanho, buffer_hexadecimal);

	write(STDOUT, buffer_hexadecimal, tamanho_string(buffer_hexadecimal));
	write(STDOUT, "\n", 1);
}

/* Função que transforma string em número decimal */
void decimal_numero(char *buffer_entrada, int caracter1, int caracter2, int tamanho, char *binario)
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
	char *binario[32];

	for (int i = 0; i < tamanho; i++)
	{
		if (i < 11)
			// Escreve os algarismos do quinto número inserido
			for (int j = 31; j > 20; j--)
				binario[i] = numero5[j];
		else if (11 <= i && i < 16)
			// Escreve os algarismos do quarto número inserido
			for (int j = 31; j > 26; j--)
				binario[i] = numero4[j];
		else if (16 <= i && i < 21)
			// Escreve os algarismos do quarto número inserido
			for (int j = 31; j > 26; j--)
				binario[i] = numero3[j];
		else if (21 <= i < 29)
			for (int j = 31; j >= 24; j--)
				binario[i] = numero2[j];
		else if (29 <= i && i < 32)
			for (int j = 31; j >= 29; j--)
				binario[i] = numero1[j];

		// Converte de binário para hexadecimal
		binhex(binario, buffer_hexadecimal);
	}
}

/* Função que converte binário em hexadecimal */
void binhex(char *buffer_binario, char *buffer_hexadecimal)
{
	buffer_hexadecimal[0] = '0';
	buffer_hexadecimal[1] = 'x';

	// Armazena o tamanho real do número binário (sem o "0b")
	int tamanho = 0;
	for (int i = 2; buffer_binario[i] != '\0'; i++)
	{
		tamanho++;
	}

	// Vetor para guardar os valores dos dígitos em hexadecimal
	char digitos_hex[32];

	// Quantidade de dígitos no novo número hexadecimal
	int qtd_digitos = 0;

	// Começa do fim da string binária (LSB)
	int valor = 0;
	int peso = 1;
	int contagem = 0;

	// Percorre os bits do número binário
	for (int i = tamanho + 1; i >= 2; i--)
	{
		// Se o bit for 1, adiciona o valor do peso
		if (buffer_binario[i] == '1')
		{
			valor = valor + peso;
		}

		// Próxima casa: mais uma potência de 2
		peso = peso * 2;

		// Quantas casas já foram passadas para esse dígito hexadecimal
		contagem++;

		// Quando juntar 4 casas ou chegar no começo, iniciamos um novo dígito hexadecimal
		if (contagem == 4 || i == 2)
		{
			if (valor < 10)
			{
				// Número normal
				digitos_hex[qtd_digitos] = '0' + valor;
			}
			else
			{
				// Letra precisa ser convertida em número
				digitos_hex[qtd_digitos] = 'a' + (valor - 10);
			}
			// Mudamos o dígito do número hexadecimal
			qtd_digitos++;

			// Valor volta a ser zero
			valor = 0;

			// Peso é reiniciado
			peso = 1;

			// Contagem é reiniciada
			contagem = 0;
		}
	}

	// Agora inverte os dígitos
	int posicao = 2;
	for (int i = qtd_digitos - 1; i >= 0; i--)
	{
		// Muda a posição do dígito
		buffer_hexadecimal[posicao] = digitos_hex[i];
		posicao = posicao + 1;
	}

	// Encerra
	buffer_hexadecimal[posicao] = '\0';
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