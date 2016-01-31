package world;
import flixel.FlxSprite;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import object.Chain;
import object.Checkpoint;
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
	private var throneDude:FlxSprite;
	
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
			
			var suffix:String = '' + sections[i];
			if (i == sections.length - 1)
			{
				suffix = "final";
			}
			var d = resolveDimensions(suffix);
			var width = d.width;
			var height = d.height;
			
			var tilemapData = loadMapString(sections[i], suffix, width, height, x, y);
			tilemap.loadMap(tilemapData.string, "assets/tileset.png", Game.TILE_WIDTH, Game.TILE_HEIGHT, FlxTilemap.AUTO);
			
			var bgTilemapData = Assets.getText("assets/tilemaps/bg_" + suffix + ".txt");
			bgTilemap.loadMap(bgTilemapData, "assets/bgtileset.png", Game.TILE_WIDTH, Game.TILE_HEIGHT, FlxTilemap.AUTO);
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
			
			//add thronedude
			if (i == sections.length - 1)
			{
				
				throneDude = new FlxSprite(x, y, 'assets/objects/throneDude.png');
				var tdx = (tilemap.width - throneDude.width) / 2;
				var tdy = tilemap.height - throneDude.height + 25;
				throneDude.setPosition(x + tdx, y + tdy);
				game.add(throneDude);
			}
			
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
	
	public function resolveDimensions(suffix:String)
	{
		var width = 0;
		var height = 0;
		switch(suffix)
		{
			case '0':
				width = 16;
				height = 16;
			case '1':
				width = 19;
				height = 16;
			case '2':
				width = 16;
				height = 16;
			case '3':
				width = 16;
				height = 16;
			case '4':
				width = 16;
				height = 16;
			case '5':
				width = 16;
				height = 16;
			case '6':
				width = 16;
				height = 16;
			case '7':
				width = 16;
				height = 28;
			case '8':
				width = 16;
				height = 16;
			case 'final':
				width = 22;
				height = 22;
		}
		return { width:width, height:height };
	}
	
	public function loadMapString(index:Int, suffix:String, wt:Int, ht:Int, x:Float, y:Float)
	{
		
		var tilemapData:String = Assets.getText("assets/tilemaps/tm_" + suffix + ".txt");
		
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
				case 'C':
					tilemapData = substituteData(tilemapData, i, '0');
					queueObject(ind % wt, Std.int(ind / wt), 'checkpoint');
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
			case 'checkpoint':
				var x = xt * Game.TILE_WIDTH + xOffset;
				var y = yt * Game.TILE_HEIGHT + yOffset;

				var checkpoint = new Checkpoint(x, y, game);
				if (game.lastCheckpoint == null) game.lastCheckpoint = checkpoint;
				trace(game.lastCheckpoint);
				game.checkpoints.add(checkpoint);
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