package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIRegion;
import flixel.addons.ui.FlxUIState;
import haxe.xml.Fast;
import lime.ui.Window;
import openfl.Assets;
#if sys
import sys.FileSystem;
#end
import openfl.display.Application;
import openfl.system.System;

class MenuState extends FlxUIState
{
	
	private var games:Array<GameData>;
	private var gameEntries:Array<GameEntry>;
	private var oldDataStr:String = "";
	
	override public function create():Void
	{
		bgColor = 0xff336699;
		
		_xml_id = "state_menu";
		
		super.create();
		
		refreshGameList();
		
		
	}
	
	public override function getEvent(event:String, target:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void
	{
		if (params != null)
		{
			switch (event)
			{
				case "click_button":
					switch (cast(params[0], String))
					{
						case "close": 
							System.exit(0);
					}
			}
		}
	}
	
	override public function onResize(Width:Int, Height:Int):Void 
	{
		super.onResize(Width, Height);
		reloadUI();
		refreshGameList();
	}
	
	public function clickGame(gameID:Int):Void
	{
		#if sys
		FlxG.stage.application.window.minimized = true;
		Sys.command(StringTools.replace(Reg.settings[Reg.SETTING_GAMEPATH] + games[gameID].git + "/" + games[gameID].executable, "/", "\\"));
		FlxG.stage.application.window.minimized = false;
		#end
	}
	
	private function refreshGameList():Void
	{
		var newDataStr:String = Assets.getText(AssetPaths.gamelist__xml);
		if (newDataStr == oldDataStr)
			return;
			
		oldDataStr = newDataStr;
		
		games = [];
		
		if (gameEntries != null)
		{
			for (e in gameEntries)
			{
				e.kill();
			}
		}
		gameEntries = [];
		
		var data:Fast = new Fast(Xml.parse(oldDataStr).firstElement());
		
		for (d in data.nodes.game)
		{
			games.push(new GameData(d.node.name.innerData, d.node.author.innerData, d.node.os.innerData, d.node.tags.innerData, d.node.git.innerData, d.node.executable.innerData));
		}
		
		var r:FlxUIRegion = cast _ui.getAsset("main-area");
		var across:Int = Std.int(Math.max(r.width / 265, 1));
		var gap:Int = Std.int(Math.max((r.width - (260 * across)) / (across - 1), 5));
		var xPos = 0;
		var yPos = 0;
		var id = 0;
		for (g in games)
		{			
			#if sys
			if (FileSystem.exists(Reg.settings[Reg.SETTING_GAMEPATH] + g.git))
			{
			#end
				gameEntries.push(new GameEntry(r.x + (xPos * (260 + gap)), r.y + (yPos * (140 + gap)), id, this, g));
				add(gameEntries[id]);
				id++;
				xPos++;
				if (xPos > across)
				{
					yPos++;
					xPos = 0;
				}
			#if sys
			}
			#end
		}
		
		
		
	}
	

}
