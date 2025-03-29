#include <iostream>
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void MyKernel(int *a, int *b, int *c, int N) {

    int x = blockIdx.y * blockDim.y + threadIdx.y;

    int y = blockIdx.x * blockDim.x + threadIdx.x;

    if (y <N && x < N) {

        int sum = 0;

        for (int k = 0; k < N; k++) {

        sum += a[x * N + k] * b[x + k * N];

        }

        c[y + x * N ] = sum;

    }

}

int main() {
    int A[256];
    for (int i = 0; i < 256; i++)
        A[i] = 1;

    int B[256];
    for (int i = 0; i < 256; i++)
        B[i] = 2;

    int C[256];

    int size = sizeof(int) * 256;
    
    int *d_A, *d_B, *d_C;

    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);

    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, size, cudaMemcpyHostToDevice);

    MyKernel<<<(8, 2), (1, 16)>>>(d_A, d_A, d_C, 16);

    cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

    for (int i = 0; i < size; i++){
        printf("%d ", C[i]);}
    return 0;
}
