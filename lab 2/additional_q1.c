#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

// no need to make the prime function efficient by using sieve method
int isprime(int x){
    if (x < 2){
        return 0;
    }
    if (x == 2){
        return 1;
    }
    for (int i = 2; i < x; ++i){
        if (x % i == 0){
            return 0;
        }
    }
    return 1;
}

int main(int argc, char **argv){
    int rank, size;
    int *arr;
    int x;
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    arr = (int *)malloc(size * sizeof(int));
    // using only two processes for this
    if (rank == 0){
        printf("enter %d elements\n", size);
        for (int i = 0; i < size; ++i){
            scanf("%d", &arr[i]);
        }
        for (int i = 1; i < size; ++i){
            MPI_Send(&arr[i], 1, MPI_INT, i, 1, MPI_COMM_WORLD);
        }
        if (isprime(arr[0])){
            printf("%d is prime\n", arr[0]);
        }
        else{
            printf("%d is not prime\n", arr[0]);
        }
    }
    else{
        MPI_Recv(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
        if (isprime(x)){
            printf("%d is prime\n", x);
        }
        else{
            printf("%d is not prime\n", x);
        }
    }
    MPI_Finalize();
    return 0;
}