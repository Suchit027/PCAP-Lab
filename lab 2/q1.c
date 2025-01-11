#include <stdio.h>
#include <mpi.h>
#include <string.h>

int main(int argc, char **argv){
    int rank, n;
    char s[100];
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank == 0){
        printf("enter word for master process\n");
        scanf("%s", s);
        // +1 for including the null character
        int n = strlen(s) + 1;
        MPI_Ssend(&n, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
        MPI_Ssend(&s, n, MPI_CHAR, 1, 1, MPI_COMM_WORLD);
        MPI_Recv(&s, n, MPI_CHAR, 1, 1, MPI_COMM_WORLD, &status);
        printf("new word = %s", s);
    }
    else{
        MPI_Recv(&n, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &status);
        MPI_Recv(&s, n, MPI_CHAR, 0, 1, MPI_COMM_WORLD, &status);
        for (int i = 0; i < n; ++i){
            if (s[i] >= 97){
                s[i] -= 32;
            }
            else{
                s[i] += 32;
            }
        }
        MPI_Ssend(&s, n, MPI_CHAR, 0, 1, MPI_COMM_WORLD);
    }
    MPI_Finalize();
    return 0;
}