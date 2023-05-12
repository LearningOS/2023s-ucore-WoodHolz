#ifndef FILE_H
#define FILE_H

#include "fs.h"
#include "proc.h"
#include "types.h"

#define PIPESIZE (512)
#define FILEPOOLSIZE (NPROC * FD_BUFFER_SIZE)

// inode的内存副本，用于快速定位磁盘上的文件实体。
struct inode {
	uint dev; // 设备数量
	uint inum; // Inode编号
	int ref; // 引用计数
	int valid; // 表示inode是否被磁盘读取
	short type; // disk inode的拷贝
	uint size;
	uint addrs[NDIRECT + 1];
	// LAB4: You may need to add link count here
};

// 管道结构
struct pipe {
	char data[PIPESIZE];
	uint nread; // 读取的字节数
	uint nwrite; // 写入的字节数
	int readopen; // 读取文件描述符是否仍然打开
	int writeopen; // 写入文件描述符是否仍然打开
};

// file.h的核心
// 该结构体在内存中表示一个文件，提供了该文件当前使用情况以及相应的 inode 位置的信息。
struct file {
	enum { FD_NONE = 0, FD_PIPE, FD_INODE, FD_STDIO } type;
	int ref; // 引用计数
	char readable;
	char writable;
	struct pipe *pipe; // FD_PIPE
	struct inode *ip; // FD_INODE
	uint off;
};

// 特殊的文件描述符
enum {
	STDIN = 0, // 标准输入
	STDOUT = 1, // 标准输出
	STDERR = 2, // 标准错误
};

extern struct file filepool[FILEPOOLSIZE];

int pipealloc(struct file *, struct file *);
void pipeclose(struct pipe *, int);
int piperead(struct pipe *, uint64, int);
int pipewrite(struct pipe *, uint64, int);
void fileclose(struct file *);
struct file *filealloc();
int fileopen(char *, uint64);
uint64 inodewrite(struct file *, uint64, uint64);
uint64 inoderead(struct file *, uint64, uint64);
struct file *stdio_init(int);
int show_all_files();

#endif