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
	public var game:Game;
	public var accFloor = 800;
	
	public function new(game:Game, x:Int, y:Int, graphic:String) 
	{
		super(x, y);
		loadGraphic(graphic, true, 16, 16);
		
		this.game = game;
		this.drag.x = 1200;
		this.acceleration.y = Game.GRAVITY;
		this.maxVelocity.set(120, 500);
		this.maxVelocity.x = 420;
		this.animation.add('idle', [0]);
		
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
			this.acceleration.x -= this.accFloor;
			if (this.isTouching(FlxObject.LEFT) && this.velocity.y > 0)
				WallSlide();
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			this.flipX = false;
			this.acceleration.x += this.accFloor;
			if (this.isTouching(FlxObject.RIGHT) && this.velocity.y > 0)
				WallSlide();
		}
		if (FlxG.keys.anyJustPressed(["UP", "W"]) 
			&& (this.isTouching(FlxObject.FLOOR)
				|| this.isTouching(FlxObject.RIGHT)
				|| this.isTouching(FlxObject.LEFT)))
		{
			this.y -= 1;
			this.velocity.y = -420;
			if (this.isTouching(FlxObject.RIGHT))
			{
				this.velocity.x = -320;
				this.velocity.y *= 0.8;
			}
			else if (this.isTouching(FlxObject.LEFT))
			{
				this.velocity.x = 320;
				this.velocity.y *= 0.8;
			}
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
	
	public function WallSlide()
	{
		
		if (this.velocity.y > 200)
			this.acceleration.y *= -1;
		else
			this.acceleration.y /= 10;
	}
}