module libtun.testing.app;

import std.stdio;

import libtun.adapter;
import core.thread;

void main()
{
	writeln("Edit source/app.d to start your project.");
	Adapter adapter = new Adapter("testInterface0");

	while(true)
	{
		adapter.send([1,1,2,2,2,2]);
		byte[] buffer;
		adapter.receive(buffer);
		writeln(buffer);
		Thread.sleep(dur!("msecs")(50));
	}
	
}
