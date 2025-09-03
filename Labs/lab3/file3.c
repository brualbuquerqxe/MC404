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

// Determina qual é a base do número de entrada e chama as funções necessárias
void analise_entrada(char *buffer_entrada, char *buffer_decimal, char *buffer_binario, char *buffer_hexadecimal, char *buffer_decimal_invertido, int tamanho);

// Hexadecimal -> decimal
unsigned int hexdec(char *buffer_entrada, int tamanho);

// Hexadecimal -> binário
int hexbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Inteiro -> string
int int_para_string(unsigned int numero, char *buffer, int negativo);

// Transforma o número decimal em um valor inteiro
unsigned int decimal_numero(char *buffer_entrada, int tamanho);

// Decimal negativo -> binário negativo (complemento de 2)
void negbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Hexadecimal -> decimal
unsigned int novohexadecimal_decimal(char *buffer_hexadecimal);

// Decimal positivo -> binário positivo
void posbin(unsigned int numero_decimal, char *buffer_binario, int tamanho);

// Retorna o tamanho da string
int tamanho_string(const char *s);

// Novo hexadecimal (endian swap)
void novohexadecimal(char *buffer_hexadecimal, char *novo_buffer);

// Binário -> hexadecimal
void binhex(char *buffer_binario, char *buffer_hexadecimal);

/* --- Principais funções --- */

/* Função principal */
int main()
{
	// Buffer de entrada, o qual sempre será uma string
	char buffer_entrada[20];

	// Tamanho da buffer de entrada
	int tamanho = read(STDIN, buffer_entrada, 20);

	// Buffer de saída do valor decimal
	char buffer_decimal[30];

	// Buffer de saída do valor binário
	char buffer_binario[40];

	// Buffer de saída do valor hexadecimal
	char buffer_hexadecimal[30];

	// Buffer de saída do valor decimal do hexadecimal ao contrário
	char buffer_decimal_invertido[30];

	// Função que analisa qual é a base do número de entrada
	analise_entrada(buffer_entrada, buffer_decimal, buffer_binario, buffer_hexadecimal, buffer_decimal_invertido, tamanho);

	return 0;
}

/* Função que analisa a base do número da entrada */
void analise_entrada(char *buffer_entrada, char *buffer_decimal, char *buffer_binario, char *buffer_hexadecimal, char *buffer_decimal_invertido, int tamanho)
{
	// Se o valor de entrada começar com "0x", o número está na base hexadecimal
	if (buffer_entrada[0] == '0' && buffer_entrada[1] == 'x')
	{
		// Verificar, pelo número binário, se o número é negativo ou positivo
		int negativo = 0;

		// Remove o \n, se existir
		if (buffer_entrada[tamanho - 1] == '\n')
		{
			buffer_entrada[tamanho - 1] = '\0';
			// Já que não tem mais o \n, diminui o tamanho
			tamanho--;
		}

		// Converte o número hexadecimal para decimal
		unsigned int numero_decimal = hexdec(buffer_entrada, tamanho);

		// Converte o número decimal para binário (32 bits)
		negativo = hexbin(numero_decimal, buffer_binario, 32);

		// Converte o número decimal em string
		int_para_string(numero_decimal, buffer_decimal, negativo);

		// Calcula o decimal do endian swap
		unsigned int decimal_invertido = novohexadecimal_decimal(buffer_entrada);

		// Converte esse decimal em string para imprimir
		int_para_string(decimal_invertido, buffer_decimal_invertido, 0);

		// Escreve os buffers de saída
		write(STDOUT, buffer_binario, tamanho_string(buffer_binario));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_decimal, tamanho_string(buffer_decimal));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_entrada, tamanho_string(buffer_entrada));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_decimal_invertido, tamanho_string(buffer_decimal_invertido));
		write(STDOUT, "\n", 1);
	}
	// Se o valor de entrada começar com "-", o número está na base decimal e é negativo
	else if (buffer_entrada[0] == '-')
	{
		// Transforma de string para número
		unsigned int numero_decimal = decimal_numero(buffer_entrada, tamanho);

		// Número binário negativo
		negbin(numero_decimal, buffer_binario, 32);

		// Número hexadecimal negativo
		binhex(buffer_binario, buffer_hexadecimal);

		// Calcula o decimal do endian swap
		unsigned int decimal_invertido = novohexadecimal_decimal(buffer_hexadecimal);

		// Converte esse decimal em string para imprimir
		int_para_string(decimal_invertido, buffer_decimal_invertido, 0);

		// Escreve os buffers de saída
		write(STDOUT, buffer_binario, tamanho_string(buffer_binario));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_entrada, tamanho_string(buffer_entrada));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_hexadecimal, tamanho_string(buffer_hexadecimal));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_decimal_invertido, tamanho_string(buffer_decimal_invertido));
		write(STDOUT, "\n", 1);
	}

	// Caso contrário, o número está na base decimal e é positivo
	else
	{
		// Transforma de string para número
		unsigned int numero_decimal = decimal_numero(buffer_entrada, tamanho);

		// Converte para string
		int_para_string(numero_decimal, buffer_decimal, 0);

		// Número binário positivo
		posbin(numero_decimal, buffer_binario, 32);

		// Número hexadecimal positivo
		binhex(buffer_binario, buffer_hexadecimal);

		// Calcula o decimal do endian swap
		unsigned int decimal_invertido = novohexadecimal_decimal(buffer_hexadecimal);

		// Converte esse decimal em string para imprimir
		int_para_string(decimal_invertido, buffer_decimal_invertido, 0);

		// Escreve os buffers de saída
		write(STDOUT, buffer_binario, tamanho_string(buffer_binario));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_decimal, tamanho_string(buffer_decimal));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_hexadecimal, tamanho_string(buffer_hexadecimal));
		write(STDOUT, "\n", 1);
		write(STDOUT, buffer_decimal_invertido, tamanho_string(buffer_decimal_invertido));
		write(STDOUT, "\n", 1);
	}
}

/* Função que converte da base hexadecimal para decimal */
unsigned int hexdec(char *buffer_entrada, int tamanho)
{
	// Remove o prefixo "0x"
	int digitos = tamanho - 2;

	// A soma do valor decimal começa como zero
	unsigned int valor_decimal = 0;

	for (int i = 0; i < digitos; i++)
	{
		// Analisa cada caractere
		char c = buffer_entrada[i + 2];
		unsigned int valor;

		// Converte cada dígito hexadecimal em seu valor decimal
		if (c >= '0' && c <= '9')
			valor = c - '0';
		else if (c >= 'A' && c <= 'F')
			valor = c - 'A' + 10;
		else if (c >= 'a' && c <= 'f')
			valor = c - 'a' + 10;
		// Erro de caractere inválido
		else
			valor = 0;

		// Mudança de base
		valor_decimal = valor_decimal * 16 + valor;
	}

	// Retorna o valor decimal
	return valor_decimal;
}

/*Função que converte da base hexadecimal para binário por meio da base decimal*/
int hexbin(unsigned int numero_decimal, char *buffer_binario, int tamanho)
{
	// Os dois primeiros caracteres serão utilizados para indicar que é um número binário
	buffer_binario[0] = '0';
	buffer_binario[1] = 'b';

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

	// Verifica se o número é negativo (bit mais significativo é 1)
	if (numero_contrario[digitos - 1] == 1)
	{
		// Inverte o vetor para formar o número final
		for (int i = 0; i < digitos; i++)
		{
			buffer_binario[i + 2] = '0' + numero_contrario[digitos - i - 1];
		}

		// Finaliza a string
		buffer_binario[digitos + 2] = '\0';

		return 1;
	}

	// Precisamos remover os zeros à esquerda (no lado MSB do vetor)
	int j = digitos - 1;
	while (j > 0 && numero_contrario[j] == 0)
	{
		j--;
	}

	// Inverte o vetor até o bit mais significativo encontrado
	int posicao = 2; // Já que temos o "0b"
	for (int i = j; i >= 0; i--)
	{
		buffer_binario[posicao] = '0' + numero_contrario[i];
		posicao = posicao + 1;
	}

	// Indica que chegou ao fim
	buffer_binario[posicao] = '\0';

	return 0;
}

/* Função que transforma inteiro em string */
int int_para_string(unsigned int numero, char *buffer, int negativo)
{
	int i = 0;

	// Trata números negativos
	if (negativo == 1)
	{
		numero = -numero;
	}

	// Extrai os dígitos de trás pra frente
	do
	{
		buffer[i++] = (numero % 10) + '0'; // Transforma em caractere ASCII
		numero /= 10;
	} while (numero > 0);

	// Adiciona o sinal negativo, se houver
	if (negativo == 1)
	{
		buffer[i++] = '-';
	}

	// Inverte a string (pois foi construída ao contrário)
	for (int j = 0; j < i / 2; j++)
	{
		char temp = buffer[j];
		buffer[j] = buffer[i - j - 1];
		buffer[i - j - 1] = temp;
	}

	// marca o fim da string
	buffer[i] = '\0';

	return i;
}

/* Função que transforma string em número decimal */
unsigned int decimal_numero(char *buffer_entrada, int tamanho)
{
	// Número decimal começa como zero (será acumulado)
	unsigned int decimal = 0;

	int i = 0;
	// Se o número for negativo, o primeiro caractere será o sinal (deve ser ignorado)
	if (buffer_entrada[0] == '-')
	{
		i = 1; // Pula a primeira casa
	}

	// Para cada caractere, verificamos se é um dígito
	for (; i < tamanho; i++)
	{
		char caracter = buffer_entrada[i];
		if (caracter >= '0' && caracter <= '9')
		{
			decimal = decimal * 10 + (caracter - '0');
		}
		// Se não for um dígito, chegou no final da string
		else if (caracter == '\n' || caracter == '\0')
		{
			break;
		}
	}
	// Retorna o valor decimal sem sinal
	return decimal;
}

/*Função que converte um número decimal negativo para binário */
void negbin(unsigned int numero_decimal, char *buffer_binario, int tamanho)
{
	// Os dois primeiros caracteres serão utilizados para indicar que é um número binário
	buffer_binario[0] = '0';
	buffer_binario[1] = 'b';

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
		buffer_binario[i + 2] = '0' + numero_contrario[digitos - i - 1];
	}

	buffer_binario[digitos + 2] = '\0'; // terminador de string

	// Complemento de 2: mantenho tudo igual até chegar no primeiro 1
	int i = digitos + 1;
	while (buffer_binario[i] == '0')
	{
		i--;
	}

	// Inverto todos os valores seguintes (1 -> 0 e 0 -> 1)
	for (i = i - 1; i >= 2; i--)
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

/*Função que converte um número decimal negativo para binário */
void posbin(unsigned int numero_decimal, char *buffer_binario, int tamanho)
{
	// Os dois primeiros caracteres serão utilizados para indicar que é um número binário
	buffer_binario[0] = '0';
	buffer_binario[1] = 'b';

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
	while (j > 0 && numero_contrario[j] == 0)
	{
		j--;
	}

	// Inverte o vetor até o bit mais significativo encontrado
	int posicao = 2; // Já que temos o "0b"
	for (int i = j; i >= 0; i--)
	{
		buffer_binario[posicao] = '0' + numero_contrario[i];
		posicao = posicao + 1;
	}

	// Indica que chegou ao fim
	buffer_binario[posicao] = '\0';
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

/* Função que refaz os pares do número hexadecimal (endian swap, 32 bits fixos) */
void novohexadecimal(char *buffer_hexadecimal, char *novo_buffer)
{
	// Prefixo "0x"
	novo_buffer[0] = '0';
	novo_buffer[1] = 'x';

	// Descobre o tamanho real (sem "0x")
	int tamanho = 0;
	for (int i = 2; buffer_hexadecimal[i] != '\0'; i++)
	{
		tamanho++;
	}

	// Calcula quantos zeros faltam para completar 8 dígitos
	int faltando = 8 - tamanho;

	// Cria um buffer auxiliar com 8 dígitos garantidos
	char ajustado[11]; // "0x" + 8 dígitos + '\0'
	ajustado[0] = '0';
	ajustado[1] = 'x';

	// Preenche zeros à esquerda
	for (int i = 0; i < faltando; i++)
	{
		ajustado[2 + i] = '0';
	}

	// Copia os dígitos originais logo depois dos zeros
	for (int i = 0; i < tamanho; i++)
	{
		ajustado[2 + faltando + i] = buffer_hexadecimal[2 + i];
	}

	ajustado[10] = '\0'; // fecha string (2 + 8 = 10)

	// Agora ajustado tem sempre 8 dígitos
	// Faz o swap invertendo os pares
	int pos = 2;
	for (int i = 3; i >= 0; i--)
	{
		novo_buffer[pos++] = ajustado[2 + i * 2];
		novo_buffer[pos++] = ajustado[2 + i * 2 + 1];
	}

	novo_buffer[pos] = '\0';
}

/* Função que calcula o valor decimal de um hexadecimal invertido */
unsigned int novohexadecimal_decimal(char *buffer_hexadecimal)
{
	// Tamanho fixo!!!
	char invertido[11];

	// Chama função que faz o endian swap
	novohexadecimal(buffer_hexadecimal, invertido);

	// calcula o tamanho certo da string invertida
	int tamanho = tamanho_string(invertido);

	return hexdec(invertido, tamanho);
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