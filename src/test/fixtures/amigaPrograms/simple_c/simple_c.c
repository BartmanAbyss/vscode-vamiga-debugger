int global_a = 0x11111111;

void func(int a) {
}

__attribute__((used)) __attribute__((section(".text.unlikely"))) void _start() {
	int local_a = 0x22222222;
	func(local_a);
	{
		int local_b = 0x33333333;
		func(local_b);
		{
			int local_c = 0x44444444;
			func(local_c);
		}
	}
	while(1) {}
}