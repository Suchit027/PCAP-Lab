#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void change(int *a, int n){
    int i = (blockIdx.x * blockDim.x) + threadIdx.x;
    for(int j = 0; j < n; ++j){
        int val = a[(i * n) + j];
        for(int k = 1; k < i + 1; ++k){
            val *= a[(i * n) + j];
        }
        a[(i * n) + j] = val;
    }
    return;
}

int main(){
    int *a, m, n, *da;
    printf("enter m and n\n");
    scanf("%d %d", &m, &n);
    a = (int *)malloc(sizeof(int) * m * n);
    printf("enter a\n");
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &a[(i * n) + j]);
        }
    }
    cudaMalloc((void **)&da, sizeof(int) * m * n);
    cudaMemcpy(da, a, sizeof(int) * m * n, cudaMemcpyHostToDevice);
    change<<<1, m>>>(da, n);
    cudaMemcpy(a, da, sizeof(int) * m * n, cudaMemcpyDeviceToHost);
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            printf("%d ", a[(i * n) + j]);
        }
        printf("\n");
    }
    cudaFree(da);
    return 0;
}