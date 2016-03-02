package;

import com.akifox.asynchttp.HttpRequest;
import com.akifox.asynchttp.HttpResponse;
import flixel.FlxG;
import flixel.util.FlxSave;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.xml.Fast;
import haxe.zip.Entry;
import haxe.zip.Reader;
import openfl.Assets;
#if sys
import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;
#end


class Reg
{
	
	public static var checkingServerData:Bool = false;
	public static var forceRefresh:Bool = false;
	
	private static var oldSettingsStr:String = "";
	
	public static var settings:Array<String>;
	
	public static inline var SETTING_GAMEPATH:Int = 0;
	public static inline var SETTING_SERVERPATH:Int = 1;
	
	private static var request:HttpRequest;
	
	public static var savedData:FlxSave;
	
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
		if (data.hasNode.serverpath)
		{
			settings[SETTING_SERVERPATH] = data.node.serverpath.innerData;
		}
		
		savedData = new FlxSave();
		savedData.bind("STLGDArcade-savedData");
		
	}
	
	public static function downloadGame(gameData:GameData):Void
	{
		var filename:String = Reg.slugify(gameData.git) + "-" + gameData.version + ".zip";
		trace('Downloading ${filename}');
		var newRequest:HttpRequest = new HttpRequest({
			url : settings[SETTING_SERVERPATH] + "games/" + filename,
			timeout: 300,
			callback : function(response:HttpResponse):Void {
						if (response.isOK) {
							trace("Download complete...");
							if (!FileSystem.exists(StringTools.replace(settings[SETTING_GAMEPATH]  + "tmp/" , "/", "\\")))
								FileSystem.createDirectory(StringTools.replace(settings[SETTING_GAMEPATH]  + "tmp/" , "/", "\\"));
							var newFile:FileOutput = File.write(StringTools.replace(settings[SETTING_GAMEPATH]  + "tmp/" + filename, "/", "\\"), response.contentIsBinary);
							try {
								newFile.write(response.contentRaw);
								newFile.flush();
								
							}
							catch (err:Dynamic)
							{
								trace('Error writing file' + err);
							}
							newFile.close();
							
							if (FileSystem.exists(StringTools.replace(settings[SETTING_GAMEPATH]  + "tmp/" + filename, "/", "\\")))
							{
								extractZip(settings[SETTING_GAMEPATH]  + "tmp/" + filename, settings[SETTING_GAMEPATH]  + gameData.git + "/" );
								
							}
							forceRefresh = true;
							trace('DONE (HTTP STATUS ${response.status})');
						}
						else
						{
							trace('ERROR ${response.status} ${response.error})');
						}
					}
		});
		newRequest.send();
		
		
		
	}
	
	public static function extractZip(SourceFile:String, DestPath:String):Void
	{
		SourceFile = StringTools.replace(SourceFile, "/", "\\");
		DestPath = StringTools.replace(DestPath, "/", "\\");
		
		var bytes:Bytes = File.getBytes(SourceFile);
		var entries:List<Entry> = Reader.readZip(new BytesInput(bytes));
		
		for (entry in entries)
		{
			
			if (entry.fileName.charAt(entry.fileName.length - 1) == "/")
			{
				FileSystem.createDirectory(DestPath + StringTools.replace( entry.fileName, "/", "\\"));
			}
			else
			{
			
				var content = (entry.compressed) ? Reader.unzip(entry) : entry.data;
				var f = File.write(DestPath + StringTools.replace( entry.fileName, "/", "\\"), true);
				f.write(content);
				f.close();
			}
			
		}
		
		
	}
	
	
	
	public static function checkServerData():Void
	{
		if (checkingServerData)
			return;
		
		checkingServerData = true;
		var newRequest:HttpRequest;
		
		if (request == null)
		{
			request = new HttpRequest({
					url : settings[SETTING_SERVERPATH] + "gamelist.xml",
					callback : function(response:HttpResponse):Void {
							
							if (response.isOK) {
								var newFile:FileOutput = File.write(response.filename, response.contentIsBinary);
								try {
									newFile.write(response.contentRaw);
									newFile.flush();
								}
								catch (err:Dynamic)
								{
									trace('Error writing file' + err);
								}
								newFile.close();
								forceRefresh = true;
								trace('DONE (HTTP STATUS ${response.status})');
							}
							else
							{
								trace('ERROR ${response.status} ${response.error})');
							}
							checkingServerData = false;
					}
			});
		}
		newRequest = request.clone();
		newRequest.send();
	}
	
	public static function slugify(Text:String):String
	{
		var r = ~/[^A-Za-z0-9-]+/g;
		return r.replace(Text, "-").toLowerCase();
	}
	
}
