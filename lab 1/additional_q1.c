#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv){
    int rank;
    int arr[] = {18, 22, 14, 55};
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank < 2){
        int temp = arr[rank];
        arr[rank] = arr[3 - rank];
        arr[3 - rank] = temp;
    }
    for (int i = 0; i < 4; ++i){
        printf("%d ", arr[i]);
    }
    printf("\n");
    MPI_Finalize();
    return 0;
}