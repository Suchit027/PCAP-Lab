#include <stdio.h>
#include <stdlib.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void conv(int *arr, int *mask, int l_arr, int l_mask, int *ans){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    int val = 0;
    int start = i - (l_mask / 2);
    for(int j = 0; j < l_mask; ++j){
        if (j + start >= 0 && j + start < l_arr){
            val += arr[j + start] * mask[j];
        }
    }
    ans[i] = val;
}

int main(int argc, char **argv){
    printf("enter array size\n");
    int n;
    scanf("%d", &n);
    int *arr = (int *)malloc(n * sizeof(int));
    int *ans = (int *)malloc(n * sizeof(int));
    printf("enter array\n");
    for (int i = 0; i < n; ++i){
        scanf("%d", &arr[i]);
    }
    printf("enter mask size\n");
    int m;
    scanf("%d", &m);
    printf("enter mask\n");
    int *mask = (int *)malloc(m *sizeof(int));
    for(int i = 0; i < m; ++i){
        scanf("%d", &mask[i]);
    }
    int *dmask, *darr, *dans;
    cudaMalloc((void **)&darr, n * sizeof(int));
    cudaMalloc((void **)&dans, n * sizeof(int));
    cudaMalloc((void **)&dmask, m * sizeof(int));
    cudaMemcpy(dmask, mask, m * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(darr, arr, n * sizeof(int), cudaMemcpyHostToDevice);
    conv<<<1, n>>>(darr, dmask, n, m, dans);
    cudaMemcpy(ans, dans, n * sizeof(int), cudaMemcpyDeviceToHost);
    for(int i = 0; i < n; ++i){
        printf("%d ", ans[i]);
    }
    cudaFree(dans);
    cudaFree(dmask);
    cudaFree(darr);
    return 0;
}