int global_a;

void func(int a) {
}

void _start() {
	int local_a;
	func(local_a);
	{
		int local_b;
		func(local_b);
		{
			int local_c;
			func(local_c);
		}
	}
}