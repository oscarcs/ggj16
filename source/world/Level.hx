package world;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import object.Chain;
import object.Spikes;
import openfl.Assets;

typedef QueuedObject = {
	var xt:Int;
	var yt:Int;
	var type:String;
}

/**
 * ...
 * @author oscarcs
 */
class Level
{
	public var game:Game;
	
	public var tilemaps:Array<FlxTilemap> = [];
	public var bgTilemaps:Array<FlxTilemap> = [];
	public var ending:FlxTilemap;
	
	private var objectQueue:Array<QueuedObject> = [];
	
	public function new(game:Game) 
	{
		this.game = game;
	}
	
	public function loadSections(sections:Array<Int>)
	{
		var exitx = 0.;
		var exity = 0.;
		var enterx = 0.;
		var entery = 0.;
		var x = 0.;
		var y = 0.;
		for (i in 0...sections.length)
		{
			var tilemap = new FlxTilemap();
			var bgTilemap = new FlxTilemap();
			
			var tilemapData = loadMapString(sections[i], 16, 16, x, y);
			tilemap.loadMap(tilemapData.string, "assets/tileset.png", Game.TILE_WIDTH, Game.TILE_HEIGHT, FlxTilemap.AUTO);
			
			var bgTilemapData = Assets.getText("assets/tilemaps/bg_" + sections[i] + ".txt");
			bgTilemap.loadMap(bgTilemapData, "assets/bgtileset.png", Game.TILE_WIDTH, Game.TILE_HEIGHT, FlxTilemap.AUTO);
			
			var width:Int = 16;
			enterx = 0;
			entery = 0;
			if (i > 0)
			{
				enterx = (Std.int(tilemapData.entry % width) * Game.TILE_WIDTH);
				entery = (Std.int(tilemapData.entry / width) * Game.TILE_HEIGHT);
			}
			x = exitx - enterx;
			y = exity - entery;
			tilemap.setPosition(x, y);
			bgTilemap.setPosition(x, y);
			
			for (i in 0...objectQueue.length)
			{
				var cur = objectQueue[i];
				addObject(cur.xt, cur.yt, x, y, cur.type);
			}
			objectQueue = [];
			
			/*
			var width:Int = tilemap.widthInTiles;
			#if flash
				width --;
			#end
			*/
			

			
			exitx = tilemap.x + (Std.int(tilemapData.exit % width) * Game.TILE_WIDTH);
			exity = tilemap.y + (Std.int(tilemapData.exit / width) * Game.TILE_HEIGHT);
			
			game.add(bgTilemap);
			game.add(tilemap);
			tilemaps.push(tilemap);
			bgTilemaps.push(bgTilemap);
			
			
			//final room!
			if (i == sections.length - 1)
			{
				addEnding(tilemap);
			}
		}
	}
	
	public function loadMapString(index:Int, wt:Int, ht:Int, x:Float, y:Float)
	{
		
		var tilemapData:String = Assets.getText("assets/tilemaps/tm_" + index + ".txt");
		
		var entry:Int = 0;
		var exit:Int = 0;
		var ind:Int = 0;
		for (i in 0...tilemapData.length)
		{
			switch(tilemapData.charAt(i))
			{
				case '>': //transition to next room
					exit = ind;
					tilemapData = substituteData(tilemapData, i, '1');
					ind++;
				case '<': //transition to previous room
					entry = ind;
					tilemapData = substituteData(tilemapData, i, '1');
					ind++;
				case '|':
					tilemapData = substituteData(tilemapData, i, '0');
					queueObject(ind % wt, Std.int(ind / wt), 'chain');
					ind++;
				case '^':
					tilemapData = substituteData(tilemapData, i, '0');
					queueObject(ind % wt, Std.int(ind / wt), 'spike');
					ind++;
				default:
					if (tilemapData.charAt(i) != ' ' &&
						tilemapData.charAt(i) != ',' &&
						tilemapData.charAt(i) != '\n' &&
						tilemapData.charAt(i) != '\r')
					{
						ind++;
					}
			}
		}
		return { string:tilemapData, entry:entry, exit:exit };
	}
	
	private function substituteData(tilemapData:String, index:Int, replace:String):String
	{
		return tilemapData.substr(0, index) + replace + tilemapData.substr(index + 1);
	}
	
	private function addObject(xt:Int, yt:Int, xOffset:Float, yOffset:Float, type:String)
	{
		switch(type) {
			case 'chain':
				var type = 'middle';
				var x = xt * Game.TILE_WIDTH + xOffset;
				var y = yt * Game.TILE_HEIGHT + yOffset;

				game.chains.add(new Chain(x, y, game));
			case 'spike':
				var type = 'bottom';
				var x = xt * Game.TILE_WIDTH + xOffset;
				var y = yt * Game.TILE_HEIGHT + yOffset;

				game.spikes.add(new Spikes(x, y, game));
		}
	}
	
	private function queueObject(xt:Int, yt:Int, type:String)
	{
		objectQueue.push( { xt:xt, yt:yt, type:type} );
	}
	
	private function addEnding(room:FlxTilemap)
	{
		var data = [for (i in 0...(room.widthInTiles * room.heightInTiles)) 0];
		
		ending = new FlxTilemap();
		ending.heightInTiles = room.heightInTiles;
		ending.widthInTiles = room.widthInTiles;
		ending.loadMap(data, "assets/finishtileset.png", 32, 32, 0);
		ending.setPosition(room.x, room.y);
		
		for (y in 0...ending.heightInTiles)
		{
			ending.setTile(3, y, 1, true);
		}
		game.add(ending);
	}
}