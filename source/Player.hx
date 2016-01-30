package;

import flixel.util.FlxTimer;
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
	public var jumpTimer:FlxTimer = null;
	public var canJump:Bool = true;
	public var jumpReleased:Bool = true;
	
	public function new(game:Game, x:Int, y:Int, graphic:String) 
	{
		super(x, y);
		loadGraphic(graphic, true, 32, 32);
		
		this.game = game;
		this.drag.x = 1200;
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
		if (this.isTouching(FlxObject.FLOOR) && jumpReleased)
		{
			canJump = true;
		}
		
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
		if (FlxG.keys.anyPressed(["UP", "W"]) && canJump)
		{
			this.y -= 1;
			this.velocity.y = -120;
			jumpReleased = false;
			if (jumpTimer == null)
				jumpTimer = new FlxTimer(0.25, OnJumpTimer);
		}
		if (FlxG.keys.anyJustPressed(["UP", "W"]))
		{
			if (this.isTouching(FlxObject.RIGHT) && jumpReleased)
			{
				this.velocity.y = -320;
				this.velocity.x = -320;
			}
			else if (this.isTouching(FlxObject.LEFT) && jumpReleased)
			{
				this.velocity.y = -320;
				this.velocity.x = 320;
			}
		}
		
		if (FlxG.keys.anyJustReleased(["UP", "W"]))
		{
			canJump = false;
			jumpReleased = true;
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
	
	public function WallSlide()
	{
		
		if (this.velocity.y > 200)
			this.acceleration.y *= -1;
		else
			this.acceleration.y /= 10;
	}
	
	public function OnJumpTimer(timer:FlxTimer)
	{
		jumpTimer = null;
		canJump = false;
	}
}