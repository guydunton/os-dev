#ifndef PORTS_H

unsigned char read_port_byte(unsigned short port);
void write_port_byte(unsigned short port, unsigned char data);
unsigned short port_word_in(unsigned short port);
void write_port_word(unsigned short port, unsigned short data);

#endif
