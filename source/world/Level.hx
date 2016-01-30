package world;
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
	
	public function new(game:Game) 
	{
		this.game = game;
	}
	
	public function loadSections(sections:Array<Int>)
	{
		for (i in 0...sections.length)
		{
			var tilemap = new FlxTilemap();
			var tilemapData:String = Assets.getText("assets/tilemaps/tm_" + sections[i] + ".txt");
			tilemap.loadMap(tilemapData, "assets/tiles.png", Game.TILE_WIDTH, Game.TILE_HEIGHT, 0);
			tilemap.setPosition(i * tilemap.width, 0);
			tilemaps.push(tilemap);
			game.add(tilemap);
		}
	}
	
}