#include <stdio.h>
#include <stdlib.h>
#include <conio.h>


#define MAX 1000

int count = 0;

// Creating a stack
struct stack {
  //char *items[MAX];
  int items[MAX];
  int top;
};

// defino el tipo st con estructura de stack (pila)
typedef struct stack st;

st *createEmptyStack() {
    st *pila = (st *)malloc(sizeof(st));
    pila->top = -1;
    return pila;
}

// Check if the stack is full
int isfull(st *s) {
  if (s->top == MAX - 1)
    return 1;
  else
    return 0;
}

// Check if the stack is empty
int isempty(st *s) {
  if (s->top == -1)
    return 1;
  else
    return 0;
}

// Add elements into stack
// void push(st *s, char *newitem) {
//   if (isfull(s)) {
//     printf("STACK FULL");
//   } else {
//     s->top++;
//     s->items[s->top] = newitem;
//   }
//   count++;
// }

// Remove element from stack
// void pop(st *s) {
//   if (isempty(s)) {
//     printf("\n STACK EMPTY \n");
//   } else {
//     printf("Item popped= %s", s->items[s->top]);
//     s->top--;
//   }
//   count--;
//   printf("\n");
// }

// Print elements of stack
// void printStack(st *s) {
//   printf("Stack: ");
//   for (int i = 0; i < count; i++) {
//     printf("%s |", s->items[i]);
//   }
//   printf("\n");
// }

void push(st *s, int newitem) {
  if (isfull(s)) {
    printf("STACK FULL");
  } else {
    s->top++;
    s->items[s->top] = newitem;
  }
  count++;
}

int pop(st *s) {
  if (isempty(s)) {
    printf("\n STACK EMPTY \n");
  } else {
    int aux;
    //printf("Item popped= %s",s->items[s->top]);
    aux=s->items[s->top];
    s->top--;count--;
    //printf("\n");
    return aux;
  } 
}

// Print elements of stack
void printStack(st *s) {
  printf("Stack: ");
  for (int i = 0; i < count; i++) {
    printf("%d |", s->items[i]);
  }
  printf("\n");
}