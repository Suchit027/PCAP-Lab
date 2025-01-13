#include <stdio.h>
#include <mpi.h>

int factorial(int x){
    int ans = 1;
    for (int i = 2; i < x + 1; ++i){
        ans *= i;
    }
    return ans;
}

int summ(int x){
    int ans = 0;
    for (int i = 0; i < x + 1; ++i){
        ans += i;
    }
    return ans;
}

int main(int argc, char **argv){
    int rank, size, ans, x;
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank == 0){
        ans += factorial(1);
        for (int i = 1; i < size; ++i){
            MPI_Recv(&x, 1, MPI_INT, i, 1, MPI_COMM_WORLD, &status);
            ans += x;
        }
        printf("ans = %d\n", ans);
    }
    else if (rank % 2 == 0){
        x = factorial(rank + 1);
        MPI_Send(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
    }
    else{
        x = summ(rank + 1);
        MPI_Send(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
    }
    MPI_Finalize();
    return 0;
}