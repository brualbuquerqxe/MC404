.globl _start

_start:
  li x11, 21          # loads the value 21 into register x11
  li x12, 21          # loads the value 21 into register x12
  add x10, x11, x12   # adds the contents of registers x11 and x12 and
                      # stores the result in register x10
  li a7, 93           # loads the value 93 into register a7
  ecall               # generates a software interrupt
