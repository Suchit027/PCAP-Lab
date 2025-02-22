#include <stdio.h>
#include <stdlib.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void evenPhase(int *arr, int n)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    int i;
    if (tid % 2 == 0){
        i = tid;
    }
    else{
        i = tid + 1;
    }

    if (i < n - 1)
    {
        if (arr[i] > arr[i + 1])
        {
            int temp = arr[i];
            arr[i] = arr[i + 1];
            arr[i + 1] = temp;
        }
    }
}

__global__ void oddPhase(int *arr, int n)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    int i;
    if (tid % 2 != 0){
        i = tid;
    }
    else{
        i = tid + 1;
    }
    if (i < n - 1)
    {
        if (arr[i] > arr[i + 1])
        {
            int temp = arr[i];
            arr[i] = arr[i + 1];
            arr[i + 1] = temp;
        }
    }
}

void oddEvenSort(int *arr, int n)
{
    int *d_arr;
    cudaMalloc(&d_arr, n * sizeof(int));
    cudaMemcpy(d_arr, arr, n * sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int gridSize = (n + blockSize - 1) / blockSize;

    for (int i = 0; i < n; i++)
    {
        evenPhase<<<gridSize, blockSize>>>(d_arr, n);
        cudaDeviceSynchronize();
        oddPhase<<<gridSize, blockSize>>>(d_arr, n);
        cudaDeviceSynchronize();
    }

    cudaMemcpy(arr, d_arr, n * sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(d_arr);
}

int main(int argc, char **argv)
{
    int n = 5;
    int arr[] = {5, 3, 1, 2, 4};

    printf("Initial array: ");
    for (int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }

    oddEvenSort(arr, n);
    printf("\n");

    for (int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }

    return 0;
}
