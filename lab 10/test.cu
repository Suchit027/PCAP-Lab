#include <stdio.h>
#include <stdlib.h>
#include <device_launch_parameters.h>
#include <cuda_runtime.h>

__global__ void evenphase(int *a, int input_l)
{
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i % 2 != 0)
    {
        i += 1;
    }
    if (i < input_l - 1 && a[i] > a[i + 1])
    {
        int temp = a[i];
        a[i] = a[i + 1];
        a[i + 1] = temp;
    }
    return;
}
__global__ void oddphase(int *a, int input_l)
{
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i % 2 == 0)
    {
        i += 1;
    }
    if (i < input_l - 1 && a[i] > a[i + 1])
    {
        int temp = a[i];
        a[i] = a[i + 1];
        a[i + 1] = temp;
    }
    return;
}
int main()
{
    int *a, n, *da;
    printf("enter size of array\n");
    scanf("%d", &n);
    a = (int *)malloc(sizeof(int) * n);
    printf("enter array\n");
    for (int i = 0; i < n; ++i)
    {
        scanf("%d", &a[i]);
    }
    cudaMalloc((void **)&da, sizeof(int) * n);
    cudaMemcpy(da, a, sizeof(int) * n, cudaMemcpyHostToDevice);
    for (int i = 0; i < n; ++i)
    {
        evenphase<<<1, n>>>(da, n);
        cudaDeviceSynchronize();
        oddphase<<<1, n>>>(da, n);
        cudaDeviceSynchronize();
    }
    cudaMemcpy(a, da, sizeof(int) * n, cudaMemcpyDeviceToHost);
    printf("answer\n");
    for (int i = 0; i < n; ++i)
    {
        printf("%d ", a[i]);
    }
    cudaFree(da);
    return 0;
}