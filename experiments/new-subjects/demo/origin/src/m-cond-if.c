#include <stdio.h>
// int Test(int a)
// {
//     int b;
//     if (a > 33 && a < 100)
//     {
//         b = 66;
//     }
//     else
//     {
//         b = 77;
//     }

//     return b;
// }

// int Test1(int a, int b)
// {
//     int c;
//     if (a > 33 && b < 100)
//     {
//         c = 66;
//     }
//     else
//     {
//         c = 77;
//     }

//     return c;
// }

// int Test2(int a, int b)
// {
//     int c;
//     if (a > 33 && b < 100)
//     {
//         c = a + b;
//     }
//     else
//     {
//         c = 77;
//     }

//     return c;
// }

__attribute__((noinline))
int Test3(int a, int b)
{
    int c;
    if (a > 33 && b < 100)
    {
        c = a + b;
        return c;
    }
    else
    {
        return -1;
    }
}

int main(){
    int a, b;
    scanf("%d %d", &a, &b);
    int c = Test3(a, b);
    printf("%d\n", c);
    return 0;
}
