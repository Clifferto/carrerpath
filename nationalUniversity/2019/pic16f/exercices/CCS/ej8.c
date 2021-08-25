#include<18F2550.h>
#fuses MCLR,NOPBADEN,NOWDT,XT
#use delay(clock=4M)
//definiciones en RAM
//#byte latb=0xF8A

#use fast_io(b)

int disp[10]={0b00111111,0b00000110,0b01011011,0b01001111,0b01100110
              0b01101101,0b01111101,0b00000111,0b01111111,0b01101111
             };

void mostrar_cont(int c){
   output_b(disp[c]); 
   delay_ms(100);
}
void main(){
   set_tris_b(0);   
   //por siempre...
   while(true){
      int cont=10;
      while(cont!=0){
         cont--;
         mostrar_cont(cont);
      }
      output_b(0); 
      int i;
      for(i=0;i<8;i++){
         output_toggle(pin_b7);
         delay_ms(50);
      }
   }
}
