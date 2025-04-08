#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__constant__ int mask[20];

__global__ void convconstant(int *a, int *b, int mask_len, int a_len){
    int i = (blockIdx.x * blockDim.x) + threadIdx.x;
    int val = 0;
    int start = i - (mask_len / 2);
    for(int j = 0; j < mask_len; ++j){
        if(start + j >= 0 && start + j < a_len){
            val += a[start + j] * mask[j];
        }
    }
    b[i] = val;
    return;
}

int main(){
    int *a, *da, *b, *db, *maskk, n, m;
    printf("enter mask size\n");
    scanf("%d", &m);
    printf("enter mask\n");
    maskk = (int *)malloc(sizeof(int) * m);
    for(int i = 0; i < m; ++i){
        scanf("%d", &maskk[i]);
    }
    printf("enter array size\n");
    scanf("%d", &n);
    a = (int *)malloc(sizeof(int) * n);
    b = (int *)malloc(sizeof(int) * n);
    printf("enter array\n");
    for(int i = 0; i < n; ++i){
        scanf("%d", &a[i]);
    }
    cudaMalloc((void **)&da, sizeof(int) * n);
    cudaMalloc((void **)&db, sizeof(int) * n);
    cudaMemcpyToSymbol(mask, maskk, sizeof(int) * m);
    cudaMemcpy(da, a, sizeof(int) * n, cudaMemcpyHostToDevice);
    convconstant<<<1, n>>>(da, db, m, n);
    cudaMemcpy(b, db, sizeof(int) * n, cudaMemcpyDeviceToHost);
    printf("answer - \n");
    for(int i = 0; i < n; ++i){
        printf("%d ", b[i]);
    }
    cudaFree(da);
    cudaFree(db);
    return 0;
}