#include <stdio.h>
__attribute__((noinline))
int Test3(int a, int b)
{
    int sum = a + b;
    int add = sum + sum + 2;
    return add;
}

int main(){
    int a, b;
    scanf("%d %d", &a, &b);
    int c = Test3(a, b);
    printf("%d\n", c);
    return c;
}