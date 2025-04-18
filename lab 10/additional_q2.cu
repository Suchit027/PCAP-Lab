#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define MASK_RADIUS 2
#define TILE_SIZE 8

__constant__ int mask[10];

__global__ void conv1d(int *a, int input_l, int *ans)
{
    __shared__ int m[TILE_SIZE + (2 * MASK_RADIUS) + 1];
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i < input_l)
    {
        m[MASK_RADIUS + i] = a[i];
        if (threadIdx.x < MASK_RADIUS)
        {
            if (i - MASK_RADIUS >= 0)
            {
                m[i] = a[i - MASK_RADIUS];
            }

            else
            {
                m[i] = 0;
            }
        }
        if (threadIdx.x + MASK_RADIUS >= blockDim.x)
        {
            if (i + (2 * MASK_RADIUS) < input_l)
            {
                m[i + (2 * MASK_RADIUS)] = a[i + MASK_RADIUS];
            }

            else
            {
                m[i + (2 * MASK_RADIUS)] = 0;
            }
        }
        __syncthreads();
        for (int j = -MASK_RADIUS; j < MASK_RADIUS + 1; ++j)
        {
            ans[i] += m[i + MASK_RADIUS + j] * mask[MASK_RADIUS + j];
        }
    }
    return;
}

int main()
{
    int *a, *m, *ans, *da, *dans, input_l;
    printf("enter input length\n");
    scanf("%d", &input_l);
    a = (int *)malloc(sizeof(int) * input_l);
    ans = (int *)malloc(sizeof(int) * input_l);
    printf("enter a\n");
    for (int i = 0; i < input_l; ++i)
    {
        scanf("%d", &a[i]);
    }
    printf("enter mask\n");
    m = (int *)malloc(sizeof(int) * ((2 * MASK_RADIUS) + 1));
    for (int i = 0; i < (2 * MASK_RADIUS) + 1; ++i)
    {
        scanf("%d", &m[i]);
    }
    cudaMalloc((void **)&da, sizeof(int) * input_l);
    cudaMalloc((void **)&dans, sizeof(int) * input_l);
    cudaMemcpyToSymbol(mask, m, sizeof(int) * ((2 * MASK_RADIUS) + 1));
    cudaMemcpy(da, a, sizeof(int) * input_l, cudaMemcpyHostToDevice);
    dim3 gridSize((input_l + TILE_SIZE - 1) / TILE_SIZE);
    conv1d<<<gridSize, TILE_SIZE>>>(da, input_l, dans);
    cudaMemcpy(ans, dans, sizeof(int) * input_l, cudaMemcpyDeviceToHost);
    printf("answer - \n");
    for (int i = 0; i < input_l; ++i)
    {
        printf("%d ", ans[i]);
    }
    cudaFree(da);
    cudaFree(dans);
    return 0;
}