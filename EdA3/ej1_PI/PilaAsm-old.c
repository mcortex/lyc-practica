#include <stdlib.h>
#include <string.h>
#include "Funciones.h"

struct m10_stack_t *crearPila(void)
{
  struct m10_stack_t *stack = malloc(sizeof *stack);
  if (stack)
  {
    stack->tope = NULL;
    stack->tam = 0;
  }
  return stack;
};

tInfo copiarDato(tInfo str)
{
  tInfo tmp =(tInfo) malloc(sizeof(tInfo));
  if (tmp)
    memcpy(tmp, str,sizeof(tInfo));
  return tmp;
}

void ponerenPila(struct m10_stack_t *theStack, tInfo value)
{
  struct m10_stack_entry *entry = malloc(sizeof *entry); 
  if (entry)
  {
    entry->dato = copiarDato(value);
    entry->next = theStack->tope;
    theStack->tope = entry;
    theStack->tam++;
  }
}

tInfo topedePila(struct m10_stack_t *theStack)
{
  if (theStack && theStack->tope)
    return theStack->tope->dato;
  else
    return NULL;
}

void sacardePila(struct m10_stack_t *theStack)
{
  if (theStack->tope != NULL)
  {
    theStack->tope = theStack->tope->next;
    theStack->tam--;
  }
}

void vaciarPila(struct m10_stack_t *theStack)
{
  while (theStack->tope != NULL)
    sacardePila(theStack);
}

void borrarPila(struct m10_stack_t **theStack)
{
  vaciarPila(*theStack);
  free(*theStack);
  *theStack = NULL;
}