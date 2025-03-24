#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void mul(int *data, int *col, int *row, int *b, int *ans){
    int r = (blockIdx.x * blockDim.x) + threadIdx.x;
    for(int i = ; )
}