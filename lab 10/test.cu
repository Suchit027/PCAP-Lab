#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define TILE_SIZE 5
#define MASK_RADIUS 2

__constant__ int mask[5];

__global__ void conv1d(int *a, int *ans, int input_l)
{
    __shared__ int m[TILE_SIZE + (2 * MASK_RADIUS)];
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i < input_l)
    {
        m[threadIdx.x + MASK_RADIUS] = a[i];
        if (threadIdx.x < MASK_RADIUS)
        {
            if (i - MASK_RADIUS > 0)
            {
                m[threadIdx.x] = a[i - MASK_RADIUS];
            }
            else
            {
                m[threadIdx.x] = 0;
            }
        }
        if (threadIdx.x + (2 * MASK_RADIUS) >= TILE_SIZE)
        {
            if (i + MASK_RADIUS < input_l)
            {
                m[threadIdx.x + (2 * MASK_RADIUS)] = a[i + MASK_RADIUS];
            }
            else
            {
                m[threadIdx.x + (2 * MASK_RADIUS)] = 0;
            }
        }
        __syncthreads();
        ans[i] = 0;
        for (int j = -MASK_RADIUS; j < MASK_RADIUS + 1; ++j)
        {
            ans[i] += m[threadIdx.x + MASK_RADIUS + j] * mask[MASK_RADIUS + j];
        }
    }
    return;
}