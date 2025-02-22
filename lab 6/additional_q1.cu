#include <stdio.h>
#include <stdlib.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void octal(int *arr, int *ans, int n){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if(i < n){
        ans[i] = 0;
        while(arr[i] > 0){
            ans[i] = (arr[i] % 8) + (10 * ans[i]);
            arr[i] /= 8;
        }
        int val = 0;
        while(ans[i] > 0){
            val = (10 * val) + (ans[i] % 10);
            ans[i] /= 10;
        }
        ans[i] = val;
    }
    return;
}

int main(int argc, char **argv){
    int *arr, *ans, n;
    printf("enter size of array\n");
    scanf("%d", &n);
    arr = (int *)malloc(sizeof(int) * n);
    ans = (int *)malloc(sizeof(int) * n);
    printf("enter array\n");
    for(int i = 0; i < n; ++i){
        scanf("%d", &arr[i]);
    }
    int *darr, *dans;
    cudaMalloc((void **)&darr, n * sizeof(int));
    cudaMalloc((void **)&dans, n * sizeof(int));
    cudaMemcpy(darr, arr, n * sizeof(int), cudaMemcpyHostToDevice);
    octal<<<1, n>>>(darr, dans, n);
    cudaMemcpy(ans, dans, n * sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(dans);
    cudaFree(darr);
    for(int i = 0; i < n; ++i){
        printf("%d ", ans[i]);
    }
    return 0;
}