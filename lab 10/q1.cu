#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define TILE_SIZE 2

__global__ void mul(int *a, int *b, int *c, int a_m, int a_n, int b_n)
{
    __shared__ int m[TILE_SIZE][TILE_SIZE];
    __shared__ int n[TILE_SIZE][TILE_SIZE];

    int row = (blockDim.y * blockIdx.y) + threadIdx.y;
    int col = (blockDim.x * blockIdx.x) + threadIdx.x;

    if (row < a_m && col < b_n)
    {
        // note it is a_n and not a_m
        int total_phases = (a_n + TILE_SIZE - 1) / TILE_SIZE;
        int pval = 0;
        for (int phases = 0; phases < total_phases; ++phases)
        {
            int tiled_col = (phases * TILE_SIZE) + threadIdx.x;
            int tiled_row = (phases * TILE_SIZE) + threadIdx.y;
            if (tiled_col < a_n && tiled_row < a_n)
            {
                m[threadIdx.y][threadIdx.x] = a[(row * a_n) + tiled_col];
                n[threadIdx.y][threadIdx.x] = b[(tiled_row * b_n) + col];
            }
            else
            {
                m[threadIdx.y][threadIdx.x] = 0;
                n[threadIdx.y][threadIdx.x] = 0;
            }
            __syncthreads();
            for (int k = 0; k < TILE_SIZE; ++k)
            {
                pval += m[threadIdx.y][k] * n[k][threadIdx.x];
            }
            __syncthreads();
        }
        c[(row * b_n) + col] = pval;
    }
    return;
}

int main(){
    int *a, *b, *c, m1, n1, m2, n2, *da, *db, *dc;
    printf("enter m1, n1, m2, n2\n");
    scanf("%d %d %d %d", &m1, &n1, &m2, &n2);
    a = (int *)malloc(sizeof(int) * m1 * n1);
    b = (int *)malloc(sizeof(int) * m2 * n2);
    c = (int *)malloc(sizeof(int) * m1 * n2);
    printf("enter a\n");
    for (int i = 0; i < m1; ++i)
    {
        for (int j = 0; j < n1; ++j)
        {
            scanf("%d", &a[(i * n1) + j]);
        }
    }
    printf("enter b\n");
    for (int i = 0; i < m2; ++i)
    {
        for (int j = 0; j < n2; ++j)
        {
            scanf("%d", &b[(i * n2) + j]);
        }
    }
    cudaMalloc((void **)&da, sizeof(int) * m1 * n1);
    cudaMalloc((void **)&db, sizeof(int) * m2 * n2);
    cudaMalloc((void **)&dc, sizeof(int) * m1 * n2);
    cudaMemcpy(da, a, sizeof(int) * m1 * n1, cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, sizeof(int) * m2 * n2, cudaMemcpyHostToDevice);
    dim3 dimBlock(TILE_SIZE, TILE_SIZE);
    // note order x, y
    dim3 dimGrid((n2 + TILE_SIZE - 1) / TILE_SIZE, (m1 + TILE_SIZE - 1) / TILE_SIZE);
    mul<<<dimGrid, dimBlock>>>(da, db, dc, m1, n1, n2);
    cudaMemcpy(c, dc, sizeof(int) * m1 * n2, cudaMemcpyDeviceToHost);
    printf("answer\n");
    for (int i = 0; i < m1; ++i)
    {
        for (int j = 0; j < n2; ++j)
        {
            printf("%d ", c[(i * n2) + j]);
        }
        printf("\n");
    }
    cudaFree(da);
    cudaFree(db);
    cudaFree(dc);
    return 0;
}