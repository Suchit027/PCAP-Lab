#include <stdio.h>
#include <stdlib.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void sort(int *arr, int l_arr, int *ans){
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if(i < l_arr){
        int val = arr[i];
        int idx = 0;
        for(int j = 0; j < l_arr; ++j){
            if (arr[j] < val || (arr[j] == val && j < i)){
                idx += 1;
            }
        }
        ans[idx] = val;
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
    sort<<<1, n>>>(darr, n, dans);
    cudaMemcpy(ans, dans, n * sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(dans);
    cudaFree(darr);
    for(int i = 0; i < n; ++i){
        printf("%d ", ans[i]);
    }
    return 0;
}