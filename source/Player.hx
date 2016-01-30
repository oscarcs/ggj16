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
	public var index:Int;
	public var jumpTimer:FlxTimer = null;
	public var canJump:Bool = true;
	public var canWallJump:Bool = true;
	public var jumpReleased:Bool = true;
	public var holding:Bool = false;
	public var startJumpSpd:Float = -150;
	public var jumpSpd:Float = -150;
	public var maxJumpSpd:Float = -200;
	
	public function new(game:Game, x:Int, y:Int, graphic:String, index:Int) 
	{
		super(x, y);
		loadGraphic(graphic, true, 32, 32);
		
		this.game = game;
		this.index = index;
		this.drag.x = 1200;
		this.acceleration.y = Game.GRAVITY;
		this.maxVelocity.set(120, 500);
		this.maxVelocity.x = 420;
		
		this.animation.add('idle', [8, 9], 2);
		this.animation.add('walk', [2, 3, 4, 5, 6, 7], 15);
		this.animation.add('jump', [0, 1], 15);
		
		//set hitboxes
		setSize(20, 32);
		offset.set(6, 0);
		
		game.add(this);
	}
	
	override public function update()
	{
		//check if finished
		if (game.level.ending != null)
		{
			if (FlxG.overlap(this, game.level.ending) && game.playersInOrder.indexOf(this) == -1)
			{
				game.playersInOrder.push(this);
				trace(game.playersInOrder[0].index);
			}
		}
		
		
		this.acceleration.x = 0;
		canWallJump = false;
		if (this.isTouching(FlxObject.FLOOR) && jumpReleased)
		{
			canJump = true;
		}
		
		if (!holding && game.control.isJustPressedHold(index) && FlxG.overlap(this, game.chains))
		{
			velocity.x = 0;
			velocity.y = 0;
			acceleration.x = 0;
			acceleration.y = 0;
			holding = true;
			
		}
		else if(!holding)
		{
			acceleration.y = Game.GRAVITY;
		}
		else 
		{
			canJump = true;
			if (game.control.isJustPressedHold(index))
				holding = false;
		}
		
		if (FlxG.overlap(this, game.spikes, game.killedBySpike))
		{
			//this.kill();
			//this.reset(game.lastCheckpoint.x, game.lastCheckpoint.y);
			this.setPosition(game.lastCheckpoint.x, game.lastCheckpoint.y);
		}
		
		if (!holding)
		{
			if (game.control.isLeft(index))
			{
				this.flipX = true;
				this.acceleration.x -= this.accFloor;
				if (this.isTouching(FlxObject.LEFT) && this.velocity.y > 0)
				{
					wallSlide();
				}
			}
			else if (game.control.isRight(index))
			{
				this.flipX = false;
				this.acceleration.x += this.accFloor;
				if (this.isTouching(FlxObject.RIGHT) && this.velocity.y > 0)
				{
					wallSlide();
				}
			}
		}
		
		
		if (game.control.isPressedJump(index) && canJump)
		{
			if (jumpSpd > maxJumpSpd)
				jumpSpd += (maxJumpSpd - startJumpSpd) / 10;
			this.velocity.y = this.jumpSpd;
			jumpReleased = false;
			if (jumpTimer == null)
				jumpTimer = new FlxTimer(0.3, OnJumpTimer);
			holding = false;
		}
		if (game.control.isJustPressedJump(index) && (canJump || canWallJump))
		{
			
			this.jumpSpd = this.startJumpSpd;
			this.velocity.y = this.jumpSpd;
			trace("A");
			if (this.isTouching(FlxObject.RIGHT)  && canWallJump)
			{
				trace("R");
				this.velocity.y = -320;
				this.velocity.x = -320;
			}
			else if (this.isTouching(FlxObject.LEFT)  && canWallJump)
			{
				trace("L");
				this.velocity.y = -320;
				this.velocity.x = 320;
			}
			this.y -= 1;
		}
		
		if (game.control.isJustReleasedJump(index))
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
		
		super.update();
		
	}
	
	public function wallSlide()
	{
		if(jumpReleased)
			canWallJump = true;
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