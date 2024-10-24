#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

#define DEBUG 0

#define GRID_SIZE 512
#define NUM_BOATS 150

#define MAX_MISS 26
int available_misses = MAX_MISS;

#define RAND_STATE_SIZE 50
#define M GRID_SIZE
int C1 = 361;
int C2 = 293;

enum e_player
{
    COMPUTER = 0,
    PLAYER = 1
};

enum e_boat
{
    EMPTY = 0b0000,
    BOAT = 0b1001,
    HIT = 0b1111
};

typedef struct
{
    unsigned x;
    unsigned y;
} point_t;

typedef struct
{
    enum e_boat user_boat : 4;
    enum e_boat computer_boat : 4;
} grid_point_t;

typedef struct
{
    unsigned hits;
    unsigned misses;
    unsigned boats;
} player_stats_t;

grid_point_t grid[GRID_SIZE][GRID_SIZE] = {EMPTY};
player_stats_t player_stats = {0};
player_stats_t computer_stats = {0};

pthread_t game_thread;
pthread_t computer_thread;
pthread_t player_thread;

sem_t computer_ready;
sem_t player_ready;
sem_t computer_turn;
sem_t player_turn;
sem_t game_round;

void *game_task(void *);
void *computer_task(void *);
void *player_task(void *);

void win()
{
    puts("You win!");
    char *flag = getenv("FLAG");
    if (flag)
        puts(flag);
    else
        puts("ECSC{FLAG}");
    pthread_exit(NULL);
}

unsigned rand_state[RAND_STATE_SIZE] = {0};

void _initrand()
{
    int fd = open("/dev/urandom", O_RDONLY);
    if (fd == -1)
    {
        perror("init failed");
        exit(EXIT_FAILURE);
    }

    if (read(fd, rand_state, sizeof(rand_state)) != sizeof(rand_state))
    {
        perror("init failed");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < RAND_STATE_SIZE; i++)
    {
        rand_state[i] %= M;
    }

#if DEBUG
    fprintf(stderr, "urandom state: ");
    for (int i = 0; i < RAND_STATE_SIZE; i++)
    {
        fprintf(stderr, "%d ", rand_state[i]);
    }
    fprintf(stderr, "\n");
#endif

    close(fd);
}

unsigned _randM()
{
    // x_n  = ((x_{n-50} + x_{n-27})*C1 + 131)*C2 mod M
    // inv : x_{n-50} = (x_n * invC2 - 131) * invC1 - x_{n-27} mod M
    unsigned n = rand_state[RAND_STATE_SIZE - 50] + rand_state[RAND_STATE_SIZE - 27];
    n = (n * C1 + 131) * C2 % M;
    for (int i = 0; i < RAND_STATE_SIZE - 1; i++)
    {
        rand_state[i] = rand_state[i + 1];
    }
    rand_state[RAND_STATE_SIZE - 1] = n;

#if DEBUG
    fprintf(stderr, "rand: %d\n", n);
#endif

    return n;
}

void try_hit(point_t *target, enum e_player player)
{
    switch (player)
    {
    case PLAYER:
        if (grid[target->x][target->y].computer_boat == HIT)
        {
            puts("You already hit this boat!");
        }
        else if (grid[target->x][target->y].computer_boat == BOAT)
        {
            grid[target->x][target->y].computer_boat = HIT;
            puts("You hit a boat!");
            player_stats.hits++;
            computer_stats.boats--;
        }
        else
        {
            puts("You missed!");
            player_stats.misses++;
        }
        break;
    case COMPUTER:
        printf("Computer tries to hit (%d %d)...\n", target->x, target->y);
        if (grid[target->x][target->y].user_boat == HIT)
        {
            puts("Computer already hit this boat!");
        }
        else if (grid[target->x][target->y].user_boat == BOAT)
        {
            grid[target->x][target->y].user_boat = HIT;
            puts("Computer hit a boat!");
            computer_stats.hits++;
            player_stats.boats--;
        }
        else
        {
            puts("Computer missed!");
            computer_stats.misses++;
        }
        break;
    }
}

int main(int argc, char *argv[], char *envp[])
{
    setvbuf(stdin, NULL, _IONBF, 0);
    setvbuf(stdout, NULL, _IONBF, 0);

    // init prng state
    _initrand();

    // initialize the semaphores
    sem_init(&computer_ready, 0, 0);
    sem_init(&player_ready, 0, 0);
    sem_init(&computer_turn, 0, 0);
    sem_init(&player_turn, 0, 0);
    sem_init(&game_round, 0, 1);

    // create the threads
    pthread_create(&game_thread, NULL, game_task, NULL);
    pthread_create(&computer_thread, NULL, computer_task, NULL);
    pthread_create(&player_thread, NULL, player_task, NULL);

    // wait for the game to end
    pthread_join(game_thread, NULL);

    // cleanup
    pthread_cancel(computer_thread);
    pthread_cancel(player_thread);
    sem_destroy(&computer_ready);
    sem_destroy(&player_ready);
    sem_destroy(&computer_turn);
    sem_destroy(&player_turn);
    sem_destroy(&game_round);

    return EXIT_SUCCESS;
}

void *game_task(void *arg)
{
    enum e_player current_player = COMPUTER;

    sem_wait(&computer_ready);
    sem_wait(&player_ready);
    printf("You have %d tries\n", available_misses);
    while (1)
    {
        sem_wait(&game_round);
        // check if the game is over
        // if so, call win() and exit
        if (player_stats.misses >= available_misses || player_stats.boats == 0)
        {
#if DEBUG
            printf("Player stats: %d %d %d\n", player_stats.hits, player_stats.misses, player_stats.boats);
            printf("Computer stats: %d %d %d\n", computer_stats.hits, computer_stats.misses, computer_stats.boats);
#endif
            puts("You lose!");
            pthread_exit(NULL);
        }

        if (computer_stats.boats == 0)
        {
            win();
        }

        // allow player to play and change next player
        if (current_player == COMPUTER)
        {
            sem_post(&computer_turn);
            current_player = PLAYER;
        }
        else
        {
            sem_post(&player_turn);
            current_player = COMPUTER;
        }
    }
    return NULL;
}

void *computer_task(void *arg)
{
    // place boats
    point_t target;
    while (computer_stats.boats < NUM_BOATS)
    {
        target.x = _randM();
        target.y = _randM();
        if (grid[target.x][target.y].computer_boat == BOAT)
        {
            // collision in boat position, refetch rand but increase the number of misses available (leak number of collisions)
            available_misses++;
            continue;
        }
        grid[target.x][target.y].computer_boat = BOAT;
        computer_stats.boats++;
    }

    sem_post(&computer_ready);
    while (1)
    {
        sem_wait(&computer_turn);

        // choose a random point to hit
        target.x = _randM();
        target.y = _randM();
        try_hit(&target, COMPUTER);
        sem_post(&game_round);
    }
    return NULL;
}

void *player_task(void *arg)
{
    // place boats, ask the user for the coordinates
    point_t target;
    while (player_stats.boats < NUM_BOATS)
    {
        printf("Enter the coordinates of the boat %d (x y): ", player_stats.boats + 1);
        scanf("%u %u", &target.x, &target.y);
        if (target.x >= GRID_SIZE || target.y >= GRID_SIZE)
        {
            puts("Invalid coordinates!");
            continue;
        }
        if (grid[target.x][target.y].user_boat == BOAT)
        {
            puts("You already placed a boat here!");
            continue;
        }
        grid[target.x][target.y].user_boat = BOAT;
        player_stats.boats++;
    }

    sem_post(&player_ready);
    while (1)
    {
        sem_wait(&player_turn);

        // ask the user for the coordinates of the hit
        printf("Enter the coordinates to hit (x y): ");
        scanf("%u %u", &target.x, &target.y);
        if (target.x >= GRID_SIZE || target.y >= GRID_SIZE)
        {
            puts("Invalid coordinates!");
            continue;
        }
        try_hit(&target, PLAYER);
        sem_post(&game_round);
    }
    return NULL;
}
