#pragma once
#include <sys/types.h>

// Challenge defines
#define PAGE_BITS   12
#define SECRET_SIZE 0x100000
#define FRST_ALRM   30
#define SCND_ALRM   60
#define CHLD_ALRM   FRST_ALRM + SCND_ALRM - 1
#define GUESSES 3
#define GUESS_BUF   0x10
#define IOV_BUF_LEN 0x100

// Global variables
extern char *secret_mapping;
extern pid_t child_pid;
extern char iov_buf[IOV_BUF_LEN];

// Function prototypes
void die(char *msg);
void init(void);
void print_description(void);
void game(void);
void alrm_handler(int signum);
ssize_t read_until_newline(int fd, char *buf, ssize_t count);
