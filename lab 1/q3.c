#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv){
    int rank;
    int x = 3, y = 4;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank == 0){
        printf("x + y = %d\n", x + y);
    }
    else if(rank == 1){
        printf("x - y = %d\n", x - y);
    }
    else if(rank == 2){
        printf("x * y = %d\n", x * y);
    }
    else{
        printf("x / y = %f\n", (float)x / y);
    }
    MPI_Finalize();
    return 0;
}