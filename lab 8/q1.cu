#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void add(int *a, int *b, int n, int *ans){
    int id = (blockIdx.x * blockDim.x) + threadIdx.x;
    for(int i = 0; i < n; ++i){
        ans[(id * n) + i] = 0;
        ans[(id * n) + i] = a[(id * n) + i] + b[(id * n) + i];
    }
    return;
}

int main(){
    int *a, *b, *ans, m, n, *da, *db, *dans;
    printf("enter m and n\n");
    scanf("%d %d", &m, &n);
    a = (int *)malloc(m * n * sizeof(int));
    b = (int *)malloc(m * n * sizeof(int));
    ans = (int *)malloc(m * n * sizeof(int));
    printf("enter a\n");
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &a[(i * n) + j]);
        }
    }
    printf("enter b\n");
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &b[(i * n) + j]);
        }
    }
    cudaMalloc((void **)&da, m * n * sizeof(int));
    cudaMalloc((void **)&db, m * n * sizeof(int));
    cudaMalloc((void **)&dans, m * n * sizeof(int));
    cudaMemcpy(da, a, m * n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, m * n * sizeof(int), cudaMemcpyHostToDevice);
    add<<<1, m>>>(da, db, n, dans);
    cudaMemcpy(ans, dans, m * n * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            printf("%d ", ans[(i * n) + j]);
        }
        printf("\n");
    }
    cudaFree(a);
    cudaFree(b);
    cudaFree(ans);
    return 0;
}