#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

void err_handle(int err_code)
{
    if (err_code != MPI_SUCCESS)
    {
        char err_string[1000];
        int length;
        MPI_Error_string(err_code, err_string, &length);
        fprintf(stderr, "MPI Error %s\n", err_string);
        MPI_Abort(MPI_COMM_WORLD, err_code);
    }
    return;
}

int main(int argc, char **argv)
{
    int rank, size, *arr, num, occ = 0, ans, *store;
    int err_code = MPI_Init(&argc, &argv);
    err_handle(err_code);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0)
    {
        arr = (int *)malloc(9 * sizeof(int));
        printf("enter the matrix\n");
        for (int i = 0; i < 3; ++i)
        {
            for (int j = 0; j < 3; ++j)
            {
                scanf("%d", &arr[(3 * i) + j]);
            }
        }
        printf("enter number to be searched\n");
        scanf("%d", &num);
    }

    store = (int *)malloc(3 * sizeof(int));
    err_code = MPI_Bcast(&num, 1, MPI_INT, 0, MPI_COMM_WORLD);
    err_handle(err_code);
    err_code = MPI_Scatter(arr, 3, MPI_INT, store, 3, MPI_INT, 0, MPI_COMM_WORLD);
    err_handle(err_code);

    for (int i = 0; i < 3; ++i)
    {
        if (store[i] == num)
        {
            occ += 1;
        }
    }
    err_code = MPI_Scan(&occ, &ans, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    err_handle(err_code);

    printf("%d from rank %d\n", ans, rank);

    MPI_Finalize();
    return 0;
}