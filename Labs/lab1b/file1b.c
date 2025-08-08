/* --- Principais descritores de arquivos --- */

// Arquivo de entrada
#define STDIN 0

// Saída dos dados
#define STDOUT 1

// Saída de erro!
#define STDERR 2

/* --- Declara as principais funções --- */

int read(int __fd, void *__buf, int __n);
void write(int __fd, const void *__buf, int __n);
void exit(int code);
void calculadora(void);

/* --- Principais funções --- */

// Obs: como o compilador RISC-V do simulador ALE não inclui a LibC (biblioteca padrão do C), sempre precisarei fornecer as minhas próprias funções.

// Define o buffer que armazena os dados de entrada (5 bytes + pular linha)
char buffer_entrada[5];

// Define o buffer que armazena os dados de saída (2 bytes + pular linha)
char buffer_saida[2];

// Função principal.
int main(void)
{
  // Leitura da string de entrada, armazenando em buffer_entrada
  int tamanho_entrada = read(STDIN, buffer_entrada, 5);

      // A partir do buffer de entrada, calcula.
      calculadora();

  // Saída do resultado da calculadora!
  write(STDOUT, buffer_saida, 2);

  return 0;
}

/* Calcula a expressão de entrada e devolve o resultado */
void calculadora()
{
  // Primeiro valor com a conversão de caracter para inteiro
  int s1 = buffer_entrada[0] - '0';

  // Operador
  char operador = buffer_entrada[2];

  // Segundo valor com a conversão de caracter para inteiro
  int s2 = buffer_entrada[4] - '0';

  // Resultado inicializado como 0
  int resultado = 0;

  switch (operador)
  {
    // Soma
  case ('+'):
    resultado = s1 + s2;
    break;

    // Subtração
  case ('-'):
    resultado = s1 - s2;
    break;

    // Multiplicação
  case ('*'):
    resultado = s1 * s2;
    break;
  }

  // Registra a resposta no buffer da saída (converte de inteiro para caracter)
  buffer_saida[0] = '0' + resultado;

  // Precisa pular linha (indica que terminou a saída)
  buffer_saida[1] = '\n';
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
int read(int __fd, void *__buf, int __n)
{
  // Parâmetros: descritor do arquivo, buffer para armazenar dado, maior quantidade de bytes que devem ser lidos

  int ret_val; // Quantidade de bytes lidos

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
  // Parâmetros: descritor do arquivo, buffer para armazenar dado, maior quantidade de bytes que devem ser lidos

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
