#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

int main(int argc, char **argv){
    int rank, size, ans;
    int *arr = (int *)malloc(1000 * sizeof(int));
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    int bsize = 1000;
    int *buffer = (int *)malloc(bsize * sizeof(int));
    // note buffer size in bits is needed
    MPI_Buffer_attach(buffer, bsize * sizeof(int));
    if (rank == 0){
        printf("enter the numbers\n");
        for (int i = 0; i < size; ++i){
            scanf("%d", &arr[i]);
            MPI_Bsend(&arr[i], 1, MPI_INT, i, 1, MPI_COMM_WORLD);
        }
        ans = arr[0];
        printf("%d for rank 0\n", ans * ans);
    }
    else{
        MPI_Recv(&ans, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
        if (rank % 2 == 0){
            printf("%d for rank %d\n", ans * ans, rank);
        }
        else{
            printf("%d for rank %d\n", ans * ans * ans, rank);
        }
        
    }
    MPI_Buffer_detach(&buffer, &bsize);
    MPI_Finalize();
    return 0;
}