
# Seção para armazenar a entrada no buffer
    .section .bss
buffer:
# Para facilitar, vou fazer a escrita da saída aqui também
    .skip    32

# Seção em que está o código e as definições das funcões
    .section .text

    .globl   _start
    .globl   leitura_linha1
    .globl   leitura_linha2
    .globl   escrita
    .globl   conversao_int

    .globl   raiz_quadrada
    .globl   main
    .globl   int_to_string_signed

# Inicia o programa a partir do rótulo "_start".
_start:
    call     main
    li       a0, 0                          # Código de saída
    li       a7, 93                         # Serviço de saída
    ecall

# Função que vai ler a primeira linha de entrada
leitura_linha1:
    li       a0, 0                          # Entrada padrão
    la       a1, buffer1                    # Onde a entrada será armazenada
    li       a2, 12                         # Número de bytes que serão lidos
    li       a7, 63                         # read
    ecall                                   # Chama sistema
    ret                                     # Retorna

# Função que vai ler a segunda linha de entrada
leitura_linha2:
    li       a0, 0                          # Entrada padrão
    la       a1, buffer2                    # Onde a entrada será armazenada
    li       a2, 20                         # Número de bytes que serão lidos
    li       a7, 63                         # read
    ecall                                   # Chama sistema
    ret                                     # Retorna

# Escreve 12 bytes do 'buffer' na saída padrão
escrita:
    li       a0, 1                          # Saída padrão
    la       a1, buffer                     # Endereço do buffer de saída
    li       a2, 12                         # 12 bytes será o tamanho da saída
    li       a7, 64                         # write
    ecall
    ret

# Extrai o número da string armazenada no buffer e o converte para um valor inteiro.
conversao_int:
    li       t2, 4                          # São 4 algarismos na entrada
    li       a0, 0                          # Acumulador
    li       t1, 1000                       # Multiplicador inicial (1000)
    li       t4, 10                         # Base 10

# Converte cada algarismo da string em um número inteiro.
repeticao_extracao_numero:
    add      t5, a1, t3                     # Endereço do caractere atual
    lbu      t0, 0(t5)                      # Lê caractere
    addi     t0, t0, -'0'                   # ASCII -> inteiro
    mul      t0, t0, t1                     # Multiplica pelo multiplicador
    add      a0, a0, t0                     # Soma no acumulador

    addi     t3, t3, 1                      # Próximo caractere
    addi     t2, t2, -1                     # Decrementa contador
    div      t1, t1, t4                     # Atualiza multiplicador

    bnez     t2, repeticao_extracao_numero  # Loop enquanto restarem dígitos
    ret

# Calcula a raiz quadrada inteira de s10 (método iterativo)
raiz_quadrada:
    beqz     s10, rq_zero                   # sqrt(0) = 0
    li       t1, 1
    beq      s10, t1, rq_one                # sqrt(1) = 1

    li       t6, 2
    div      a2, s10, t6                    # chute inicial k = n/2
    li       t2, 21                         # iterações

iteracoes_raiz:
    div      t3, s10, a2
    add      a2, a2, t3
    div      a2, a2, t6
    addi     t2, t2, -1
    bnez     t2, iteracoes_raiz

    mv       s10, a2                        # retorna em s10
    ret

rq_zero:
    mv       s10, x0
    ret
rq_one:
    li       s10, 1
    ret

# a0 (sem sinal) -> "dddd" em [a1..a1+3]; avança a1
int_to_string:
    li       t5, 1000
    divu     t0, a0, t5
    remu     a0, a0, t5
    addi     t0, t0, '0'
    sb       t0, 0(a1)

    li       t5, 100
    divu     t0, a0, t5
    remu     a0, a0, t5
    addi     t0, t0, '0'
    sb       t0, 1(a1)

    li       t5, 10
    divu     t0, a0, t5
    remu     a0, a0, t5
    addi     t0, t0, '0'
    sb       t0, 2(a1)

    addi     t0, a0, '0'
    sb       t0, 3(a1)
    addi     a1, a1, 4
    ret

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

# Escolhe o x correto comparando resíduos com a equação de C
# Usa:
#   s2  = x- (entrada) -> será também o x escolhido (saída)
#   s10 = x+ (entrada)
#   s11 = Xc
#   s3  = y
#   s8  = dC
escolhe_x_s:
    # pré-cálculos: y^2 e dC^2
    mul      t0, s3, s3                     # t0 = y^2
    mul      t1, s8, s8                     # t1 = dC^2

    # res_plus = | (x+ - Xc)^2 + y^2 - dC^2 |
    sub      t2, s10, s11
    mul      t2, t2, t2
    add      t2, t2, t0
    sub      t2, t2, t1
    bge      t2, x0, 1f
    sub      t2, x0, t2
1:  mv       t3, t2                          # t3 = res_plus

    # res_minus = | (x- - Xc)^2 + y^2 - dC^2 |
    sub      t2, s2, s11
    mul      t2, t2, t2
    add      t2, t2, t0
    sub      t2, t2, t1
    bge      t2, x0, 2f
    sub      t2, x0, t2
2:  mv       t4, t2                          # t4 = res_minus

    # comparar resíduos
    ble      t4, t3, 3f                      # se res_minus <= res_plus, mantém s2
    mv       s2, s10                         # senão, escolhe x+
3:  ret

# Constrói a linha "±dddd ±dddd\n" em 'buffer' e imprime
imprime_saida_yx:
    la       t0, buffer
    mv       a1, t0

    # X primeiro
    mv       a0, s2
    call     int_to_string_signed           # escreve ±dddd e avança a1

    # espaço
    li       t4, ' '
    sb       t4, 0(a1)
    addi     a1, a1, 1

    # Y depois
    mv       a0, s3
    call     int_to_string_signed           # escreve ±dddd e avança a1

    # newline
    li       t4, '\n'
    sb       t4, 0(a1)
    addi     a1, a1, 1

    # escreve 12 bytes
    call     escrita
    ret

# Função principal do programa
main:
    # Constantes
    li       s4, 10                         # divisor 10
    li       s5, 3                          # velocidade = 3 (para 0,3)

    # Leitura da 1ª linha (Yb Xc)
    jal      leitura_linha1
    la       s0, buffer1                    # base para conversões da 1ª linha

    # Yb -> s10
    mv       a1, s0
    li       t3, 0
    jal      conversao_int_signed
    mv       s10, a0

    # Xc -> s11
    mv       a1, s0
    li       t3, 6
    jal      conversao_int_signed
    mv       s11, a0

    # Leitura da 2ª linha (TA TB TC TR)
    jal      leitura_linha2
    la       s0, buffer2                    # base para conversões da 2ª linha

    # TA -> s6
    mv       a1, s0
    li       t3, 0
    call     conversao_int
    mv       s6, a0

    # TB -> s7
    mv       a1, s0
    li       t3, 5
    call     conversao_int
    mv       s7, a0

    # TC -> s8
    mv       a1, s0
    li       t3, 10
    call     conversao_int
    mv       s8, a0

    # TR -> s9
    mv       a1, s0
    li       t3, 15
    call     conversao_int
    mv       s9, a0

    # Distâncias: d = (TR - T?)*0,3  => *3/10
    sub      s6, s9, s6
    mul      s6, s6, s5
    div      s6, s6, s4                     # dA em s6

    sub      s7, s9, s7
    mul      s7, s7, s5
    div      s7, s7, s4                     # dB em s7

    sub      s8, s9, s8
    mul      s8, s8, s5
    div      s8, s8, s4                     # dC em s8

    # Preparos
    li       s4, -1                         # -1
    li       s5, 2                          # 2

    # y = (dA^2 + Yb^2 - dB^2)/(2*Yb)
    mul      s6, s6, s6                     # dA^2
    mv       s3, s6
    mul      s2, s10, s10                   # Yb^2
    add      s3, s3, s2                     # dA^2 + Yb^2
    mul      s2, s7, s7                     # dB^2
    mul      s2, s2, s4                     # -dB^2
    add      s3, s3, s2
    mul      s2, s10, s5                    # 2*Yb
    div      s3, s3, s2                     # y em s3

    # x = ±sqrt(dA^2 - y^2) e escolhe com Eq. 3
    mul      s7, s3, s3                     # y^2
    mul      s7, s7, s4                     # -y^2
    add      s10, s7, s6                    # dA^2 - y^2  (em s10)
    call     raiz_quadrada                  # sqrt(...) -> s10
    mul      s2, s10, s4                    # x- = -sqrt(...)
    call     escolhe_x_s                    # decide entre x- e x+

    # Imprime
    call     imprime_saida_yx

    # Saída
    li       a0, 0
    li       a7, 93
    ecall

    .data
buffer1: .skip 12     # first line input buffer
buffer2: .skip 20     # second line input buffer
buffer3: .skip 12     # (não usado; mantido se quiser comparar)
