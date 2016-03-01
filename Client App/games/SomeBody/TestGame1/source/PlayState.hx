package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	override public function create():Void
	{
		
		var t:FlxText = new FlxText(0, 0, 0, "Hello, World!");
		t.setFormat(null, 36, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.GRAY);
		
		t.screenCenter(FlxAxes.XY);
		add(t);
		
		super.create();
	}

}
