#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

__global__ void csr(int *data, int *col, int *row, int *b, int *ans){
    int i = (blockIdx.x * blockDim.x) + threadIdx.x;
    ans[i] = 0;
    for(int start = row[i]; start < row[i + 1]; ++start){
        ans[i] += data[start] * b[col[start]];
    }
    return;
}

int main(){
    int *a, *data, *col, *row, *ddata, *dcol, *drow, *b, *db, *ans, *dans, m, n;
    printf("enter m and n\n");
    scanf("%d %d", &m, &n);
    printf("enter a\n");
    a = (int *)malloc(sizeof(int) * m * n);
    int length = 0;
    for(int i = 0; i < m; ++i){
        for(int j = 0; j < n; ++j){
            scanf("%d", &a[(i * n) + j]);
            if(a[(i * n) + j] != 0){
                length += 1;
            }
        }
    }
    data = (int *)malloc(sizeof(int) * length);
    col = (int *)malloc(sizeof(int) * length);
    row = (int *)malloc(sizeof(int) * (m + 1));
    int k = 0, x = 0;
    for(int i = 0; i < m; ++i){
        row[i] = x;
        for(int j = 0; j < n; ++j){
            if(a[(i * n) + j] != 0){
                data[k] = a[(i * n) + j];
                col[k++] = j;
                x += 1;
            }
        }
    }
    row[m] = length;
    printf("enter b\n");
    b = (int *)malloc(sizeof(int) * n);
    for(int i = 0; i < n; ++i){
        scanf("%d", &b[i]);
    }
    ans = (int *)malloc(sizeof(int) * m);
    cudaMalloc((void **)&ddata, sizeof(int) * length);
    cudaMalloc((void **)&dcol, sizeof(int) * length);
    cudaMalloc((void **)&drow, sizeof(int) * (m + 1));
    cudaMalloc((void **)&db, sizeof(int) * n);
    cudaMalloc((void **)&dans, sizeof(int) * m);
    cudaMemcpy(ddata, data, sizeof(int) * length, cudaMemcpyHostToDevice);
    cudaMemcpy(dcol, col, sizeof(int) * length, cudaMemcpyHostToDevice);
    cudaMemcpy(drow, row, sizeof(int) * (m + 1), cudaMemcpyHostToDevice);
    cudaMemcpy(db, b, sizeof(int) * n, cudaMemcpyHostToDevice);
    csr<<<1, m>>>(ddata, dcol, drow, db, dans);
    cudaMemcpy(ans, dans, sizeof(int) * m, cudaMemcpyDeviceToHost);
    for(int i = 0; i < m; ++i){
        printf("%d ", ans[i]);
    }
    cudaFree(db);
    cudaFree(ddata);
    cudaFree(dans);
    cudaFree(drow);
    cudaFree(dcol);
    return 0;
}