package;
import flixel.FlxG;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIGroup;
import flixel.addons.ui.FlxUISprite;
import flixel.addons.ui.FlxUIText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.ui.FlxButton;
import openfl.display.BitmapData;

import openfl.Assets;

class GameEntry extends FlxUIGroup
{
	private var button:FlxUIButton;
	private var logo:FlxUISprite;
	private var title:FlxUIText;
	private var parent:MenuState;
	private var id:Int = 0;

	public function new(X:Float, Y:Float, id:Int, parent:MenuState, gameData:GameData) 
	{
		super(X, Y);
		
		this.id = id;
		this.parent = parent;
		
		logo = new FlxUISprite(5,5);
		logo.loadGraphic(Assets.getBitmapData("games/" + gameData.git + "/logo.png"), false, 260, 120);
		
		title = new FlxUIText(5, 125, 260, gameData.name, 24);
		title.font = AssetPaths.opensansb__ttf;
		title.alignment = "center";
		title.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xff333333, 1, 1);
		
		button = new FlxUIButton(0, 0, "", clickButton);
		button.loadGraphicSlice9([AssetPaths.button_up__png, AssetPaths.button_over__png,AssetPaths.button_down__png], 270, Std.int(135 + title.height), [[6, 5, 43, 40], [6, 5, 43, 40], [6, 9, 43, 44]]);
		
		add(button);
		add(logo);
		add(title);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		if (button.status == FlxButton.PRESSED)
		{
			logo.y = y + 9;
			title.y = logo.y + logo.height + 5;
		}
		else
		{
			logo.y = y + 5;
			title.y = logo.y + logo.height + 5;
		}
		super.update(elapsed);
	}
	
	private function clickButton():Void
	{
		parent.clickGame(id);
	}
}