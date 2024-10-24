#include <asm/unistd_64.h>
#include <linux/audit.h>
#include <linux/bpf_common.h>
#include <linux/filter.h>
#include <linux/prctl.h>
#include <linux/seccomp.h>
#include <stddef.h>
#include <sys/syscall.h>
#include <sys/prctl.h>

#include <seccomp.h>
#include <util.h>

void load_seccomp_filter(void)
{
    struct sock_filter filter[] = {
		BPF_STMT(BPF_LD | BPF_W | BPF_ABS,  offsetof(struct seccomp_data, arch)),
		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AUDIT_ARCH_X86_64,      0, 12),
		BPF_STMT(BPF_LD | BPF_W | BPF_ABS,  offsetof(struct seccomp_data, nr)),
		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_read,              11, 0),
		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_write,             10, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_mmap,              9, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_rt_sigaction,      8, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_rt_sigreturn,      7, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_alarm,             6, 0),
		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_exit,              5, 0),
		BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_wait4,             4, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_kill,              3, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_exit_group,        2, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_process_vm_readv,  1, 0),
		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_KILL_PROCESS),
		BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
	};

    struct sock_fprog prog = {
        .len = (unsigned short)(sizeof(filter) / sizeof(filter[0])),
        .filter = filter,
    };

    if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) == -1) {
        die("prctl NO_NEW_PRIVS");
    }

    if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) == -1) {
        die("prctl SECCOMP");
    }
}
