package macohi.util;

import lime.app.Application;

class WindowUtil
{
	public static function alert(title:String, msg:String)
	{
		Application.current.window.alert(msg, title);
	}
}
