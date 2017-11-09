#include "contiki.h"
#include <stdio.h>
#include "verify.h"
/*---------------------------------------------------------------------------*/
PROCESS(runner, "Runner");
AUTOSTART_PROCESSES(&runner);
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(runner, ev, data)
{
  PROCESS_BEGIN();
  printf("Hey I'm the runner\n");

  //test();
  
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
