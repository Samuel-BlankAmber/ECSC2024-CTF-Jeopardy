#define _GNU_SOURCE

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <sys/uio.h>
#include <unistd.h>
// Custom includes
#include <util.h>
#include <seccomp.h>

// Global variables
char *secret_mapping = NULL;
pid_t child_pid = 0;
char iov_buf[IOV_BUF_LEN];

void game(void)
{
    struct {
        struct sigaction sa;
        unsigned char idx;
        char guesses[GUESSES][GUESS_BUF];
    } svars;

    load_seccomp_filter();

    memset(&svars, 0, sizeof(svars));
    svars.sa.sa_handler = alrm_handler;
    sigaction(SIGALRM, &svars.sa, NULL);
    alarm(FRST_ALRM);

    print_description();

    for (svars.idx = 0; svars.idx != GUESSES; svars.idx++) {
        puts("Enter your guess: ");
        printf("> ");
        read_until_newline(STDIN_FILENO, svars.guesses[svars.idx], GUESS_BUF);
        if (strncmp(svars.guesses[svars.idx], "END", 3) == 0) {
            break;
        }
        void *search_addr = (void *)strtoull(svars.guesses[svars.idx], NULL, 0);
        if (search_addr != (void *)0) {
            memset(iov_buf, 0, IOV_BUF_LEN);
            struct iovec local_iov = { .iov_base = iov_buf, .iov_len = IOV_BUF_LEN };
            struct iovec remote_iov = { .iov_base = search_addr, .iov_len = IOV_BUF_LEN };
            process_vm_readv(child_pid, &local_iov, 1, &remote_iov, 1, 0);
            puts("Unlucky, you didn't find the flag!");
        }
    }
    puts("Game over!");
}

int main(void)
{
    init();

    switch (child_pid = fork()) {
    case -1:
        die("fork");
        break;
    case 0:
        // Delete pointer to secret mapping
        secret_mapping = NULL;
        // Idle child process
        alarm(CHLD_ALRM);
        while (1) {
            sleep(1);
        }
        break;
    default:
        // unmap secret mapping
        if (munmap(secret_mapping, SECRET_SIZE) == -1) {
            die("munmap");
        }
        secret_mapping = NULL;
        game();
        goto parent_out;
    }

parent_out:
    kill(child_pid, SIGKILL);
    wait(NULL);
    exit(EXIT_SUCCESS);
}
