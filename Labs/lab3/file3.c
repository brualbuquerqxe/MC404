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
int int_to_string(int n, char *buffer);
int hexdec (char *buffer_entrada, int tamanho);
void exit(int code);

/* --- Principais funções --- */

// Obs: como o compilador RISC-V do simulador ALE não inclui a LibC (biblioteca padrão do C), sempre precisarei fornecer as minhas próprias funções.

/* Função principal */
int main()
{
  // Define o buffer que armazena os dados de entrada (20 bytes + pular linha)
  char buffer_entrada[20];

  // Define o buffer que armazena os dados de saída (20 bytes + pular linha)
  char buffer_saida[20];

  /* Read up to 20 bytes from the standard input into the str buffer */
  int tamanho = read(STDIN, buffer_entrada, 20);

  // Descobre qual é a base do número de entrada
  char base = analise_entrada(buffer_entrada);

  int potencia = hexdec(buffer_entrada, tamanho);

  int len = int_to_string(potencia, buffer_saida);

  /* Write n bytes from the str buffer to the standard output */
  write(STDOUT, buffer_saida, 20);
  write(STDOUT, "\n", 1); // Pula linha na saída

  return 0;
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
int hexdec (char *buffer_entrada, int tamanho)
{
  // Como usaremos uma somatória, o valor incial deve ser zero.
  int valor_decimal = 0;
  int potencia = tamanho;
  return potencia;
}

/* Função que transforma inteiro em string */
// Converte um inteiro em string (base 10)
// Retorna o tamanho da string gerada
int int_to_string(int n, char *buffer) {
    int i = 0;
    int is_negative = 0;

    // Trata números negativos
    if (n < 0) {
        is_negative = 1;
        n = -n;
    }

    // Extrai os dígitos de trás pra frente
    do {
        buffer[i++] = (n % 10) + '0'; // transforma em caractere ASCII
        n /= 10;
    } while (n > 0);

    // Adiciona o sinal negativo, se houver
    if (is_negative) {
        buffer[i++] = '-';
    }

    // Inverte a string (pois foi construída ao contrário)
    for (int j = 0; j < i / 2; j++) {
        char temp = buffer[j];
        buffer[j] = buffer[i - j - 1];
        buffer[i - j - 1] = temp;
    }

    buffer[i] = '\0'; // termina a string
    return i;         // retorna tamanho
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
