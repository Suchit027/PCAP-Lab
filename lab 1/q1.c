#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv){
    int rank;
    int x = 3;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    int pow = 1;
    for (int i = 0; i < rank; ++i){
        pow *= x;
    }
    printf("answer = %d for rank %d\n", pow, rank);
    MPI_Finalize();
    return 0;
}