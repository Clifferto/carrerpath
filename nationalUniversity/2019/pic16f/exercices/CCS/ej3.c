#include<18F2550.h>
#fuses MCLR,NOPBADEN,NOWDT,INTRC_IO
#use delay(clock=4M)

#use standard_io(a,b,c)

void secuencia(int tipo){
   int estado;
   switch(tipo){
      case 0:
         while(input(pin_a6)!=1){
            estado=input_a()*2;
            output_a(estado);
            delay_ms(200);
         }
      break;
      
      case 1:
         while(input_state(pin_b7)!=1){
            output_b(input_b()*2);
            delay_ms(200); 
         }
      break;
      
      default:
         while(input_state(pin_c7)!=1){
            if(input_state(pin_c2)==1){
               output_c(input_c()*4); 
            }
            else{
               output_c(input_c()*2);
            }
            delay_ms(200); 
         }
      break;             
   }
}

void blink_ports(){
   int i;
   for(i=0;i<10;i++){
      output_a(~input_a()); 
      output_b(~input_b());
      output_c(~input_c());
      delay_ms(100);
   }
}

void main(){
   //inicializaciones de puertos
   output_a(0);
   output_b(0); 
   output_c(0);
   //por siempre...
   while(true){
      output_a(0x01);
      delay_ms(200);
      secuencia(0);
      
      output_b(0x01);
      delay_ms(200);
//      secuencia(1);
      
      output_c(0x01);
      delay_ms(200);
//      secuencia(2);
      
      output_a(0); 
      output_b(0);
      output_c(0);
      delay_ms(200);
      blink_ports();
   }
}
