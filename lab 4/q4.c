#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

void err_handle(int err_code)
{
    if (err_code != MPI_SUCCESS)
    {
        char err_string[100];
        int length;
        MPI_Error_string(err_code, err_string, &length);
        fprintf(stderr, "MPI Error %s\n", err_string);
        MPI_Abort(MPI_COMM_WORLD, err_code);
    }
    return;
}

int main(int argc, char **argv)
{
    int rank, size, *revcount, *displace;
    char *input, *ans, *store, ele;
    int err_code = MPI_Init(&argc, &argv);
    err_handle(err_code);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    // note when using bcast the space should be allocated for all process if sending an array. Else error will come
    input = (char *)malloc((size + 1) * sizeof(char));
    revcount = (int *)malloc(size * sizeof(int));
    displace = (int *)malloc(size * sizeof(int));
    if (rank == 0)
    {
        printf("enter string\n");
        scanf("%s", input);
        int count = 0;
        for (int i = 0; i < size; ++i)
        {
            revcount[i] = i + 1;
            displace[i] = count;
            count += revcount[i];
        }
        ans = (char *)malloc((count + 1) * sizeof(char));
        ans[count] = '\0';
    }
    err_code = MPI_Bcast(input, size + 1, MPI_CHAR, 0, MPI_COMM_WORLD);
    err_handle(err_code);
    err_code = MPI_Bcast(revcount, size, MPI_INT, 0, MPI_COMM_WORLD);
    err_handle(err_code);
    err_code = MPI_Bcast(displace, size, MPI_INT, 0, MPI_COMM_WORLD);
    err_handle(err_code);
    store = (char *)malloc((rank + 1) * sizeof(char));
    ele = input[rank];
    for (int i = 0; i < rank + 1; ++i)
    {
        store[i] = ele;
    }
    err_code = MPI_Gatherv(store, rank + 1, MPI_CHAR, ans, revcount, displace, MPI_CHAR, 0, MPI_COMM_WORLD);
    err_handle(err_code);
    if (rank == 0)
    {
        printf("%s is the answer\n", ans);
    }
    MPI_Finalize();
    return 0;
}