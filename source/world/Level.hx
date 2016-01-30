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
			
			tilemap.setPosition(x, y);
			tilemaps.push(tilemap);

			bgTilemap.setPosition(x, y);
			bgTilemaps.push(bgTilemap);
			
			game.add(bgTilemap);
			game.add(tilemap);
			
			
			var width = tilemap.widthInTiles;
			#if flash
				width --;
			#end
			x = tilemap.x + (tilemapData.entry % (width)) * Game.TILE_WIDTH;
			y = tilemap.y + Std.int(tilemapData.entry / (width)) * Game.TILE_HEIGHT;
		}
	}
	
	public function loadMapString(index:Int)
	{
		
		var tilemapData:String = Assets.getText("assets/tilemaps/tm_" + index + ".txt");
		var entry:Int = 0;
		
		var ind:Int = 0;
		for (i in 0...tilemapData.length)
		{
			switch(tilemapData.charAt(i))
			{
				case 'X':
					entry = ind;
					tilemapData = tilemapData.substr(0, i) + '2' + tilemapData.substr(i + 1);
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
		return { string:tilemapData, entry:entry };
	}
	
}