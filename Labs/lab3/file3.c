/* --- Principais descritores de arquivos --- */

// Arquivo de entrada
#define STDIN 0

// Saída dos dados
#define STDOUT 1

// Saída de erro!
#define STDERR 2

/* --- Declara as principais funções --- */

int read(int __fd, const void *__buf, int __n);
void write(int __fd, const void *__buf, int __n);
char analise_entrada(char *buffer_entrada);
void int_to_string(unsigned int n, char *buffer, int negativo);
void decbin(unsigned int numero, char *buffer, int tamanho);
unsigned int decimal_decimal(char *buffer_entrada, int tamanho);
unsigned int hexdec(char *buffer_entrada, int tamanho);
void negbin(char *buffer_binario, int tamanho);
void exit(int code);
int my_strlen(const char *s);

/* --- Principais funções --- */

// Obs: como o compilador RISC-V do simulador ALE não inclui a LibC (biblioteca padrão do C), sempre precisarei fornecer as minhas próprias funções.

/* Função principal */
int main()
{
  char buffer_entrada[20];
  int tamanho = read(STDIN, buffer_entrada, 20);
  int negativo = 0;

  char buffer_decimal[30];
  char buffer_binario[40]; // "0b" + 32 bits + '\0'

  char base = analise_entrada(buffer_entrada);

  if (base == 'H')
  {
    // Converte o número hexadecimal para decimal
    unsigned int numero_decimal = hexdec(buffer_entrada, tamanho);

    // Converte o número decimal para binário (32 bits)
    decbin(numero_decimal, buffer_binario, 32);
    write(STDOUT, buffer_binario, my_strlen(buffer_binario));
    write(STDOUT, "\n", 1);

    if (buffer_binario[2] == '1')
    {
      negativo = -1;
    }

    // Converte e escreve o número decimal
    int_to_string(numero_decimal, buffer_decimal, negativo);
    write(STDOUT, buffer_decimal, my_strlen(buffer_decimal));
    write(STDOUT, "\n", 1);

    // Escreve a entrada hexadecimal
    write(STDOUT, buffer_entrada, tamanho);
    write(STDOUT, "\n", 1);
  }
  // Se o número for negativo
  else if (base == 'P')
  {
    // Muda de string para número
    unsigned int numero_decimal = decimal_decimal(buffer_entrada, tamanho);

    // Converte o número decimal para binário (32 bits)
    decbin(numero_decimal, buffer_binario, 32);
    write(STDOUT, buffer_binario, my_strlen(buffer_binario));
    write(STDOUT, "\n", 1);

    // Converte e escreve o número decimal
    int_to_string(numero_decimal, buffer_decimal, negativo);
    write(STDOUT, buffer_decimal, my_strlen(buffer_decimal));
    write(STDOUT, "\n", 1);

    // Escreve a entrada decimal
    write(STDOUT, buffer_entrada, tamanho);
    write(STDOUT, "\n", 1);
  }
  else
  {
    // Muda de string para número
    unsigned int numero_decimal = decimal_decimal(buffer_entrada, tamanho);

    // Converte o número decimal para binário (32 bits)
    decbin(numero_decimal, buffer_binario, 32);
    negbin(buffer_binario, my_strlen(buffer_binario));
    write(STDOUT, buffer_binario, my_strlen(buffer_binario));
    write(STDOUT, "\n", 1);

    // Converte e escreve o número decimal
    int_to_string(numero_decimal, buffer_decimal, negativo);
    write(STDOUT, buffer_decimal, my_strlen(buffer_decimal));
    write(STDOUT, "\n", 1);

    // Escreve a entrada decimal
    write(STDOUT, buffer_entrada, tamanho);
    write(STDOUT, "\n", 1);
  }

  return 0;
}

void decbinneg(char *buffer_binario, int tamanho)
{
  buffer_binario[0] = '0';
  buffer_binario[1] = 'b';

  int digitos = tamanho;
  unsigned int numero_contrario[digitos];

  unsigned int dividendo = numero;

  // Converte decimal para binário (pela divisão por 2)
  for (int i = 0; i < digitos; i++)
  {
    numero_contrario[i] = dividendo % 2;
    dividendo = dividendo / 2;
  }

  // Inverte o vetor para formar o número final
  for (int i = 0; i < digitos; i++)
  {
    buffer[i + 2] = '0' + numero_contrario[digitos - i - 1];
  }

  buffer[digitos + 2] = '\0'; // terminador de string
  
  // Inverte os bits
  int i = tamanho - 1;
  while (buffer_binario[i] == '0')
  {
    i--;
  }

  i--;

  for (; i >= 2; i--)
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

/* Função que analisa a base do número da entrada */
char analise_entrada(char *buffer_entrada)
{
  // Se o valor de entrada começar com "0x", o número está na base hexadecimal
  if (buffer_entrada[0] == '0' && buffer_entrada[1] == 'x')
    return 'H';

  // Se o valor de entrada começar com "-", o número está na base decimal e é negativo
  else if (buffer_entrada[0] == '-')
    return 'N';

  // Caso contrário, o número está na base decimal e é positivo
  else
    return 'P';
}

/* Função que converte da base hexadecimal para decimal*/
unsigned int hexdec(char *buffer_entrada, int tamanho)
{
  // Quantidade de digitos presente na entrada
  int digitos = tamanho - 3;

  // Criação do vetor que armazenará os números
  unsigned int numero[digitos];

  // Converte de string para inteiro
  for (int i = 0; i < digitos; i++)
  {
    numero[i] = buffer_entrada[i + 2] - '0';
  }

  // Como usaremos uma somatória, o valor incial deve ser zero
  unsigned int valor_decimal = 0;

  // Para cada um dos digitos, calculamos seu valor na base decimal
  for (int i = 0; i < digitos; i++)
  {
    // Multiplicador para a base 16 (começa como 1)
    int multiplicador = 1;

    // Para cada um dos digitos à direita do atual, aumentamos o multiplicador
    for (int j = i + 1; j < digitos; j++)
    {
      // Multiplicador aumenta de 16 em 16
      multiplicador *= 16;
    }

    // Adiciona o valor do dígito atual ao total
    valor_decimal += numero[i] * multiplicador;
  }

  // Retorna o valor decimal final
  return valor_decimal;
}

/*Função que converte da base decimal para binário*/
void decbinpos(unsigned int numero, char *buffer, int tamanho)
{
  buffer[0] = '0';
  buffer[1] = 'b';

  int digitos = tamanho;
  unsigned int numero_contrario[digitos];

  unsigned int dividendo = numero;

  // Converte decimal para binário (pela divisão por 2)
  for (int i = 0; i < digitos; i++)
  {
    numero_contrario[i] = dividendo % 2;
    dividendo = dividendo / 2;
  }

  // Agora removemos os zeros à esquerda (no lado MSB do vetor)
  int j = digitos - 1;
  while (j > 0 && numero_contrario[j] == 0)
  {
    j--;
  }

  // Inverte o vetor até o bit mais significativo encontrado
  int pos = 2; // começa depois de "0b"
  for (int i = j; i >= 0; i--)
  {
    buffer[pos] = '0' + numero_contrario[i];
    pos = pos + 1;
  }

  buffer[pos] = '\0'; // terminador de string
}

/* Função que transforma inteiro em string */
// Converte um inteiro em string (base 10)
// Retorna o tamanho da string gerada
int int_to_string(unsigned int n, char *buffer, int negativo)
{
  int i = 0;
  int is_negative = 0;

  // Trata números negativos
  if (negativo < 0)
  {
    is_negative = 1;
    n = -n;
  }

  // Extrai os dígitos de trás pra frente
  do
  {
    buffer[i++] = (n % 10) + '0'; // transforma em caractere ASCII
    n /= 10;
  } while (n > 0);

  // Adiciona o sinal negativo, se houver
  if (is_negative)
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

  buffer[i] = '\0'; // termina a string

  return i;
}

unsigned int decimal_decimal(char *buffer_entrada, int tamanho)
{
  unsigned int decimal = 0;

  // começa do caractere 0 (ou 1 se o número tiver sinal '-')
  int i = 0;
  if (buffer_entrada[0] == '-')
  {
    i = 1; // ignora o sinal negativo
  }

  for (; i < tamanho; i++)
  {
    char c = buffer_entrada[i];
    if (c >= '0' && c <= '9')
    {
      decimal = decimal * 10 + (c - '0');
    }
    else if (c == '\n' || c == '\0')
    {
      break; // terminou a string
    }
  }

  return decimal;
}

/* Função que informa que o programa foi concluído (extraída do livro) */
void exit(int code)
{
  __asm__ __volatile__(
      "mv a0, %0           # return code\n"
      "li a7, 93           # syscall exit (93) \n"
      "ecall"
      :           // Output list
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
      : "=r"(ret_val)                   // Output list
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
      :                                 // Output list
      : "r"(__fd), "r"(__buf), "r"(__n) // Input list
      : "a0", "a1", "a2", "a7");
}

int my_strlen(const char *s)
{
  int len = 0;
  while (s[len] != '\0')
  {
    len++;
  }
  return len;
}
