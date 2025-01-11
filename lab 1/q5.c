#include <stdio.h>
#include <mpi.h>

int factorial(int x){
    int ans = 1;
    for (int i = 2; i < x; ++i){
        ans *= 2;
    }
    return ans;
}

int fibonacci(int x){
    if (x == 0){
        return 0;
    }
    if (x == 1){
        return 1;
    }
    return fibonacci(x - 1) + fibonacci(x - 2);
}

int main(int argc, char **argv){
    int rank;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank % 2 == 0){
        printf("factorial = %d for rank %d\n", factorial(rank), rank);
    }
    else{
        printf("fibonnaci number = %d for rank %d\n", fibonacci(rank), rank);
    }
    MPI_Finalize();
    return 0;
}