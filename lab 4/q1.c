#include <stdio.h>
#include <mpi.h>

void error_handle(int err_code){
    if(err_code != MPI_SUCCESS){
        char err_string[1000];
        int length;
        MPI_Error_string(err_code, err_string, &length);
        fprintf(stderr, "MPI Error: %s\n", err_string);
        MPI_Abort(MPI_COMM_WORLD, err_code);
    }
    return;
}

int main(int argc, char **argv){
    int rank, size, fact = 1, ans;
    int err_code = MPI_Init(&argc, &argv);
    error_handle(err_code);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    for(int i = 2; i < rank + 2; ++i){
        fact *= i;
    }
    err_code = MPI_Scan(&fact, &ans, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    error_handle(err_code);
    printf("%d from rank %d\n", ans, rank);
    MPI_Finalize();
    return 0;
}