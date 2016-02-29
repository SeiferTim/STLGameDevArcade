package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

class MenuState extends FlxUIState
{
	override public function create():Void
	{
		bgColor = 0xff336699;
		
		_xml_id = "state_menu";
		
		 
		
		super.create();
		
		
	}
	
	override public function onResize(Width:Int, Height:Int):Void 
	{
		super.onResize(Width, Height);
		reloadUI();
	}

}
