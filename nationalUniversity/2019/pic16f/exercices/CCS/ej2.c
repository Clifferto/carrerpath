#include <18f2550.h>
#use delay(clock=4M)
//MCLR,NOWATCHDOG,OSCINT,PORTB DIGITAL
#fuses MCLR,NOWDT,INTRC_IO,NOPBADEN
//Definiciones en RAM
#byte PORTA=0xF80
#byte TRISA=0xF92
#byte OSCCON=0xFD3

int1 izq_der;

void rot_port(int1 izq_der){
   if(izq_der==true){
      while(PORTA!=0){
         PORTA<<=1;
         delay_ms(100);
      }
   }
   else{
      while(PORTA!=0){
         PORTA>>=1;
         delay_ms(100);
      }
   }   
}

void blink_port(){
   int i;
   for(i=0;i<6;i++){
      PORTA=~PORTA;
      delay_ms(250); 
   }
}

void count(){
   do{
      PORTA++;
      delay_ms(10);
   }
   while(PORTA!=0); 
}

void main(){
   //Oscilador interno a 4MHz
   bit_set(OSCCON,5);
   //PORTA salida digital e inicializacion
   TRISA=0;
   PORTA=0;
   //Por siempre..
   for(;;){
      //Inicializa secuencia con RA0=1
      PORTA=0x01;
      delay_ms(100);
      //Rotar a la izq el 1 hasta que desborde
      rot_port(true);
      //Inicializa con RA6=1
      PORTA=0x40;
      delay_ms(100);
      //Rotar a la der hasta que desborde
      rot_port(false);
      //Parpadea los leds del puerto
      blink_port();
      //Cuenta desde 0 hasta que desborde
      count();
   }
}



