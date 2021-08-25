#include<18F2550.h>
#fuses MCLR,NOPBADEN,NOWDT,XT
#use delay(clock=4M)
//definiciones en RAM
#byte latb=0xF8A

#use standard_io(b)

void main(){
   //por siempre...
   while(true){
      //inicializacion de puertos
      output_b(0);  
      while(latb!=0xFF){
         output_b((latb*2)+1);
         delay_ms(50); 
      } 
      int aux=0;
      while(latb!=0x80){
         aux*=2;
         aux++;
         output_b(~aux);
         delay_ms(50); 
      }             
   }
}
