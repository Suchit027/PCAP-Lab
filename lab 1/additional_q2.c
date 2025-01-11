#include <stdio.h>
#include <mpi.h>

int isprime(int x)
{
    if (x < 2)
    {
        return 0;
    }
    if (x == 2)
    {
        return 1;
    }
    for (int i = 2; i < x; ++i)
    {
        if (x % i == 0)
        {
            return 0;
        }
    }
    return 1;
}

int main(int argc, char **argv)
{
    int rank;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if (rank == 0)
    {
        for (int i = 0; i < 50; ++i)
        {
            if (isprime(i))
            {
                printf("%d ", i);
            }
        }
    }
    else
    {
        for (int i = 50; i < 100; ++i)
        {
            if (isprime(i))
            {
                printf("%d ", i);
            }
        }
    }
    MPI_Finalize();
    return 0;
}