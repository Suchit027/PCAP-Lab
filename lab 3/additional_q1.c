#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

int main(int argc, char **argv){
    int rank, size, m, *arr, *store, *ans;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0){
        printf("enter the value of m\n");
        scanf("%d", &m);
        arr = (int *)malloc((size * m) * sizeof(int));
        printf("enter the values\n");
        for(int i = 0; i < m * size; ++i){
            scanf("%d", &arr[i]);
        }
        ans = (int *)malloc((size * m) * sizeof(int));
    }
    MPI_Bcast(&m, 1, MPI_INT, 0, MPI_COMM_WORLD);
    store = (int *)malloc(m * sizeof(int));
    MPI_Scatter(arr, m, MPI_INT, store, m, MPI_INT, 0, MPI_COMM_WORLD);
    if (rank % 2 == 0){
        for(int i = 0; i < m; ++i){
            store[i] *= store[i];
        }
    }
    else{
        for(int i = 0; i < m; ++i){
            store[i] *= store[i] * store[i];
        }
    }
    MPI_Gather(store, m, MPI_INT, ans, m, MPI_INT, 0, MPI_COMM_WORLD);
    if (rank == 0){
        printf("the new array - ");
        for(int i = 0; i < size * m; ++i){
            printf("%d ", ans[i]);
        }
    }
    MPI_Finalize();
}