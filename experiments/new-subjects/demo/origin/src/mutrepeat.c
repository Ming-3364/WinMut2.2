#include<stdio.h>


int arith(){
    int a, b;
    scanf("%d %d", &a, &b);
    printf("arith\n");
    int c, d, e, f, g, h, i, j, k;
    c = a + b;
    d = a - b;
    e = c * d;
    f = c / d;
    g = e & f;
    h = e | f;
    i = g ^ h;
    return i;
}

int run(){
    int a = arith();
    int b = arith();
    printf("hello\n");
    return a + b;
}

int main(){
    int c = run();
    return 0;
}