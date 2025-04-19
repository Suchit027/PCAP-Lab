#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__constant__ int mask[5];

__global__ void conv1d(int *a, int *ans, int mask_l, int input_l)
{
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    int start = i - (mask_l / 2);
    ans[i] = 0;
    for (int j = 0; j < mask_l; ++j)
    {
        if (start + j >= 0 && start + j < input_l)
        {
            ans[i] += a[start + j] * mask[j];
        }
    }
    return;
}
int main()
{
    int *a, *ans, *da, *dans, *m, mask_l, input_l;
    printf("enter input size\n");
    scanf("%d", &input_l);
    a = (int *)malloc(sizeof(int) * input_l);
    ans = (int *)malloc(sizeof(int) * input_l);
    printf("enter a\n");
    for (int i = 0; i < input_l; ++i)
    {
        scanf("%d", &a[i]);
    }
    printf("enter mask size\n");
    scanf("%d", &mask_l);
    m = (int *)malloc(sizeof(int) * mask_l);
    printf("enter mask\n");
    for (int i = 0; i < mask_l; ++i)
    {
        scanf("%d", &m[i]);
    }
    cudaMalloc((void **)&da, sizeof(int) * input_l);
    cudaMalloc((void **)&dans, sizeof(int) * input_l);
    cudaMemcpyToSymbol(mask, m, sizeof(int) * mask_l);
    cudaMemcpy(da, a, sizeof(int) * input_l, cudaMemcpyHostToDevice);
    conv1d<<<1, input_l>>>(da, dans, mask_l, input_l);
    cudaMemcpy(ans, dans, sizeof(int) * input_l, cudaMemcpyDeviceToHost);
    printf("answer\n");
    for (int i = 0; i < input_l; ++i)
    {
        printf("%d ", ans[i]);
    }
    cudaFree(da);
    cudaFree(dans);
    return 0;
}