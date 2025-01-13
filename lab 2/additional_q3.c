#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != 2) {
        printf("This program requires exactly two processes.\n");
        MPI_Finalize();
        return 1;
    }

    if (rank == 0) {
        char message[20];
        // Process 0 sends a message and waits for a reply
        MPI_Send("Message from process 0", 21, MPI_CHAR, 1, 0, MPI_COMM_WORLD);
        printf("Process 0: Waiting for response from process 1...\n");
        MPI_Recv(message, 20, MPI_CHAR, 1, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Process 0 received: %s\n", message);
    } else if (rank == 1) {
        char message[20];
        // Process 1 sends a message and waits for a reply
        MPI_Send("Message from process 1", 21, MPI_CHAR, 0, 1, MPI_COMM_WORLD);
        printf("Process 1: Waiting for response from process 0...\n");
        MPI_Recv(message, 20, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Process 1 received: %s\n", message);
    }

    MPI_Finalize();
    return 0;
}
