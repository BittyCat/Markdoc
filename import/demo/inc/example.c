#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "bitops.h"

int len(char *str)
{
  int len = 0;

  while (str[len] != 0)
  {
    len++;
  }

  return len;
}
