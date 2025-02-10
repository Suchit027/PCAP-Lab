#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>

void standard(int argc, char **argv)
{
    int rank, size;
    MPI_Status status;
    int x;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0)
    {
        printf("enter the integer\n");
        scanf("%d", &x);
        // this if condiiton is important if number of processes issued is small
        if (rank + 1 < size)
        {
            MPI_Send(&x, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
        }
        MPI_Recv(&x, 1, MPI_INT, size - 1, 1, MPI_COMM_WORLD, &status);
        printf("%d from rank %d\n", x, size - 1);
    }
    else if (rank == size - 1)
    {
        MPI_Recv(&x, 1, MPI_INT, rank - 1, 1, MPI_COMM_WORLD, &status);
        printf("%d from rank %d\n", x, rank - 1);
        x += 1;
        MPI_Send(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
    }
    else
    {
        MPI_Recv(&x, 1, MPI_INT, rank - 1, 1, MPI_COMM_WORLD, &status);
        printf("%d from rank %d\n", x, rank - 1);
        x += 1;
        MPI_Send(&x, 1, MPI_INT, rank + 1, 1, MPI_COMM_WORLD);
    }
    MPI_Finalize();
    return;
}
void sync_standard(int argc, char **argv){
    int rank, size;
    MPI_Status status;
    int x;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if (rank == 0){
        printf("enter the nubmer\n");
        scanf("%d", &x);
        if (rank + 1 < size){
            MPI_Ssend(&x, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
            MPI_Recv(&x, 1, MPI_INT, size - 1, 1, MPI_COMM_WORLD, &status);
            printf("%d from rank %d and end at 0\n", x, size - 1);
        }
    }
    else if (rank == size - 1){
        MPI_Recv(&x, 1, MPI_INT, rank - 1, 1, MPI_COMM_WORLD, &status);
        printf("%d from rank %d\n", x, rank - 1);
        x += 1;
        MPI_Ssend(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
    }
    else {
        MPI_Recv(&x, 1, MPI_INT, rank - 1, 1, MPI_COMM_WORLD, &status);
        printf("%d from rank %d\n", x, rank - 1);
        x += 1;
        MPI_Ssend(&x, 1, MPI_INT, rank + 1, 1, MPI_COMM_WORLD);
    }
    MPI_Finalize();
    return;
}
void b_send(int argc, char **argv){
    int rank, size, bsize = 1000;
    MPI_Status status;
    int x;
    int *buffer = (int *)malloc(bsize * sizeof(int));
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Buffer_attach(buffer, bsize * sizeof(int));
    if (rank == 0){
        printf("enter the number\n");
        scanf("%d", &x);
        if (rank + 1 < size){
            MPI_Bsend(&x, 1, MPI_INT, 1, 1, MPI_COMM_WORLD);
            MPI_Recv(&x, 1, MPI_INT, size - 1, 1, MPI_COMM_WORLD, &status);
            printf("%d from rank %d and end at 0\n", x, size - 1);
        }
    }
    else if (rank == size - 1){
        MPI_Recv(&x, 1, MPI_INT, rank - 1, 1, MPI_COMM_WORLD, &status);
        printf("%d from rank %d\n", x, rank - 1);
        x += 1;
        MPI_Bsend(&x, 1, MPI_INT, 0, 1, MPI_COMM_WORLD);
    }
    else{
        MPI_Recv(&x, 1, MPI_INT, rank - 1, 1, MPI_COMM_WORLD, &status);
        printf("%d from rank %d\n", x, rank - 1);
        x += 1;
        MPI_Bsend(&x, 1, MPI_INT, rank + 1, 1, MPI_COMM_WORLD);
    }
    MPI_Buffer_detach(&buffer, &bsize);
    MPI_Finalize();
    return;
}
int main(int argc, char **argv)
{
    // standard(argc, argv);
    // sync_standard(argc, argv);
    b_send(argc, argv);
    return 0;
}