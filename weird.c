#define _GNU_SOURCE
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

uint n_cycles = 10000000;
uint mode = 0;

static unsigned int global_var = 0;
pthread_mutex_t lock;
pthread_t tid[2];

void* doSmt(void *arg) {
    int cpu = *(int*)arg;

    cpu_set_t cpuset;
    pthread_t thread;
    thread = pthread_self();
    CPU_ZERO(&cpuset);
    CPU_SET(cpu, &cpuset);
    pthread_setaffinity_np(thread, sizeof(cpu_set_t), &cpuset);

    for (int i = 0; i < n_cycles; i++) {
        pthread_mutex_lock(&lock);
        global_var++;
        pthread_mutex_unlock(&lock);
    }
    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Usage: ./weird <n_cycles> <up|smp>\n");
        return 1;
    }
    n_cycles = atoi(argv[1]);
    mode = strcmp(argv[2], "up") == 0 ? 1 : 2;

    if (pthread_mutex_init(&lock, NULL) != 0) {
        printf("\n mutex init failed\n");
        return 1;
    }

    int x = 0;
    if (0 != pthread_create(&(tid[0]), NULL, &doSmt, &x))
        printf("\ncan't create thread");

    int y = mode == 1 ? 0 : 1;
    if (0 != pthread_create(&(tid[1]), NULL, &doSmt, &y))
        printf("\ncan't create thread");

    pthread_join(tid[0], NULL);
    pthread_join(tid[1], NULL);
    pthread_mutex_destroy(&lock);
}
