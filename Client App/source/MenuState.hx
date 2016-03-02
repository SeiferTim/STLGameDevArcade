package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIRegion;
import flixel.addons.ui.FlxUISprite;
import flixel.addons.ui.FlxUIState;
import flixel.util.FlxTimer;
import haxe.ds.StringMap;
import haxe.xml.Fast;
import lime.ui.Window;
import openfl.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
#end
import openfl.display.Application;
import openfl.events.Event;
import openfl.system.System;


class MenuState extends FlxUIState
{
	
	private var games:StringMap<GameData>;
	private var gameEntries:Array<GameEntry>;
	private var oldDataStr:String = "";
	private var syncImg:FlxUISprite;
	
	
	
	override public function create():Void
	{
		bgColor = 0xff336699;
		
		_xml_id = "state_menu";
		
		super.create();
		
		syncImg = cast _ui.getAsset("syncing");
		
		if (Reg.savedData.data.games != null)
			games = Reg.savedData.data.games;
		
		refreshServerData();
		
		
		
	}
	
	private function refreshServerData():Void
	{
		if (!Reg.checkingServerData)
			Reg.checkServerData();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (Reg.checkingServerData)
			syncImg.visible = true;
		else
			syncImg.visible = false;
		
		
		if (Reg.forceRefresh)
		{
			refreshGameList();
			Reg.forceRefresh = false;
		}
		super.update(elapsed);
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
	
	override function reloadUI(?e:Event):Void 
	{
		super.reloadUI(e);
		syncImg = cast _ui.getAsset("syncing");
		
	}	
	public function clickGame(gameID:String):Void
	{
		#if sys
		if (games.get(gameID).exists())
		{
			FlxG.stage.application.window.minimized = true;			
			Sys.command(games.get(gameID).execPath);
			FlxG.stage.application.window.minimized = false;
		}
		#end
	}
	
	public function refreshGameList():Void
	{
		var newFile:Bool = false;
		if (FileSystem.exists("gamelist.xml") && !Reg.checkingServerData)
		{
		
			var newDataStr:String =  File.getContent("gamelist.xml");
			if (newDataStr != oldDataStr)
			{
				oldDataStr = newDataStr;
				games = new StringMap<GameData>();
			}		
		}
		
		if (gameEntries != null)
		{
			for (e in gameEntries)
			{
				e.kill();
			}
		}
		gameEntries = [];
		
		if (oldDataStr != "")
		{
			var data:Fast = new Fast(Xml.parse(oldDataStr).firstElement());
			for (d in data.node.games.nodes.game)
			{
				if (!games.exists(d.node.git.innerData))
				{
					games.set(d.node.git.innerData, new GameData(d.node.name.innerData, d.node.author.innerData, d.node.os.innerData, d.node.tags.innerData, d.node.git.innerData, d.node.executable.innerData, d.node.version.innerData));
				}
				if (!games.get(d.node.git.innerData).exists() || Std.string(games.get(d.node.git.innerData).version) != Std.string(d.node.version.innerData))
				{
					games.get(d.node.git.innerData).version = Std.string(d.node.version.innerData);
					Reg.downloadGame(games.get(d.node.git.innerData));
				}
			}
		}
		
		Reg.savedData.data.games = games;
		Reg.savedData.flush();
		
		if (games != null)
		{
			var r:FlxUIRegion = cast _ui.getAsset("main-area");
			var across:Int = Std.int(Math.max(r.width / 265, 1));
			var gap:Int = Std.int(Math.max((r.width - (260 * across)) / (across - 1), 5));
			var xPos = 0;
			var yPos = 0;
			var id = 0;
			
			for (g in games.iterator())
			{			
				#if sys
				if (FileSystem.exists(Reg.settings[Reg.SETTING_GAMEPATH] + g.git))
				{
				#end
					gameEntries.push(new GameEntry(r.x + (xPos * (260 + gap)), r.y + (yPos * (140 + gap)), this, g));
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
	

}
