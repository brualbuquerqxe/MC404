	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_zicsr2p0_zifencei2p0"
	.file	"prog.c"
	.globl	main_start                      # -- Begin function main_start
	.p2align	2
	.type	main_start,@function
main_start:                             # @main_start
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	li	a0, 42
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	main_start, .Lfunc_end0-main_start
                                        # -- End function
	.ident	"Homebrew clang version 17.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
