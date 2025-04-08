#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define MAXLEN 20 

__global__ void inclusive(int *a, int a_len){
    __shared__ int temp[MAXLEN];
    int i = (blockIdx.x * blockDim.x) + threadIdx.x;
    temp[i] = a[i];
    __syncthreads();
    for(int stride = 1; stride < a_len; stride *= 2){
        int val = 0;
        if(stride <= i){
            val = temp[i - stride];
        }
        __syncthreads();
        temp[i] += val;
        __syncthreads();
    }
    a[i] = temp[i];
    return;
}

int main(){
    int *a, n, *da;
    printf("enter array size\n");
    scanf("%d", &n);
    a = (int *)malloc(sizeof(int) * n);
    printf("enter array\n");
    for(int i = 0; i < n; ++i){
        scanf("%d", &a[i]);
    }
    cudaMalloc((void **)&da, sizeof(int) * n);
    cudaMemcpy(da, a, sizeof(int) * n, cudaMemcpyHostToDevice);
    inclusive<<<1, n>>>(da, n);
    cudaMemcpy(a, da, sizeof(int) * n, cudaMemcpyDeviceToHost);
    printf("answer \n");
    for(int i = 0; i < n; ++i){
        printf("%d ", a[i]);
    } 
    cudaFree(da);
    return 0;
}