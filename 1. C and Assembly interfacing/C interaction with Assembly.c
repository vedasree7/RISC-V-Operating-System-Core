#include<stdio.h>
extern int reverse(char * input_string);
extern char reverse_string[];

int main(){
    char * input_str = "Hello" ;
    int output = reverse(input_str);
    //printf("input_string: %s\n",input_str);
    printf("reverse_string: %s %d\n",reverse_string,output);
}