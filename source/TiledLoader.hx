package;

import flixel.FlxG;
import flixel.tile.FlxTilemap;
import haxe.xml.Fast;
import haxe.xml.Parser;
import openfl.Assets;

class TiledLoader
{
	private var _level:String;
	private var _xml:Xml;
	private var _fast:Fast;

	public function new(level:String)
	{
		_level = level;
		_xml = Parser.parse(Assets.getText(level));
		_fast = new Fast(_xml.firstElement());

		var width = Std.parseInt(_fast.att.width);
		var height = Std.parseInt(_fast.att.height);
	}

	public function loadTilemap(path:String, width:Int, height:Int, layer:String):FlxTilemap
	{
		var tileMap:FlxTilemap = new FlxTilemap();

		var layerXml:Fast = null;
		for (_layerXml in _fast.nodes.layer)
			if(_layerXml.att.name==layer) layerXml = _layerXml;
		
		if (layerXml==null) throw ("No layer in "+_level+" named "+layer);

		var data:String = layerXml.node.data.innerData;

		tileMap.loadMap(data.substring(1,data.length-1),path,width,height);

		return tileMap;
	}

	public function loadEntities(entityLoadCallback:String->Xml->Void, entityLayer:String):Void
	{
		for (group in _fast.nodes.objectgroup)
			for (a in group.elements)
				entityLoadCallback(a.att.type,a.x);
	}
}