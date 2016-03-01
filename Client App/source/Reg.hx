package;

import flixel.util.FlxSave;
import haxe.xml.Fast;
import openfl.Assets;

class Reg
{
	private static var oldSettingsStr:String = "";
	
	public static var settings:Array<String>;
	
	public static inline var SETTING_GAMEPATH:Int = 0;
	
	
	public static function loadSettings():Void
	{
		
		var newSettingsStr:String = Assets.getText(AssetPaths.config__xml);
		if (newSettingsStr == oldSettingsStr)
			return;
			
		oldSettingsStr = newSettingsStr;
		settings = [];
		
		var data:Fast = new Fast(Xml.parse(oldSettingsStr).firstElement());
		
		if (data.hasNode.gamepath)
		{
			settings[SETTING_GAMEPATH] = data.node.gamepath.innerData;
		}
		
		
	}
	
}
