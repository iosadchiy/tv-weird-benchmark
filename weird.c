#define _GNU_SOURCE
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

const int NLOCKS = 100000000;
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

    for (int i = 0; i < NLOCKS; i++) {
        pthread_mutex_lock(&lock);
        global_var += global_var * 2;
        pthread_mutex_unlock(&lock);
    }
    return NULL;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: ./weird 1 OR ./weird 2\n");
        return 1;
    }
    const int MODE = atoi(argv[1]); // 1-single cpu, 2-smp

    if (pthread_mutex_init(&lock, NULL) != 0) {
        printf("\n mutex init failed\n");
        return 1;
    }

    int x = 0;
    if (0 != pthread_create(&(tid[0]), NULL, &doSmt, &x))
        printf("\ncan't create thread");

    int y = MODE == 1 ? 0 : 1;
    if (0 != pthread_create(&(tid[1]), NULL, &doSmt, &y))
        printf("\ncan't create thread");

    pthread_join(tid[0], NULL);
    pthread_join(tid[1], NULL);
    pthread_mutex_destroy(&lock);
}
