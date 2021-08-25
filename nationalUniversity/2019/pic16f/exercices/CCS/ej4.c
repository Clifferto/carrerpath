#include<18F2550.h>
#fuses MCLR,NOPBADEN,NOWDT,INTRC_IO
#use delay(clock=4M)

#use fixed_io(b_outputs=pin_b0,pin_b1,pin_b2,pin_b3,pin_b4,pin_b5,pin_b6,pin_b7)

void main(){
   set_tris_b(0); 
   //inicializacion de puertos
   output_a(0);
   output_b(0); 
   output_c(0);
   //por siempre...
   while(true){
      output_b(0xFF);
      delay_ms(200);
      output_b(0x00);
      delay_ms(200);
      input_b();
   }
}
