#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

int main(int argc, char **argv){
    int rank, size, *arr, val;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0){
        arr = (int *)malloc(size * sizeof(int));
        printf("enter the elements\n");
        for(int i = 0; i < size; ++i){
            scanf("%d", &arr[i]);
        }
    }
    MPI_Scatter(arr, 1, MPI_INT, &val, 1, MPI_INT, 0, MPI_COMM_WORLD);
    if(val % 2 == 0){
        val = 1;
    }
    else{
        val = 0;
    }
    // note gather
    MPI_Gather(&val, 1, MPI_INT, arr, 1, MPI_INT, 0, MPI_COMM_WORLD);
    if(rank == 0){
        int one = 0, zero = 0;
        printf("new array - ");
        for(int i = 0; i < size; ++i){
            printf("%d ", arr[i]);
            if(arr[i] == 0){
                zero += 1;
            }
            else{
                one += 1;
            }
        }
        printf("\n");
        printf("ones = %d zeros %d", one, zero);
    }
    MPI_Finalize();
}