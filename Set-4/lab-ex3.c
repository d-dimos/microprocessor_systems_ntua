/**
 *\ micro.lab.ex3
 
 *\ Συστήματα Μικροϋπολογιστών [Ροή Υ - 6ο Εξάμηνο]
 *\ Εργαστηριακή Άσκηση - Μάιος 2020
 
 *\ Θεμελής Γιώργος - <031 17 131>
 *\ Αμπατζή Ναυσικά - <031 17 198>
 *\ Δήμος Δημήτρης  - <031 17 165>

 *\ ~ Ζήτημα 2.3 ~
 */


#include <avr/io.h>

char x = 1;

int main(void) {
	DDRA = 0x00;
	DDRB = 0xFF;
	PORTB = x;
	
    while (1) {
		if(PINA == 1)
			if (x == 1) x = 128;
			else x = x >> 1;
		else if(PINA == 2)
			if (x == 128) x = 1;
			else x = x << 1;
		else if(PINA == 4)
			x = 1;
		else if(PINA == 8)
			x = 128;
		while(PINA != 0);
		PORTB = x;
    }
}