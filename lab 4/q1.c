#include <stdio.h>
#include <mpi.h>

void error_handle(int err_code, int rank)
{
    if (err_code != MPI_SUCCESS)
    {
        char err_string[1000];
        int length, err_class;
        MPI_Error_class(err_code, &err_class);
        MPI_Error_string(err_code, err_string, &length);
        if (rank > 0)
        {
            fprintf(stderr, "MPI Error for rank: %d\n", rank);
        }
        else{
            fprintf(stderr, "Init method failed\n");
        }
        fprintf(stderr, "MPI Error string: %s\n", err_string);
        fprintf(stderr, "MPI Error class: %d\n", err_class);
        fprintf(stderr, "MPI Error code: %d\n", err_code);
    }
    return;
}

int main(int argc, char **argv)
{
    int rank, size, fact = 1, ans;
    int err_code;
    err_code = MPI_Init(&argc, &argv);
    error_handle(err_code, -1);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    
    // Set error handler to return instead of abort

    MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);
    
    // For older versions of MPI (< 3.0)
    // MPI_Errhandler_set(MPI_COMM_WORLD, MPI_ERRORS_RETURN);

    for (int i = 2; i < rank + 2; ++i)
    {
        fact *= i;
    }

    MPI_Comm c = MPI_COMM_NULL;
    // Try to use MPI_Scan with deliberately incorrect parameters to trigger error
    // err_code = MPI_Scan(&fact, &ans, 1, MPI_DATATYPE_NULL, MPI_SUM, MPI_COMM_WORLD);
    err_code = MPI_Scan(&fact, &ans, 1, MPI_INT, MPI_SUM, c);
    // no need to specify root process in scan
    error_handle(err_code, rank);
    printf("%d from rank %d\n", ans, rank);
    MPI_Finalize();
    return 0;
}