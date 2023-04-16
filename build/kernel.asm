
build/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00030117          	auipc	sp,0x30
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	06a000ef          	jal	ra,80200072 <main>

000000008020000c <consputc>:
#include "console.h"
#include "sbi.h"

void consputc(int c)
{
    8020000c:	1141                	addi	sp,sp,-16
    8020000e:	e406                	sd	ra,8(sp)
    80200010:	e022                	sd	s0,0(sp)
    80200012:	0800                	addi	s0,sp,16
	console_putchar(c);
    80200014:	00000097          	auipc	ra,0x0
    80200018:	48c080e7          	jalr	1164(ra) # 802004a0 <console_putchar>
}
    8020001c:	60a2                	ld	ra,8(sp)
    8020001e:	6402                	ld	s0,0(sp)
    80200020:	0141                	addi	sp,sp,16
    80200022:	8082                	ret

0000000080200024 <console_init>:

void console_init()
{
    80200024:	1141                	addi	sp,sp,-16
    80200026:	e422                	sd	s0,8(sp)
    80200028:	0800                	addi	s0,sp,16
	// DO NOTHING
    8020002a:	6422                	ld	s0,8(sp)
    8020002c:	0141                	addi	sp,sp,16
    8020002e:	8082                	ret

0000000080200030 <threadid>:
extern char e_data[];
extern char s_bss[];
extern char e_bss[];

int threadid()
{
    80200030:	1141                	addi	sp,sp,-16
    80200032:	e422                	sd	s0,8(sp)
    80200034:	0800                	addi	s0,sp,16
	return 0;
}
    80200036:	4501                	li	a0,0
    80200038:	6422                	ld	s0,8(sp)
    8020003a:	0141                	addi	sp,sp,16
    8020003c:	8082                	ret

000000008020003e <clean_bss>:

void clean_bss()
{
    8020003e:	1141                	addi	sp,sp,-16
    80200040:	e422                	sd	s0,8(sp)
    80200042:	0800                	addi	s0,sp,16
	char *p;
	for (p = s_bss; p < e_bss; ++p)
    80200044:	00030717          	auipc	a4,0x30
    80200048:	fbc70713          	addi	a4,a4,-68 # 80230000 <boot_stack_top>
    8020004c:	00030797          	auipc	a5,0x30
    80200050:	fb478793          	addi	a5,a5,-76 # 80230000 <boot_stack_top>
    80200054:	00f77c63          	bgeu	a4,a5,8020006c <clean_bss+0x2e>
    80200058:	87ba                	mv	a5,a4
    8020005a:	00030717          	auipc	a4,0x30
    8020005e:	fa670713          	addi	a4,a4,-90 # 80230000 <boot_stack_top>
		*p = 0;
    80200062:	00078023          	sb	zero,0(a5)
	for (p = s_bss; p < e_bss; ++p)
    80200066:	0785                	addi	a5,a5,1
    80200068:	fee79de3          	bne	a5,a4,80200062 <clean_bss+0x24>
}
    8020006c:	6422                	ld	s0,8(sp)
    8020006e:	0141                	addi	sp,sp,16
    80200070:	8082                	ret

0000000080200072 <main>:

void main()
{
    80200072:	1141                	addi	sp,sp,-16
    80200074:	e406                	sd	ra,8(sp)
    80200076:	e022                	sd	s0,0(sp)
    80200078:	0800                	addi	s0,sp,16
	clean_bss();
    8020007a:	00000097          	auipc	ra,0x0
    8020007e:	fc4080e7          	jalr	-60(ra) # 8020003e <clean_bss>
	console_init();
    80200082:	00000097          	auipc	ra,0x0
    80200086:	fa2080e7          	jalr	-94(ra) # 80200024 <console_init>
	printf("\n");
    8020008a:	00001517          	auipc	a0,0x1
    8020008e:	0f650513          	addi	a0,a0,246 # 80201180 <e_text+0x180>
    80200092:	00000097          	auipc	ra,0x0
    80200096:	230080e7          	jalr	560(ra) # 802002c2 <printf>
	printf("hello world!\n");
    8020009a:	00001517          	auipc	a0,0x1
    8020009e:	f6650513          	addi	a0,a0,-154 # 80201000 <e_text>
    802000a2:	00000097          	auipc	ra,0x0
    802000a6:	220080e7          	jalr	544(ra) # 802002c2 <printf>
	printf("你是个大笨蛋\n");
    802000aa:	00001517          	auipc	a0,0x1
    802000ae:	f6650513          	addi	a0,a0,-154 # 80201010 <e_text+0x10>
    802000b2:	00000097          	auipc	ra,0x0
    802000b6:	210080e7          	jalr	528(ra) # 802002c2 <printf>
	errorf("stext: %p", s_text);
    802000ba:	00000717          	auipc	a4,0x0
    802000be:	f4670713          	addi	a4,a4,-186 # 80200000 <_entry>
    802000c2:	4681                	li	a3,0
    802000c4:	00001617          	auipc	a2,0x1
    802000c8:	f6460613          	addi	a2,a2,-156 # 80201028 <e_text+0x28>
    802000cc:	45fd                	li	a1,31
    802000ce:	00001517          	auipc	a0,0x1
    802000d2:	f6250513          	addi	a0,a0,-158 # 80201030 <e_text+0x30>
    802000d6:	00000097          	auipc	ra,0x0
    802000da:	1ec080e7          	jalr	492(ra) # 802002c2 <printf>
	warnf("etext: %p", e_text);
    802000de:	00001717          	auipc	a4,0x1
    802000e2:	f2270713          	addi	a4,a4,-222 # 80201000 <e_text>
    802000e6:	4681                	li	a3,0
    802000e8:	00001617          	auipc	a2,0x1
    802000ec:	f6860613          	addi	a2,a2,-152 # 80201050 <e_text+0x50>
    802000f0:	05d00593          	li	a1,93
    802000f4:	00001517          	auipc	a0,0x1
    802000f8:	f6450513          	addi	a0,a0,-156 # 80201058 <e_text+0x58>
    802000fc:	00000097          	auipc	ra,0x0
    80200100:	1c6080e7          	jalr	454(ra) # 802002c2 <printf>
	infof("sroda: %p", s_rodata);
    80200104:	00001717          	auipc	a4,0x1
    80200108:	efc70713          	addi	a4,a4,-260 # 80201000 <e_text>
    8020010c:	4681                	li	a3,0
    8020010e:	00001617          	auipc	a2,0x1
    80200112:	f6a60613          	addi	a2,a2,-150 # 80201078 <e_text+0x78>
    80200116:	02200593          	li	a1,34
    8020011a:	00001517          	auipc	a0,0x1
    8020011e:	f6650513          	addi	a0,a0,-154 # 80201080 <e_text+0x80>
    80200122:	00000097          	auipc	ra,0x0
    80200126:	1a0080e7          	jalr	416(ra) # 802002c2 <printf>
	debugf("eroda: %p", e_rodata);
    8020012a:	00002717          	auipc	a4,0x2
    8020012e:	ed670713          	addi	a4,a4,-298 # 80202000 <_app_num>
    80200132:	4681                	li	a3,0
    80200134:	00001617          	auipc	a2,0x1
    80200138:	f6c60613          	addi	a2,a2,-148 # 802010a0 <e_text+0xa0>
    8020013c:	02000593          	li	a1,32
    80200140:	00001517          	auipc	a0,0x1
    80200144:	f6850513          	addi	a0,a0,-152 # 802010a8 <e_text+0xa8>
    80200148:	00000097          	auipc	ra,0x0
    8020014c:	17a080e7          	jalr	378(ra) # 802002c2 <printf>
	debugf("sdata: %p", s_data);
    80200150:	00002717          	auipc	a4,0x2
    80200154:	eb070713          	addi	a4,a4,-336 # 80202000 <_app_num>
    80200158:	4681                	li	a3,0
    8020015a:	00001617          	auipc	a2,0x1
    8020015e:	f4660613          	addi	a2,a2,-186 # 802010a0 <e_text+0xa0>
    80200162:	02000593          	li	a1,32
    80200166:	00001517          	auipc	a0,0x1
    8020016a:	f6250513          	addi	a0,a0,-158 # 802010c8 <e_text+0xc8>
    8020016e:	00000097          	auipc	ra,0x0
    80200172:	154080e7          	jalr	340(ra) # 802002c2 <printf>
	infof("edata: %p", e_data);
    80200176:	00020717          	auipc	a4,0x20
    8020017a:	e8a70713          	addi	a4,a4,-374 # 80220000 <boot_stack>
    8020017e:	4681                	li	a3,0
    80200180:	00001617          	auipc	a2,0x1
    80200184:	ef860613          	addi	a2,a2,-264 # 80201078 <e_text+0x78>
    80200188:	02200593          	li	a1,34
    8020018c:	00001517          	auipc	a0,0x1
    80200190:	f5c50513          	addi	a0,a0,-164 # 802010e8 <e_text+0xe8>
    80200194:	00000097          	auipc	ra,0x0
    80200198:	12e080e7          	jalr	302(ra) # 802002c2 <printf>
	warnf("sbss : %p", s_bss);
    8020019c:	00030717          	auipc	a4,0x30
    802001a0:	e6470713          	addi	a4,a4,-412 # 80230000 <boot_stack_top>
    802001a4:	4681                	li	a3,0
    802001a6:	00001617          	auipc	a2,0x1
    802001aa:	eaa60613          	addi	a2,a2,-342 # 80201050 <e_text+0x50>
    802001ae:	05d00593          	li	a1,93
    802001b2:	00001517          	auipc	a0,0x1
    802001b6:	f5650513          	addi	a0,a0,-170 # 80201108 <e_text+0x108>
    802001ba:	00000097          	auipc	ra,0x0
    802001be:	108080e7          	jalr	264(ra) # 802002c2 <printf>
	errorf("ebss : %p", e_bss);
    802001c2:	00030717          	auipc	a4,0x30
    802001c6:	e3e70713          	addi	a4,a4,-450 # 80230000 <boot_stack_top>
    802001ca:	4681                	li	a3,0
    802001cc:	00001617          	auipc	a2,0x1
    802001d0:	e5c60613          	addi	a2,a2,-420 # 80201028 <e_text+0x28>
    802001d4:	45fd                	li	a1,31
    802001d6:	00001517          	auipc	a0,0x1
    802001da:	f5250513          	addi	a0,a0,-174 # 80201128 <e_text+0x128>
    802001de:	00000097          	auipc	ra,0x0
    802001e2:	0e4080e7          	jalr	228(ra) # 802002c2 <printf>
	panic("ALL DONE");
    802001e6:	02800793          	li	a5,40
    802001ea:	00001717          	auipc	a4,0x1
    802001ee:	f5e70713          	addi	a4,a4,-162 # 80201148 <e_text+0x148>
    802001f2:	4681                	li	a3,0
    802001f4:	00001617          	auipc	a2,0x1
    802001f8:	f6460613          	addi	a2,a2,-156 # 80201158 <e_text+0x158>
    802001fc:	45fd                	li	a1,31
    802001fe:	00001517          	auipc	a0,0x1
    80200202:	f6250513          	addi	a0,a0,-158 # 80201160 <e_text+0x160>
    80200206:	00000097          	auipc	ra,0x0
    8020020a:	0bc080e7          	jalr	188(ra) # 802002c2 <printf>
    8020020e:	00000097          	auipc	ra,0x0
    80200212:	2c2080e7          	jalr	706(ra) # 802004d0 <shutdown>
}
    80200216:	60a2                	ld	ra,8(sp)
    80200218:	6402                	ld	s0,0(sp)
    8020021a:	0141                	addi	sp,sp,16
    8020021c:	8082                	ret

000000008020021e <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    8020021e:	7179                	addi	sp,sp,-48
    80200220:	f406                	sd	ra,40(sp)
    80200222:	f022                	sd	s0,32(sp)
    80200224:	ec26                	sd	s1,24(sp)
    80200226:	e84a                	sd	s2,16(sp)
    80200228:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    8020022a:	c219                	beqz	a2,80200230 <printint+0x12>
    8020022c:	00054d63          	bltz	a0,80200246 <printint+0x28>
		x = -xx;
	else
		x = xx;
    80200230:	2501                	sext.w	a0,a0
    80200232:	4881                	li	a7,0
    80200234:	fd040713          	addi	a4,s0,-48

	i = 0;
    80200238:	4601                	li	a2,0
	do {
		buf[i++] = digits[x % base];
    8020023a:	2581                	sext.w	a1,a1
    8020023c:	00001817          	auipc	a6,0x1
    80200240:	f4c80813          	addi	a6,a6,-180 # 80201188 <digits>
    80200244:	a039                	j	80200252 <printint+0x34>
		x = -xx;
    80200246:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    8020024a:	4885                	li	a7,1
		x = -xx;
    8020024c:	b7e5                	j	80200234 <printint+0x16>
	} while ((x /= base) != 0);
    8020024e:	853e                	mv	a0,a5
		buf[i++] = digits[x % base];
    80200250:	8636                	mv	a2,a3
    80200252:	0016069b          	addiw	a3,a2,1
    80200256:	02b577bb          	remuw	a5,a0,a1
    8020025a:	1782                	slli	a5,a5,0x20
    8020025c:	9381                	srli	a5,a5,0x20
    8020025e:	97c2                	add	a5,a5,a6
    80200260:	0007c783          	lbu	a5,0(a5)
    80200264:	00f70023          	sb	a5,0(a4)
    80200268:	0705                	addi	a4,a4,1
	} while ((x /= base) != 0);
    8020026a:	02b557bb          	divuw	a5,a0,a1
    8020026e:	feb570e3          	bgeu	a0,a1,8020024e <printint+0x30>

	if (sign)
    80200272:	00088b63          	beqz	a7,80200288 <printint+0x6a>
		buf[i++] = '-';
    80200276:	fe040793          	addi	a5,s0,-32
    8020027a:	96be                	add	a3,a3,a5
    8020027c:	02d00793          	li	a5,45
    80200280:	fef68823          	sb	a5,-16(a3)
    80200284:	0026069b          	addiw	a3,a2,2

	while (--i >= 0)
    80200288:	02d05763          	blez	a3,802002b6 <printint+0x98>
    8020028c:	fd040793          	addi	a5,s0,-48
    80200290:	00d784b3          	add	s1,a5,a3
    80200294:	fff78913          	addi	s2,a5,-1
    80200298:	9936                	add	s2,s2,a3
    8020029a:	36fd                	addiw	a3,a3,-1
    8020029c:	1682                	slli	a3,a3,0x20
    8020029e:	9281                	srli	a3,a3,0x20
    802002a0:	40d90933          	sub	s2,s2,a3
		consputc(buf[i]);
    802002a4:	fff4c503          	lbu	a0,-1(s1)
    802002a8:	00000097          	auipc	ra,0x0
    802002ac:	d64080e7          	jalr	-668(ra) # 8020000c <consputc>
    802002b0:	14fd                	addi	s1,s1,-1
	while (--i >= 0)
    802002b2:	ff2499e3          	bne	s1,s2,802002a4 <printint+0x86>
}
    802002b6:	70a2                	ld	ra,40(sp)
    802002b8:	7402                	ld	s0,32(sp)
    802002ba:	64e2                	ld	s1,24(sp)
    802002bc:	6942                	ld	s2,16(sp)
    802002be:	6145                	addi	sp,sp,48
    802002c0:	8082                	ret

00000000802002c2 <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    802002c2:	7131                	addi	sp,sp,-192
    802002c4:	fc86                	sd	ra,120(sp)
    802002c6:	f8a2                	sd	s0,112(sp)
    802002c8:	f4a6                	sd	s1,104(sp)
    802002ca:	f0ca                	sd	s2,96(sp)
    802002cc:	ecce                	sd	s3,88(sp)
    802002ce:	e8d2                	sd	s4,80(sp)
    802002d0:	e4d6                	sd	s5,72(sp)
    802002d2:	e0da                	sd	s6,64(sp)
    802002d4:	fc5e                	sd	s7,56(sp)
    802002d6:	f862                	sd	s8,48(sp)
    802002d8:	f466                	sd	s9,40(sp)
    802002da:	f06a                	sd	s10,32(sp)
    802002dc:	ec6e                	sd	s11,24(sp)
    802002de:	0100                	addi	s0,sp,128
    802002e0:	8a2a                	mv	s4,a0
    802002e2:	e40c                	sd	a1,8(s0)
    802002e4:	e810                	sd	a2,16(s0)
    802002e6:	ec14                	sd	a3,24(s0)
    802002e8:	f018                	sd	a4,32(s0)
    802002ea:	f41c                	sd	a5,40(s0)
    802002ec:	03043823          	sd	a6,48(s0)
    802002f0:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    802002f4:	c915                	beqz	a0,80200328 <printf+0x66>
		panic("null fmt");

	va_start(ap, fmt);
    802002f6:	00840793          	addi	a5,s0,8
    802002fa:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802002fe:	000a4503          	lbu	a0,0(s4)
    80200302:	18050063          	beqz	a0,80200482 <printf+0x1c0>
    80200306:	4481                	li	s1,0
		if (c != '%') {
    80200308:	02500993          	li	s3,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    8020030c:	07000a93          	li	s5,112
	consputc('x');
    80200310:	4cc1                	li	s9,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80200312:	00001b17          	auipc	s6,0x1
    80200316:	e76b0b13          	addi	s6,s6,-394 # 80201188 <digits>
		switch (c) {
    8020031a:	07300c13          	li	s8,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    8020031e:	02800d13          	li	s10,40
		switch (c) {
    80200322:	06400b93          	li	s7,100
    80200326:	a889                	j	80200378 <printf+0xb6>
		panic("null fmt");
    80200328:	00000097          	auipc	ra,0x0
    8020032c:	d08080e7          	jalr	-760(ra) # 80200030 <threadid>
    80200330:	02e00793          	li	a5,46
    80200334:	00001717          	auipc	a4,0x1
    80200338:	e7470713          	addi	a4,a4,-396 # 802011a8 <digits+0x20>
    8020033c:	86aa                	mv	a3,a0
    8020033e:	00001617          	auipc	a2,0x1
    80200342:	e1a60613          	addi	a2,a2,-486 # 80201158 <e_text+0x158>
    80200346:	45fd                	li	a1,31
    80200348:	00001517          	auipc	a0,0x1
    8020034c:	e7050513          	addi	a0,a0,-400 # 802011b8 <digits+0x30>
    80200350:	00000097          	auipc	ra,0x0
    80200354:	f72080e7          	jalr	-142(ra) # 802002c2 <printf>
    80200358:	00000097          	auipc	ra,0x0
    8020035c:	178080e7          	jalr	376(ra) # 802004d0 <shutdown>
    80200360:	bf59                	j	802002f6 <printf+0x34>
			consputc(c);
    80200362:	00000097          	auipc	ra,0x0
    80200366:	caa080e7          	jalr	-854(ra) # 8020000c <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    8020036a:	2485                	addiw	s1,s1,1
    8020036c:	009a07b3          	add	a5,s4,s1
    80200370:	0007c503          	lbu	a0,0(a5)
    80200374:	10050763          	beqz	a0,80200482 <printf+0x1c0>
		if (c != '%') {
    80200378:	ff3515e3          	bne	a0,s3,80200362 <printf+0xa0>
		c = fmt[++i] & 0xff;
    8020037c:	2485                	addiw	s1,s1,1
    8020037e:	009a07b3          	add	a5,s4,s1
    80200382:	0007c783          	lbu	a5,0(a5)
    80200386:	0007891b          	sext.w	s2,a5
		if (c == 0)
    8020038a:	0e090c63          	beqz	s2,80200482 <printf+0x1c0>
		switch (c) {
    8020038e:	05578a63          	beq	a5,s5,802003e2 <printf+0x120>
    80200392:	02faf663          	bgeu	s5,a5,802003be <printf+0xfc>
    80200396:	09878963          	beq	a5,s8,80200428 <printf+0x166>
    8020039a:	07800713          	li	a4,120
    8020039e:	0ce79763          	bne	a5,a4,8020046c <printf+0x1aa>
			printint(va_arg(ap, int), 16, 1);
    802003a2:	f8843783          	ld	a5,-120(s0)
    802003a6:	00878713          	addi	a4,a5,8
    802003aa:	f8e43423          	sd	a4,-120(s0)
    802003ae:	4605                	li	a2,1
    802003b0:	85e6                	mv	a1,s9
    802003b2:	4388                	lw	a0,0(a5)
    802003b4:	00000097          	auipc	ra,0x0
    802003b8:	e6a080e7          	jalr	-406(ra) # 8020021e <printint>
			break;
    802003bc:	b77d                	j	8020036a <printf+0xa8>
		switch (c) {
    802003be:	0b378163          	beq	a5,s3,80200460 <printf+0x19e>
    802003c2:	0b779563          	bne	a5,s7,8020046c <printf+0x1aa>
			printint(va_arg(ap, int), 10, 1);
    802003c6:	f8843783          	ld	a5,-120(s0)
    802003ca:	00878713          	addi	a4,a5,8
    802003ce:	f8e43423          	sd	a4,-120(s0)
    802003d2:	4605                	li	a2,1
    802003d4:	45a9                	li	a1,10
    802003d6:	4388                	lw	a0,0(a5)
    802003d8:	00000097          	auipc	ra,0x0
    802003dc:	e46080e7          	jalr	-442(ra) # 8020021e <printint>
			break;
    802003e0:	b769                	j	8020036a <printf+0xa8>
			printptr(va_arg(ap, uint64));
    802003e2:	f8843783          	ld	a5,-120(s0)
    802003e6:	00878713          	addi	a4,a5,8
    802003ea:	f8e43423          	sd	a4,-120(s0)
    802003ee:	0007bd83          	ld	s11,0(a5)
	consputc('0');
    802003f2:	03000513          	li	a0,48
    802003f6:	00000097          	auipc	ra,0x0
    802003fa:	c16080e7          	jalr	-1002(ra) # 8020000c <consputc>
	consputc('x');
    802003fe:	07800513          	li	a0,120
    80200402:	00000097          	auipc	ra,0x0
    80200406:	c0a080e7          	jalr	-1014(ra) # 8020000c <consputc>
    8020040a:	8966                	mv	s2,s9
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8020040c:	03cdd793          	srli	a5,s11,0x3c
    80200410:	97da                	add	a5,a5,s6
    80200412:	0007c503          	lbu	a0,0(a5)
    80200416:	00000097          	auipc	ra,0x0
    8020041a:	bf6080e7          	jalr	-1034(ra) # 8020000c <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8020041e:	0d92                	slli	s11,s11,0x4
    80200420:	397d                	addiw	s2,s2,-1
    80200422:	fe0915e3          	bnez	s2,8020040c <printf+0x14a>
    80200426:	b791                	j	8020036a <printf+0xa8>
			if ((s = va_arg(ap, char *)) == 0)
    80200428:	f8843783          	ld	a5,-120(s0)
    8020042c:	00878713          	addi	a4,a5,8
    80200430:	f8e43423          	sd	a4,-120(s0)
    80200434:	0007b903          	ld	s2,0(a5)
    80200438:	00090e63          	beqz	s2,80200454 <printf+0x192>
			for (; *s; s++)
    8020043c:	00094503          	lbu	a0,0(s2)
    80200440:	d50d                	beqz	a0,8020036a <printf+0xa8>
				consputc(*s);
    80200442:	00000097          	auipc	ra,0x0
    80200446:	bca080e7          	jalr	-1078(ra) # 8020000c <consputc>
			for (; *s; s++)
    8020044a:	0905                	addi	s2,s2,1
    8020044c:	00094503          	lbu	a0,0(s2)
    80200450:	f96d                	bnez	a0,80200442 <printf+0x180>
    80200452:	bf21                	j	8020036a <printf+0xa8>
				s = "(null)";
    80200454:	00001917          	auipc	s2,0x1
    80200458:	d4c90913          	addi	s2,s2,-692 # 802011a0 <digits+0x18>
			for (; *s; s++)
    8020045c:	856a                	mv	a0,s10
    8020045e:	b7d5                	j	80200442 <printf+0x180>
			break;
		case '%':
			consputc('%');
    80200460:	854e                	mv	a0,s3
    80200462:	00000097          	auipc	ra,0x0
    80200466:	baa080e7          	jalr	-1110(ra) # 8020000c <consputc>
			break;
    8020046a:	b701                	j	8020036a <printf+0xa8>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    8020046c:	854e                	mv	a0,s3
    8020046e:	00000097          	auipc	ra,0x0
    80200472:	b9e080e7          	jalr	-1122(ra) # 8020000c <consputc>
			consputc(c);
    80200476:	854a                	mv	a0,s2
    80200478:	00000097          	auipc	ra,0x0
    8020047c:	b94080e7          	jalr	-1132(ra) # 8020000c <consputc>
			break;
    80200480:	b5ed                	j	8020036a <printf+0xa8>
		}
	}
    80200482:	70e6                	ld	ra,120(sp)
    80200484:	7446                	ld	s0,112(sp)
    80200486:	74a6                	ld	s1,104(sp)
    80200488:	7906                	ld	s2,96(sp)
    8020048a:	69e6                	ld	s3,88(sp)
    8020048c:	6a46                	ld	s4,80(sp)
    8020048e:	6aa6                	ld	s5,72(sp)
    80200490:	6b06                	ld	s6,64(sp)
    80200492:	7be2                	ld	s7,56(sp)
    80200494:	7c42                	ld	s8,48(sp)
    80200496:	7ca2                	ld	s9,40(sp)
    80200498:	7d02                	ld	s10,32(sp)
    8020049a:	6de2                	ld	s11,24(sp)
    8020049c:	6129                	addi	sp,sp,192
    8020049e:	8082                	ret

00000000802004a0 <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    802004a0:	1141                	addi	sp,sp,-16
    802004a2:	e422                	sd	s0,8(sp)
    802004a4:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    802004a6:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802004a8:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802004aa:	4885                	li	a7,1
	asm volatile("ecall"
    802004ac:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    802004b0:	6422                	ld	s0,8(sp)
    802004b2:	0141                	addi	sp,sp,16
    802004b4:	8082                	ret

00000000802004b6 <console_getchar>:

int console_getchar()
{
    802004b6:	1141                	addi	sp,sp,-16
    802004b8:	e422                	sd	s0,8(sp)
    802004ba:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802004bc:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802004be:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802004c0:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802004c2:	4889                	li	a7,2
	asm volatile("ecall"
    802004c4:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    802004c8:	2501                	sext.w	a0,a0
    802004ca:	6422                	ld	s0,8(sp)
    802004cc:	0141                	addi	sp,sp,16
    802004ce:	8082                	ret

00000000802004d0 <shutdown>:

void shutdown()
{
    802004d0:	1141                	addi	sp,sp,-16
    802004d2:	e422                	sd	s0,8(sp)
    802004d4:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802004d6:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802004d8:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802004da:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802004dc:	48a1                	li	a7,8
	asm volatile("ecall"
    802004de:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
    802004e2:	6422                	ld	s0,8(sp)
    802004e4:	0141                	addi	sp,sp,16
    802004e6:	8082                	ret
	...
