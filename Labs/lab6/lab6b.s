# Seção para armazenar a entrada no buffer
    .section .bss
buffer:
# Para facilitar, vou fazer a leitura das duas linhas juntas
    .skip    32

# Seção em que está o código e as definições das funcões
    .section .text

    .globl   _start
    .globl   leitura
    .globl   escrita
    .globl   conversao_int
    .globl   conversao_int_signed
    .globl   raiz_quadrada
    .globl   main
    .globl   int_to_string_signed

# Inicia o programa a partir do rótulo "_start".
_start:
    call     main
    li       a0, 0                          # Código de saída
    li       a7, 93                         # Serviço de saída
    ecall

# Função que vai ler as duas linhas de entrada
leitura:
    li       a0, 0                          # Entrada padrão
    la       a1, buffer                     # Onde a entrada será armazenada
    li       a2, 32                         # Número de bytes que serão lidos
    li       a7, 63                         # read
    ecall                                   # Chama sistema
    ret                                     # Retorna

# A função de "escrita" busca escrever a saída do programa
escrita:
    mv       t0, a0                         # Copia o número de bytes lidos
    li       a0, 1                          # Saída padrão
    la       a1, buffer                     # Carrega o endereço do buffer
    mv       a2, t0                         # Move o número de bytes lidos para a2
    li       a7, 64                         # Código do serviço de escrita
    ecall                                   # Chamada de sistema
    ret                                     # Retorna da função


# Extrai o número da string armazenada no buffer e o converte para um valor inteiro.
conversao_int:
    li       t2, 4                          # Como são 4 algarismos na entrada, inicializa o contador com 4
    li       a0, 0                          # Inicializa o registrador a0 com 0
    li       t1, 1000                       # Multiplicador inicial (1000 para o primeiro dígito)
    li       t4, 10                         # Carrega o valor 10 no registrador t4

# Converte cada algarismo da string em um número inteiro.
repeticao_extracao_numero:
    add      t5, a1, t3                     # Calcula o endereço do caractere atual
    lbu      t0, 0(t5)                      # Leitura do primeiro caractere da string (coloca em um registrador temporário)
    addi     t0, t0, -'0'                   # Converte o caractere ASCII para um inteiro
    mul      t0, t0, t1                     # Multiplica o valor pelo multiplicador (1000 para o primeiro dígito)
    add      a0, a0, t0                     # Adiciona o valor ao registrador a0(soma)

    addi     t3, t3, 1                      # Incrementa o índice para o próximo caractere
    addi     t2, t2, -1                     # Decrementa o contador
    div      t1, t1, t4                     # Atualiza o multiplicador (divide por 10 para o próximo dígito)

    bnez     t2, repeticao_extracao_numero  # Se o contador for maior que zero, repete o processo

    ret                                     # Retorna da função

# Converte número com sinal no formato [+|-]dddd usando base a1 e offset em t3)
conversao_int_signed:
# ponteiro local p = a1 + t3
    add      t6, a1, t3

# zera acumulador e prepara multiplicador e contadores
    li       a0, 0
    li       t1, 1000                       # 1000,100,10,1
    li       t4, 10
    li       t2, 4                          # 4 dígitos
    li       a2, 0                          # flag negativo (0=+, 1=-)

# lê sinal opcional
    lbu      t0, 0(t6)
    li       t5, '+'
    beq      t0, t5, cis_plus
    li       t5, '-'
    beq      t0, t5, cis_minus
    j        cis_after_sign

cis_plus:
    addi     t6, t6, 1                      # pula '+'
    j        cis_after_sign
cis_minus:
    li       a2, 1
    addi     t6, t6, 1                      # pula '-'

cis_after_sign:
# loop dos 4 dígitos
    li       t3, 0                          # índice local 0..3
cis_loop:
    add      t5, t6, t3
    lbu      t0, 0(t5)
    addi     t0, t0, -'0'
    mul      t0, t0, t1
    add      a0, a0, t0

    addi     t3, t3, 1
    addi     t2, t2, -1
    div      t1, t1, t4
    bnez     t2, cis_loop

# aplica sinal, se preciso
    beqz     a2, cis_end
    sub      a0, x0, a0
cis_end:
    ret

# A função "raiz_quadrada" calcula a raiz quadrada inteira do número armazenado em s10.
raiz_quadrada:

    beqz s10, rq_zero        # Exceção quando o número for zero
    li   t1, 1
    beq  s10, t1, rq_one     # Exceção quando o número for um

    li t6, 2 # Carrega o valor 2 no registrador t6
    div a2, s10, t6 # Divide o número por 2 para obter uma aproximação inicial (k)

    li t2, 21 # Número de iterações para melhorar a precisão

# No livro estava falando de uma forma de chegar na raiz usando, no máximo, 10 iterações.
iteracoes_raiz:
    div t3, s10, a2 # Divide o número pelo valor atual de k (antes era s2)
    add a2, a2, t3 # Soma k com o resultado da divisão
    div a2, a2, t6 # Divide a soma por 2 para obter a nova aproximação (novo k)
    addi t2, t2, -1 # Decrementa o contador de iterações (antes era s1)
    bnez t2, iteracoes_raiz # Se ainda houver iterações restantes, repete o processo

    mv s10, a2 # Move o valor final da raiz quadrada para s10

    ret # Retorna da função, sendo a2 o lugar que vai estar armazenado a raiz quadrada final

# Exceção quando o número for zero
rq_zero:
    mv   s10, x0 # Retorna 0
    ret

# Exceção quando o número for um
rq_one:
    li   s10, 1 # Retorna 1
    ret

# a0 (sem sinal) -> "dddd" em [a1..a1+3]; avança a1
int_to_string:
    li   t5, 1000
    divu t0, a0, t5
    remu a0, a0, t5
    addi t0, t0, '0'
    sb   t0, 0(a1)

    li   t5, 100
    divu t0, a0, t5
    remu a0, a0, t5
    addi t0, t0, '0'
    sb   t0, 1(a1)

    li   t5, 10
    divu t0, a0, t5
    remu a0, a0, t5
    addi t0, t0, '0'
    sb   t0, 2(a1)

    addi t0, a0, '0'
    sb   t0, 3(a1)
    addi a1, a1, 4
    ret

# -----------------------------------------------------

# a0 (com sinal) -> "±dddd" em [a1..]; avança a1
int_to_string_signed:
    mv       t0, a0
    li       t1, '-'
    li       t2, '+'
    bltz     t0, its_neg
# positivo
    sb       t2, 0(a1)
    addi     a1, a1, 1
    mv       a0, t0
    call     int_to_string
    ret
its_neg:
    sb       t1, 0(a1)
    addi     a1, a1, 1
    sub      a0, x0, t0                     # abs
    call     int_to_string
    ret

# -----------------------------------------------------
# escolhe_x_s
# Usa diretamente os registradores salvos do programa:
#   s2  = x- (entrada) -> será também o x escolhido (saída)
#   s10 = x+ (entrada)
#   s11 = Xc
#   s3  = y
#   s8  = dC
# -----------------------------------------------------
escolhe_x_s:
    # pré-cálculos: y^2 e dC^2
    mul   t0, s3, s3            # t0 = y^2
    mul   t1, s8, s8            # t1 = dC^2

    # ---------- res_plus = | (x+ - Xc)^2 + y^2 - dC^2 |
    sub   t2, s10, s11
    mul   t2, t2, t2
    add   t2, t2, t0
    sub   t2, t2, t1
    bge   t2, x0, 1f
    sub   t2, x0, t2
1:  mv    t3, t2                # t3 = res_plus

    # ---------- res_minus = | (x- - Xc)^2 + y^2 - dC^2 |
    sub   t2, s2, s11
    mul   t2, t2, t2
    add   t2, t2, t0
    sub   t2, t2, t1
    bge   t2, x0, 2f
    sub   t2, x0, t2
2:  mv    t4, t2                # t4 = res_minus

    # comparar resíduos
    ble   t4, t3, 3f            # se res_minus <= res_plus, mantém s2
    mv    s2, s10               # senão, escolhe x+
3:  ret

imprime_saida_yx:
    la   t0, buffer
    mv   a1, t0

    # X primeiro
    mv   a0, s2
    call int_to_string_signed   # escreve ±dddd e avança a1

    # espaço
    li   t4, ' '
    sb   t4, 0(a1)
    addi a1, a1, 1

    # Y depois
    mv   a0, s3
    call int_to_string_signed   # escreve ±dddd e avança a1

    # newline
    li   t4, '\n'
    sb   t4, 0(a1)
    addi a1, a1, 1

    # escreve 12 bytes
    li   a0, 12
    call escrita
    ret


# Função principal do programa
main:

# Armazena o valor 10 (s4)
    li       s4, 10

# Velocidade (s5)
    li       s5, 3

# Leitura da string inicial
    call     leitura
    la       s0, buffer                     # Aponta para onde ler o número
    la       s1, buffer                     # Aponta para onde escrever o número

# Converte o Tempo A para número (s6)
    mv       a1, s0
    li       t3, 12                         # Índice para percorrer a segunda linha
    call     conversao_int
    mv       s6, a0                         # s6 = Tempo A

# Converte o Tempo B para número (s7)
    mv       a1, s0
    li       t3, 17                         # Índice para percorrer a segunda linha
    call     conversao_int
    mv       s7, a0                         # s7 = Tempo B

# Converte o Tempo C para número (s8)
    mv       a1, s0
    li       t3, 23                         # Índice para percorrer a segunda linha
    call     conversao_int
    mv       s8, a0                         # s8 = Tempo C

# Converte o Tempo R para número (s9)
    mv       a1, s0
    li       t3, 28                         # Índice para percorrer a segunda linha
    call     conversao_int
    mv       s9, a0                         # s9 = Tempo R

# Converte a coordenada Y b para número (s10)
    mv       a1, s0
    li       t3, 0                          # Índice para percorrer a primeira linha
    call     conversao_int_signed
    mv       s10, a0

# Converte a coordenada X c para número (s11)
    mv       a1, s0
    li       t3, 6                          # Índice para percorrer a primeira linha
    call     conversao_int_signed
    mv       s11, a0

# Distância de R até A ((TR - TA)*0,3) será armazenada em s6
    sub      s6, s9, s6
    mul      s6, s6, s5
    div      s6, s6, s4

# Distância de R até B ((TR - TB)*0,3) será armazenada em s7
    sub      s7, s9, s7
    mul      s7, s7, s5
    div      s7, s7, s4

# Distância de R até C ((TR - TC)*0,3) será armazenada em s8
    sub      s8, s9, s8
    mul      s8, s8, s5
    div      s8, s8, s4

# Armazena o valor -1 (s4)
    li       s4, -1

# Valor 2 (s5)
    li       s5, 2

# Vamos calcular a posição y (s3) usando s2 de apoio
    mul      s6, s6, s6                     # D_a ao quadrado
    mv       s3, s6
    mul      s2, s10, s10                   # Y_b ao quadrado
    add      s3, s3, s2                     # Soma D_a ao quadrado com Y_b ao quadrado
    mul      s2, s7, s7                     # D_b ao quadrado
    mul      s2, s2, s4                     # D_b ao quadrado negativo
    add      s3, s3, s2                     # Adiciona D_b ao quadrado negativo
    mul      s2, s10, s5                    # Multiplica Y_b por 2
    div      s3, s3, s2                     # Divide para encontrar o valor da posiçãp y (s3)

# Vamos calcular a posição x (s2)
    mul s7, s3, s3 # y ao quadrado, já que não vou mais usar D_b
    mul s7, s7, s4 # - y ao quadrado
    add s10, s7, s6 # Soma - y ao quadrado com D_a ao quadrado, não uso mais Y b
    call raiz_quadrada # A raiz positiva está armazenada em s10
    mul s2, s10, s4 # A raiz negativa está em s2
    call escolhe_x_s # Agora o s2 tem o valor final de x

# Imprime a saída
    call imprime_saida_yx

# Saída
    li       a0, 0                          # Código de saída
    li       a7, 93                         # Serviço de saída
    ecall