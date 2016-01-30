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

	public function new(game:Game, x:Int, y:Int, graphic:String) 
	{
		super(x, y);
		loadGraphic(graphic, true, 16, 16);
		
		this.drag.x = 640;
		this.acceleration.y = 600;
		this.maxVelocity.set(120, 500);
		
		this.animation.add('idle', [0]);
		
		game.add(this);
	}
	
	override public function update()
	{
		
		this.acceleration.x = 0;
		
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			this.flipX = true;
			this.acceleration.x -= this.drag.x;
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			this.flipX = false;
			this.acceleration.x += this.drag.x;
		}
		if (FlxG.keys.anyJustPressed(["UP", "W"]) && this.isTouching(FlxObject.FLOOR))
		{
			this.y -= 1;
			this.velocity.y = -300;
		}
		
		// ANIMATION
		/*
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
			this.animation.play("run");
		}
		*/
		this.animation.play('idle');
		
				super.update();
		
	}
}