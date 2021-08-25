#include<18F2550.h>
#fuses MCLR,NOPBADEN,NOWDT,XT
#use delay(clock=4M)
//definiciones en RAM
#byte latb=0xF8A

#use fixed_io(b_outputs=pin_b0,pin_b1,pin_b2,pin_b3,pin_b4,pin_b5)

void main(){
   //inicializacion de puertos
   output_b(0);     
   latb=0;
   //por siempre...
   while(true){
      while(latb!=0x3F){
         output_b((latb*2)+1);
         delay_ms(50); 
      }
      while(latb!=0x00){
         output_b((latb-1)/2);
         delay_ms(50); 
      }
   }
}
