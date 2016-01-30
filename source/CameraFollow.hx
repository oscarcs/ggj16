package;

import flixel.FlxG;
import flixel.FlxObject;
import object.Checkpoint;

/**
 * ...
 * @author oscarcs
 */
class CameraFollow extends FlxObject
{
	private var game:Game;
	
	public function new(game:Game) 
	{
		this.game = game;
		super(FlxG.width / 2, FlxG.height / 2, 1, 1);
	}
	
	override public function update()
	{
		super.update();
		
		var rightmost:Player = cast game.players.members[0];
		for (i in 0...game.players.members.length)
		{
			var player:Player = cast game.players.members[i];
			if (player.x > rightmost.x)
			{
				rightmost = player;
			}
		}
		
		setPosition(rightmost.x, rightmost.y - 100);
		
		for (i in 0...game.checkpoints.members.length)
		{
			var checkpoint:Checkpoint = cast game.checkpoints.members[i];
			if (rightmost.x > checkpoint.x)
			{
				checkpoint.light();
				game.lastCheckpoint = checkpoint;
			}
		}
	}
}