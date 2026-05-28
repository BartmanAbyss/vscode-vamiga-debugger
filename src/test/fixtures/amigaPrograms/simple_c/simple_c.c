struct Struct {
	int _int;
	short _short;
	char _char;
} globals = {
	._int = 0x11111111,
	._short = 0x2222,
	._char = 0x33
} ;

__attribute__((used)) __attribute__((section(".text.unlikely"))) void _start() {
	struct Struct* ptr_struct = &globals;
	ptr_struct->_int = 0x99999999;
	ptr_struct->_short = 0x8888;
	ptr_struct->_char = 0x77;
	while(1) {}
}