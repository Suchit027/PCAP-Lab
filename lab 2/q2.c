#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv){
    int rank, x, size;
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0){
        printf("enter the number\n");
        scanf("%d", &x);
        // note how for loop is utilized
        for (int i = 1; i < size; ++i){
            MPI_Send(&x, 1, MPI_INT, i, 1, MPI_COMM_WORLD);
        }
    }
    else{
        MPI_Recv(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
        printf("%d recieved by rank %d\n", x, rank);
    }
    MPI_Finalize();
    return 0;
}