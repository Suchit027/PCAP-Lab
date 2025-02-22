#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void comp(int *arr, int *ans, int n) {
    int i = (blockDim.x * blockIdx.x) + threadIdx.x;
    if (i < n) {
        ans[i] = ~arr[i];
    }
}

int binary_to_int(const char *binary_str) {
    int result = 0;
    for (int i = 0; binary_str[i] != '\0'; i++) {
        result = result * 2 + (binary_str[i] - '0');
    }
    return result;
}

void int_to_binary(int num, char *binary_str, int size) {
    for (int i = size - 1; i >= 0; i--) {
        binary_str[size - 1 - i] = (num & (1 << i)) ? '1' : '0';
    }
    binary_str[size] = '\0';
}

int main() {
    int *arr, *ans, n;
    printf("Enter size of array: ");
    scanf("%d", &n);

    arr = (int *)malloc(sizeof(int) * n);
    ans = (int *)malloc(sizeof(int) * n);

    printf("Enter binary numbers (as strings of 1's and 0's):\n");
    for (int i = 0; i < n; ++i) {
        char binary_str[33];
        scanf("%s", binary_str);
        arr[i] = binary_to_int(binary_str);
    }

    int *darr, *dans;
    cudaMalloc((void **)&darr, n * sizeof(int));
    cudaMalloc((void **)&dans, n * sizeof(int));

    cudaMemcpy(darr, arr, n * sizeof(int), cudaMemcpyHostToDevice);

    int blockSize = 256;
    int numBlocks = (n + blockSize - 1) / blockSize;
    comp<<<numBlocks, blockSize>>>(darr, dans, n);

    cudaDeviceSynchronize();


    cudaMemcpy(ans, dans, n * sizeof(int), cudaMemcpyDeviceToHost);


    cudaFree(dans);
    cudaFree(darr);


    printf("\nOne's complement in binary:\n");
    for (int i = 0; i < n; ++i) {
        char binary_result[33];
        int_to_binary(ans[i], binary_result, 32);
        printf("%s\n", binary_result);
    }

    free(arr);
    free(ans);

    return 0;
}
