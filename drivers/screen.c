#include "screen.h"
#include "../kernal/util.h"
#include "ports.h"

int get_cursor_offset();
void set_cursor_offset(int offset);
int print_char(char character, int col, int row, char attribute_byte);
int get_offset(int col, int row);
int get_offset_row(int offset);
int get_offset_col(int offset);

void kprint_at(char* message, int col, int row) {
  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_offset(col, row);
  } else {
    offset = get_cursor_offset();
    row = get_offset_row(offset);
    col = get_offset_col(offset);
  }

  int i = 0;
  while (message[i] != 0) {
    offset = print_char(message[i++], col, row, WHITE_ON_BLACK);

    row = get_offset_row(offset);
    col = get_offset_col(offset);
  }
}

void kprint(char* message) {
  kprint_at(message, -1, -1);
}

void clear_screen() {
  int screen_size = MAX_COLS * MAX_ROWS;
  char* screen = (unsigned char*)VIDEO_ADDRESS;

  for (int i = 0; i < screen_size; ++i) {
    screen[i * 2] = ' ';
    screen[i * 2 + 1] = WHITE_ON_BLACK;
  }
  set_cursor_offset(get_offset(0, 0));
}

int print_char(char character, int col, int row, char attribute_byte) {
  // Create a byte (char) pointer to the start of video memory
  unsigned char* vidmem = (unsigned char*)VIDEO_ADDRESS;

  // If attribute byte is zero, assume default style
  if (!attribute_byte) {
    attribute_byte = WHITE_ON_BLACK;
  }

  if (col >= MAX_COLS || row >= MAX_ROWS) {
    vidmem[2 * (MAX_COLS) * (MAX_ROWS)-2] = 'E';
    vidmem[2 * (MAX_COLS) * (MAX_ROWS)-1] = RED_ON_WHITE;
    return get_offset(col, row);
  }

  // Get the video memory offset for the screen location
  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_offset(col, row);
  } else {
    // Otherwise use the current cursor position
    offset = get_cursor_offset();
  }

  // If we see a newline character, set offset to the end of
  // current row, so it will be advanced to the first col of
  // the next row
  if (character == '\n') {
    row = get_offset_row(offset);
    offset = get_offset(0, row + 1);
  } else {
    // Otherwise write the character and it's attribute byte to
    // video memory at our calculated offset
    vidmem[offset] = character;
    vidmem[offset + 1] = attribute_byte;
    offset += 2;
  }

  // Check if the offset is over screen size & scroll
  if (offset >= MAX_ROWS * MAX_COLS * 2) {
    for (int i = 1; i < MAX_ROWS; i++) {
      char* start = (unsigned char*)(get_offset(0, i) + VIDEO_ADDRESS);
      char* end = (unsigned char*)(get_offset(0, i - 1) + VIDEO_ADDRESS);
      memory_copy(start, end, MAX_COLS * 2);
    }

    // Blank last line
    char* last_line =
        (unsigned char*)(get_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS);
    for (int i = 0; i < MAX_COLS * 2; ++i) {
      last_line[i] = 0;
    }

    offset -= 2 * MAX_COLS;
  }

  // Update the cursor position on the screen device
  set_cursor_offset(offset);
  return offset;
}

int get_cursor_offset() {
  write_port_byte(REG_SCREEN_CTRL, 14);
  int offset = read_port_byte(REG_SCREEN_DATA) << 8;
  write_port_byte(REG_SCREEN_CTRL, 15);
  offset += read_port_byte(REG_SCREEN_DATA);
  return offset * 2;
}

void set_cursor_offset(int offset) {
  offset /= 2;
  write_port_byte(REG_SCREEN_CTRL, 14);
  write_port_byte(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
  write_port_byte(REG_SCREEN_CTRL, 15);
  write_port_byte(REG_SCREEN_DATA, (unsigned char)(offset & 0xff));
}

int get_offset(int col, int row) {
  return 2 * (row * MAX_COLS + col);
}

int get_offset_row(int offset) {
  return offset / (2 * MAX_COLS);
}

int get_offset_col(int offset) {
  return (offset - (get_offset_row(offset) * 2 * MAX_COLS)) / 2;
}
