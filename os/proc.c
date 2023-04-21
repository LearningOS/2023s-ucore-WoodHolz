#include "proc.h"
#include "defs.h"
#include "loader.h"
#include "trap.h"
#include "timer.h"

struct proc pool[NPROC];
char kstack[NPROC][PAGE_SIZE];
__attribute__((aligned(4096))) char ustack[NPROC][PAGE_SIZE];
__attribute__((aligned(4096))) char trapframe[NPROC][PAGE_SIZE];

extern char boot_stack_top[];
struct proc *current_proc;
struct proc idle;

int threadid()
{
	return curr_proc()->pid;
}

struct proc *curr_proc()
{
	return current_proc;
}

// initialize the proc table at boot time.
void proc_init(void)
{
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
		p->state = UNUSED;
		p->kstack = (uint64)kstack[p - pool];
		p->ustack = (uint64)ustack[p - pool];
		p->trapframe = (struct trapframe *)trapframe[p - pool];
		/*
		* LAB1: you may need to initialize your new fields of proc here
		*/
		p->str_time = 0;
		/* 只能清空数组的最后一个元素，并不能清空整个数组。
		memset(p->syscall_times, 0, \
			sizeof(p->syscall_times[MAX_SYSCALL_NUM]));
		*/

		/**
		 * 	在下面这个表达式中，sizeof 操作符计算的是 unsigned int（uint32） 类型的大小，
		 * 	然后再乘以 MAX_SYSCALL_NUM 得到要清空的字节数。
		 * 	这样就可以正确地清空整个数组。
		*/
		memset(p->syscall_times, 0, MAX_SYSCALL_NUM * sizeof(uint32));
	}
	idle.kstack = (uint64)boot_stack_top;
	idle.pid = 0;
	current_proc = &idle;
}

int allocpid()
{
	static int PID = 1;
	return PID++;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *allocproc(void)
{
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
		if (p->state == UNUSED) {
			goto found;
		}
	}
	return 0;

found:
	p->pid = allocpid();
	p->state = USED;
	memset(&p->context, 0, sizeof(p->context));
	memset(p->trapframe, 0, PAGE_SIZE);
	memset((void *)p->kstack, 0, PAGE_SIZE);
	p->context.ra = (uint64)usertrapret;
	p->context.sp = p->kstack + PAGE_SIZE;
	return p;
}

// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void scheduler(void)
{
	struct proc *p;
	for (;;) {
		for (p = pool; p < &pool[NPROC]; p++) {
			if (p->state == RUNNABLE) {
				/*
				* LAB1: you may need to init proc start time here
				*/
				/*
				if (p->str_time != 0) printf(\
					"\nError! This time str_time should be 0\n"); 
				else p->str_time = get_cycle();
				*/
				if (!p->str_time) p->str_time = get_cycle();
				p->state = RUNNING;
				current_proc = p;
				swtch(&idle.context, &p->context);
			}
		}
	}
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
	struct proc *p = curr_proc();
	if (p->state == RUNNING)
		panic("sched running");
	swtch(&p->context, &idle.context);
}

// Give up the CPU for one scheduling round.
void yield(void)
{
	current_proc->state = RUNNABLE;
	sched();
}

// Exit the current process.
void exit(int code)
{
	struct proc *p = curr_proc();
	infof("proc %d exit with %d", p->pid, code);
	p->state = UNUSED;
	finished();
	sched();
}
