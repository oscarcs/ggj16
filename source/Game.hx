package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import world.Level;

class Game extends FlxState
{
	public static var TILE_WIDTH:Int = 32;
	public static var TILE_HEIGHT:Int = 32;
	
	public var level:Level;
	public var player:Player;
	
	override public function create():Void
	{
		super.create();
		
		level = new Level(this);
		level.loadSections([0, 1]);
		
		player = new Player(this, 32, 32, "assets/player.png");
	}

	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		super.update();
		
		for (i in 0...level.tilemaps.length)
		{
			FlxG.collide(player, level.tilemaps[i]);
		}
	}
}