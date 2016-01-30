package world;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import openfl.Assets;

/**
 * ...
 * @author oscarcs
 */
class Level
{
	public var game:Game;
	public var tilemaps:Array<FlxTilemap> = [];
	public var bgTilemaps:Array<FlxTilemap> = [];
	
	public function new(game:Game) 
	{
		this.game = game;
	}
	
	public function loadSections(sections:Array<Int>)
	{
		var x = 0.;
		var y = 0.;
		for (i in 0...sections.length)
		{
			var tilemap = new FlxTilemap();
			var bgTilemap = new FlxTilemap();
			
			var tilemapData = loadMapString(sections[i]);
			tilemap.loadMap(tilemapData.string, "assets/tileset.png", Game.TILE_WIDTH, Game.TILE_HEIGHT, FlxTilemap.AUTO);
			
			var bgTilemapData = Assets.getText("assets/tilemaps/bg_" + sections[i] + ".txt");
			bgTilemap.loadMap(bgTilemapData, "assets/bgtileset.png", Game.TILE_WIDTH, Game.TILE_HEIGHT, FlxTilemap.AUTO);
			
			var width:Int = tilemap.widthInTiles;
			#if flash
				width --;
			#end
			
			var enterx = (Std.int(tilemapData.entry % width) * Game.TILE_WIDTH);
			var entery = (Std.int(tilemapData.entry / width) * Game.TILE_HEIGHT);
			
			tilemap.setPosition(x - enterx, y - entery);
			bgTilemap.setPosition(x - enterx, y - entery);
			
			
			x = tilemap.x + (Std.int(tilemapData.exit % width) * Game.TILE_WIDTH);
			y = tilemap.y + (Std.int(tilemapData.exit / width) * Game.TILE_HEIGHT);
			
			trace(x, y, '|', enterx, entery);
			
			
			game.add(bgTilemap);
			game.add(tilemap);
			tilemaps.push(tilemap);
			bgTilemaps.push(bgTilemap);
		}
	}
	
	public function loadMapString(index:Int)
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
					tilemapData = tilemapData.substr(0, i) + '1' + tilemapData.substr(i + 1);
					ind++;
				case '<': //transition to previous room
					entry = ind;
					tilemapData = tilemapData.substr(0, i) + '1' + tilemapData.substr(i + 1);
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
	
}