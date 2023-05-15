#include "defs.h"
#include "proc.h"
#include "riscv.h"

/**
 * 	@brief 
 * 	创建一个管道。
 * 
 * 	@param f0 
 * 	@param f1 
 * 	@return int 
 */
int pipealloc(struct file *f0, struct file *f1)
{
	struct pipe *pi = 0;
	pi = (struct pipe *)kalloc();
	if (pi){ // 尝试分配内存空间给管道
		pi->readopen = 1; // 设置读标识为真
		pi->writeopen = 1; // 设置写标识为真
		pi->nwrite = 0; // 写入字节数为0
		pi->nread = 0; // 读取字节数为0
		// 管道两端的输入和输出被我们抽象成了两个文件。
		f0->type = FD_PIPE; // 文件描述符类型为pipe
		f0->readable = 1; // 设置为可读
		f0->writable = 0; // 设置为不可写
		f0->pipe = pi; // 分配文件描述符
		
		f1->type = FD_PIPE; // 文件描述符类型为pipe
		f1->readable = 0; // 设置为不可读
		f1->writable = 1; // 设置为可写
		f1->pipe = pi; // 分配文件描述符
		return 0;
	}
	else{
		kfree((char *)pi);
		return -1;
	}
}

/**
 *	@brief 
 * 	关闭管道，该函数可以关闭读写端的一个或全部，读写端都关闭，将释放管道。
 * @param pi 
 * @param writable 
 */
void pipeclose(struct pipe *pi, int writable)
{
	if (writable) {
		pi->writeopen = 0;
	} 
	else {
		pi->readopen = 0;
	}
	if (pi->readopen == 0 && pi->writeopen == 0) {
		kfree((char *)pi);
	}
}

/**
 * 	@brief 
 * 	管道的写入
 * @param pi 
 * @param addr 
 * @param n 字节数 
 * @return int 
 */
int pipewrite(struct pipe *pi, uint64 addr, int n)
{
	int w = 0; // 记录已经写的字节数
	uint64 size;
	struct proc *p = curr_proc();
	if (n <= 0) {
		panic("invalid read num");
	}
	while (w < n) {
		if (pi->readopen == 0) { // 管道不可读，写入没有意义
			return -1;
		}
		if (pi->nwrite == pi->nread + PIPESIZE) { // 写入端已满
			yield(); // 把当前进程让出 CPU，在等待其他进程耗尽 CPU 时间片，之后再尝试写入
		}
		else {
			// 计算一次读的字节数
			size = MIN(MIN(n - w, 
				    pi->nread + PIPESIZE - pi->nwrite),
				    PIPESIZE - (pi->nwrite % PIPESIZE));
			// 把用户空间中的数据从地址addr+w开始复制到内核空间中的管道缓冲区中的pi->data[pi->nwrite % PIPESIZE]处
			if (copyin(p->pagetable,
				   	&pi->data[pi->nwrite % PIPESIZE], addr + w,
				   	size) < 0) {
						panic("copyin");
			}
			// 更新管道记录的写入字节数和本次已写入的字节数
			pi->nwrite += size;
			w += size;
		}
	}
	return w;
}

/**
 * 	@brief 
 *	 管道的读取
 * @param pi 
 * @param addr 
 * @param n 
 * @return int 
 */
int piperead(struct pipe *pi, uint64 addr, int n)
{
	int r = 0; // 记录已经写的字节数
	uint64 size = -1;
	struct proc *p = curr_proc();
	if (n <= 0) {
		panic("invalid read num");
	}
	// 若管道可读内容为空，阻塞或报错
	while (pi->nread == pi->nwrite) {
		if (pi->writeopen)
			yield();
		else
			return -1;
	}
	while (r < n && size != 0) { 
		if (pi->nread == pi->nwrite) // // pipe 可读内容为空，返回
			break;
		// 计算一次写的字节数
		size = MIN(MIN(n - r, pi->nwrite - pi->nread),
			   	PIPESIZE - (pi->nread % PIPESIZE));
		// 使用 copyout 写用户内存
		if (copyout(p->pagetable, addr + r,
			    &pi->data[pi->nread % PIPESIZE], size) < 0) {
					panic("copyout");
		}
		pi->nread += size;
		r += size;
	}
	return r;
}
