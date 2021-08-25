#include <18F2550.h>
#fuses MCLR,NOPBADEN,NOWDT,XT
#use delay(clock=4M)
//definiciones en RAM
//#byte porta=0xF80
//#byte portb=0xF81
//#byte latb=0xF8A

#use fast_io(a)
#use fast_io(b)

#define pul0 input_state(pin_b0)
#define pul1 input_state(pin_b1)
#define pul2 input_state(pin_b2)
#define pul3 input_state(pin_b3)
#define led0 pin_a0
#define led1 pin_a1
#define led2 pin_a2

void main(){
   set_tris_a(0xF8);   
   set_tris_b(0xFF);
   port_b_pullups(true); 
   output_a(0); 
   //por siempre...
   while(true){
      if(pul0==0){
         while(pul0==0){}
         output_high(led0); 
      }
      else if(pul1==0){
         while(pul1==0){}
         output_high(led1); 
      }
      else if(pul2==0){
         while(pul2==0){}
         output_high(led2); 
      }
      else if(pul3==0){
         while(pul3==0){}
         output_low(led0);
         output_low(led1);
         output_low(led2);
      }
   }
   return;
}
