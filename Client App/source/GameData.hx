package;
import sys.FileSystem;
import openfl.display.BitmapData;

class GameData
{

	public var name:String;
	public var author:String;
	public var osList:Array<String>;
	public var tags:Array<String>;
	public var git:String;
	public var executable:String;
	public var version:String;
	public var execPath(get, null):String;
	
	public function new(name:String, author:String, osList:String, tags:String, git:String, executable:String, version:String) 
	{
		this.name = name;
		this.author = author;
		this.osList = osList.split(",");
		this.tags = tags.split(",");
		this.git = git;
		this.executable = executable;
		this.version = version;
	}
	
	public function exists():Bool
	{
		return FileSystem.exists(execPath);
	}
	
	private function get_execPath():String
	{
		return StringTools.replace(Reg.settings[Reg.SETTING_GAMEPATH] + git + "/" + executable, "/", "\\");
	}
	
	public function getLogo():BitmapData
	{
		return BitmapData.fromFile(StringTools.replace(Reg.settings[Reg.SETTING_GAMEPATH] + git + "/" + "logo.png", "/", "\\"));
	}
	
}