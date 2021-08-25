#include <18f2550.h>
#use delay(clock=4M)
#fuses MCLR,NOWDT,INTRC_IO,NOPBADEN

#byte PORTA=0xF80
#byte TRISA=0xF92
#byte OSCCON=0xFD3
#bit RA0=PORTA.0

void main(){
   TRISA=0;
   PORTA=0;
   
   for(;;){
      RA0=1;
      delay_ms(1000);
      RA0=0;
      delay_ms(1000);
   }
}

