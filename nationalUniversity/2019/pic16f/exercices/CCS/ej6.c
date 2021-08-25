#include<18F2550.h>
#fuses MCLR,NOPBADEN,NOWDT,XT
#use delay(clock=4M)
//definiciones en RAM
#byte latb=0xF8A

#use fast_io(all)

void main(){
   //inicializacion de puertos
   set_tris_a(0xFE);
   port_b_pullups(true); 
   output_b(0); 
   //por siempre...
   while(true){
      while(input(pin_b0)==0){
         output_high(pin_a0);
      }
      output_low(pin_a0); 
   }
}
