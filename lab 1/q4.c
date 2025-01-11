#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv){
    char s[] = "Hello";
    int rank;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (s[rank] >= 97){
        s[rank] -= 32;
    }
    else{
        s[rank] += 32;
    }
    printf("%s for rank %d\n", s, rank);
    MPI_Finalize();
    return 0;
}