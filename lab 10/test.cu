#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define TILE_WIDTH 2

__global__ void multiply(int *a, int *b, int *c, int a_n, int b_n, int a_m){
    __shared__ int m[TILE_WIDTH][TILE_WIDTH];
    __shared__ int n[TILE_WIDTH][TILE_WIDTH];
    int row = (blockIdx.y * blockDim.y) + threadIdx.y;
    int col = (blockIdx.x * blockDim.x) + threadIdx.x;
    int pval = 0;
    if(row >= a_m || col >= b_n){
        return;
    }
    int total_phases = (b_n + TILE_WIDTH - 1) / TILE_WIDTH;
    for(int phase = 0; phase < total_phases; ++phase){
        int a_col = (phase * TILE_WIDTH) + threadIdx.x;
        int b_row = (phase * TILE_WIDTH) + threadIdx.y;
        if(a_col >= a_n || b_row >= a_n){
            return;
        }
        m[threadIdx.y][threadIdx.x] = a[(row * a_n) + a_col];
        n[threadIdx.y][threadIdx.x] = b[(b_row * b_n) + col];
        __syncthreads();
        for(int k = 0; k < TILE_WIDTH; ++k){
            pval += m[threadIdx.y][k] * n[k][threadIdx.x];
        }
        __syncthreads();
    }
    c[(b_n * row) + col] = pval;
    return;
}

int main(){
    int *a, *b, *c, m1, m2, n1, n2, *da, *db, *dc;
    printf("enter m1 n1 m2 n2\n");
    scanf("%d %d %d %d", &m1, &n1, &m2, &n2);
    a = (int *)malloc(sizeof(int) * m1 * n1);
    b = (int *)malloc(sizeof(int) * m2 * n2);
    c = (int *)malloc(sizeof(int) * m1 * n2);
    printf("enter a\n");
    for(int i = 0; i < m1; ++i){
        for(int j = 0; j < n1; ++j){
            scanf("%d", &a[(i * n1) + j]);
        }
    }
    printf("enter b\n");
    for(int i = 0; i < m2; ++i){
        for(int j = 0; j < n2; ++j){
            scanf("%d", &b[(i * n2) + j]);
        }
    }
    cudaMalloc((void **)&da, sizeof(int) * m1 * n1);
    cudaMalloc((void **)&db, sizeof(int) * m2 * n2);
    cudaMalloc((void **)&dc, sizeof(int) * m1 * n2);
    cudaMemcpy(da, a, sizeof(int) * m1 * n1, cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, sizeof(int) * m2 * n2, cudaMemcpyHostToDevice);
    dim3 gridSize((n2 + TILE_WIDTH - 1) / TILE_WIDTH, (m1 + TILE_WIDTH - 1) / TILE_WIDTH);
    dim3 blockSize(TILE_WIDTH, TILE_WIDTH);
    multiply<<<gridSize, blockSize>>>(da, db, dc, n1, n2, m1);
    cudaMemcpy(c, dc, sizeof(int) * m1 * n2, cudaMemcpyDeviceToHost);
    printf("answer\n");
    for(int i = 0; i < m1; ++i){
        for(int j = 0; j < n2; ++j){
            printf("%d ", c[(i * n2) + j]);
        }
        printf("\n");
    }
    return 0;
}