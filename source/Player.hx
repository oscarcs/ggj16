package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

/**
 * ...
 * @author oscarcs
 */
class Player extends FlxSprite
{
	public var accFactor = 2;
	public var game:Game;
	
	public function new(game:Game, x:Int, y:Int, graphic:String) 
	{
		super(x, y);
		loadGraphic(graphic, true, 32, 32);
		
		this.game = game;
		this.drag.x = 640;
		this.acceleration.y = Game.GRAVITY;
		this.maxVelocity.set(120, 500);
		this.maxVelocity.x = 420;
		
		this.animation.add('idle', [8, 9], 2);
		this.animation.add('walk', [2, 3, 4, 5, 6, 7], 15);
		this.animation.add('jump', [0, 1], 15);
		
		game.add(this);
	}
	
	override public function update()
	{
		this.acceleration.x = 0;
		
		if (FlxG.overlap(this, game.chains))
		{
			acceleration.y = 0;
		}
		else
		{
			acceleration.y = Game.GRAVITY;
		}
		
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			this.flipX = true;
			this.acceleration.x -= this.drag.x * accFactor;
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			this.flipX = false;
			this.acceleration.x += this.drag.x * accFactor;
		}
		if (FlxG.keys.anyJustPressed(["UP", "W"]) 
			&& this.isTouching(FlxObject.FLOOR))
		{
			this.y -= 1;
			this.velocity.y = -420;
		}
		
		// ANIMATION
		
		if (this.velocity.y != 0)
		{   
			this.animation.play("jump");
		}
		else if (this.velocity.x == 0)
		{
			this.animation.play("idle");
		}
		else
		{
			this.animation.play("walk");
		}
		
		//this.animation.play('idle');
		
				super.update();
		
	}
}