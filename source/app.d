import std.stdio;

import libtun.adapter;
import core.thread;

void main()
{
	writeln("Edit source/app.d to start your project.");
	TUNAdapter adapter = new TUNAdapter("testInterface0");

	while(true)
	{
		adapter.send([1,1,2,2,2,2]);
		Thread.sleep(dur!("msecs")(500));
	}
	
}
