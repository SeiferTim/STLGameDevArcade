package;

class GameData
{

	public var name(default, null):String;
	public var author(default, null):String;
	public var osList(default, null):Array<String>;
	public var tags(default, null):Array<String>;
	public var git(default, null):String;
	public var executable(default, null):String;
	
	
	public function new(name:String, author:String, osList:String, tags:String, git:String, executable:String) 
	{
		this.name = name;
		this.author = author;
		this.osList = osList.split(",");
		this.tags = tags.split(",");
		this.git = git;
		this.executable = executable;
	}
	
}