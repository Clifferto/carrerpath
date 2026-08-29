	.file	"memTool.c"
	.text
	.section	.rodata
.LC0:
	.string	"r"
.LC1:
	.string	"/proc/meminfo"
.LC2:
	.string	"%s%s%s\n"
.LC3:
	.string	"MemTotal:"
.LC4:
	.string	"MemFree:"
.LC5:
	.string	"MemAvailable:"
.LC6:
	.string	"SwapTotal:"
.LC7:
	.string	"SwapFree:"
	.align 8
.LC8:
	.string	"i. Obtener la memoria ram total, libre y disponible en Megabytes (1E6 no MiB):\n"
	.align 8
.LC9:
	.string	"------------------------------------------------------------------------------\n"
.LC10:
	.string	"Memoria total: %.1f MB\n"
.LC11:
	.string	"Memoria libre: %.1f MB\n"
.LC12:
	.string	"Memoria disponible: %.1f MB\n\n"
	.align 8
.LC13:
	.string	"ii. Obtener la memoria swap Ocupada:\n"
.LC14:
	.string	"Swap ocupada: %.1f MB\n\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$8032, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	.LC0(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -7976(%rbp)
	movl	$0, -8032(%rbp)
	jmp	.L2
.L3:
	leaq	-7968(%rbp), %rax
	movl	-8032(%rbp), %edx
	imulq	$150, %rdx, %rdx
	addq	$100, %rdx
	leaq	(%rax,%rdx), %rsi
	leaq	-7968(%rbp), %rax
	movl	-8032(%rbp), %edx
	imulq	$150, %rdx, %rdx
	addq	$50, %rdx
	leaq	(%rax,%rdx), %rcx
	leaq	-7968(%rbp), %rdx
	movl	-8032(%rbp), %eax
	imulq	$150, %rax, %rax
	addq	%rax, %rdx
	movq	-7976(%rbp), %rax
	movq	%rsi, %r8
	leaq	.LC2(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	addl	$1, -8032(%rbp)
.L2:
	cmpl	$52, -8032(%rbp)
	jbe	.L3
	movq	-7976(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movl	$0, -8008(%rbp)
	jmp	.L4
.L10:
	leaq	-7968(%rbp), %rdx
	movl	-8008(%rbp), %eax
	imulq	$150, %rax, %rax
	addq	%rdx, %rax
	leaq	.LC3(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L5
	movl	-8008(%rbp), %eax
	movl	%eax, -8028(%rbp)
.L5:
	leaq	-7968(%rbp), %rdx
	movl	-8008(%rbp), %eax
	imulq	$150, %rax, %rax
	addq	%rdx, %rax
	leaq	.LC4(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L6
	movl	-8008(%rbp), %eax
	movl	%eax, -8024(%rbp)
.L6:
	leaq	-7968(%rbp), %rdx
	movl	-8008(%rbp), %eax
	imulq	$150, %rax, %rax
	addq	%rdx, %rax
	leaq	.LC5(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L7
	movl	-8008(%rbp), %eax
	movl	%eax, -8020(%rbp)
.L7:
	leaq	-7968(%rbp), %rdx
	movl	-8008(%rbp), %eax
	imulq	$150, %rax, %rax
	addq	%rdx, %rax
	leaq	.LC6(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L8
	movl	-8008(%rbp), %eax
	movl	%eax, -8016(%rbp)
.L8:
	leaq	-7968(%rbp), %rdx
	movl	-8008(%rbp), %eax
	imulq	$150, %rax, %rax
	addq	%rdx, %rax
	leaq	.LC7(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L9
	movl	-8008(%rbp), %eax
	movl	%eax, -8012(%rbp)
.L9:
	addl	$1, -8008(%rbp)
.L4:
	cmpl	$52, -8008(%rbp)
	jbe	.L10
	movq	$0, -7984(%rbp)
	leaq	-7968(%rbp), %rax
	movl	-8028(%rbp), %edx
	imulq	$150, %rdx, %rdx
	addq	$50, %rdx
	leaq	(%rax,%rdx), %rcx
	leaq	-7984(%rbp), %rax
	movl	$10, %edx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strtol@PLT
	movq	%rax, %rcx
	movabsq	$2361183241434822607, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	sarq	$7, %rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2ssq	%rdx, %xmm0
	movss	%xmm0, -8004(%rbp)
	leaq	-7968(%rbp), %rax
	movl	-8024(%rbp), %edx
	imulq	$150, %rdx, %rdx
	addq	$50, %rdx
	leaq	(%rax,%rdx), %rcx
	leaq	-7984(%rbp), %rax
	movl	$10, %edx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strtol@PLT
	movq	%rax, %rcx
	movabsq	$2361183241434822607, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	sarq	$7, %rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2ssq	%rdx, %xmm0
	movss	%xmm0, -8000(%rbp)
	leaq	-7968(%rbp), %rax
	movl	-8020(%rbp), %edx
	imulq	$150, %rdx, %rdx
	addq	$50, %rdx
	leaq	(%rax,%rdx), %rcx
	leaq	-7984(%rbp), %rax
	movl	$10, %edx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strtol@PLT
	movq	%rax, %rcx
	movabsq	$2361183241434822607, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	sarq	$7, %rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2ssq	%rdx, %xmm0
	movss	%xmm0, -7996(%rbp)
	leaq	-7968(%rbp), %rax
	movl	-8016(%rbp), %edx
	imulq	$150, %rdx, %rdx
	addq	$50, %rdx
	leaq	(%rax,%rdx), %rcx
	leaq	-7984(%rbp), %rax
	movl	$10, %edx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strtol@PLT
	movq	%rax, %rcx
	movabsq	$2361183241434822607, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	sarq	$7, %rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2ssq	%rdx, %xmm0
	movss	%xmm0, -7992(%rbp)
	leaq	-7968(%rbp), %rax
	movl	-8012(%rbp), %edx
	imulq	$150, %rdx, %rdx
	addq	$50, %rdx
	leaq	(%rax,%rdx), %rcx
	leaq	-7984(%rbp), %rax
	movl	$10, %edx
	movq	%rax, %rsi
	movq	%rcx, %rdi
	call	strtol@PLT
	movq	%rax, %rcx
	movabsq	$2361183241434822607, %rdx
	movq	%rcx, %rax
	imulq	%rdx
	sarq	$7, %rdx
	movq	%rcx, %rax
	sarq	$63, %rax
	subq	%rax, %rdx
	pxor	%xmm0, %xmm0
	cvtsi2ssq	%rdx, %xmm0
	movss	%xmm0, -7988(%rbp)
	movq	stdout(%rip), %rax
	movq	%rax, %rcx
	movl	$79, %edx
	movl	$1, %esi
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rcx
	movl	$79, %edx
	movl	$1, %esi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	pxor	%xmm1, %xmm1
	cvtss2sd	-8004(%rbp), %xmm1
	movq	%xmm1, %rdx
	movq	stdout(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC10(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	pxor	%xmm2, %xmm2
	cvtss2sd	-8000(%rbp), %xmm2
	movq	%xmm2, %rdx
	movq	stdout(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC11(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	pxor	%xmm3, %xmm3
	cvtss2sd	-7996(%rbp), %xmm3
	movq	%xmm3, %rdx
	movq	stdout(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC12(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rcx
	movl	$37, %edx
	movl	$1, %esi
	leaq	.LC13(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rcx
	movl	$79, %edx
	movl	$1, %esi
	leaq	.LC9(%rip), %rax
	movq	%rax, %rdi
	call	fwrite@PLT
	movss	-7992(%rbp), %xmm0
	subss	-7988(%rbp), %xmm0
	pxor	%xmm4, %xmm4
	cvtss2sd	%xmm0, %xmm4
	movq	%xmm4, %rdx
	movq	stdout(%rip), %rax
	movq	%rdx, %xmm0
	leaq	.LC14(%rip), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$1, %eax
	call	fprintf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (GNU) 12.1.1 20220730"
	.section	.note.GNU-stack,"",@progbits
