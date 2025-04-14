#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void change(int *a, int m, int n){
    int i = blockIdx.x;
    int j = threadIdx.x;
    if (i > 0 && i < m - 1 && j > 0 && j < n - 1){
        a[(i * n) + j] = ~a[(i * n) + j] & 0xF;
    }
    return;
}

int main(){
    int *a, m, n, *da;
    printf("enter m and n\n");
    scanf("%d %d", &m, &n);
    a = (int *)malloc(sizeof(int) * m * n);
    cudaMalloc((void **)&da, sizeof(int) * m * n);
    printf("enter a\n");
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &a[(i * n) + j]);
        }
    }
    cudaMemcpy(da, a, sizeof(int) * m * n, cudaMemcpyHostToDevice);
    change<<<m, n>>>(da, m, n);
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