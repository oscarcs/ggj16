package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;

/**
 * ...
 * @author oscarcs
 */
class Control extends FlxBasic
{
	public var gamepads:Array<FlxGamepad> = [];
	
	public function new()
	{
		super();

	}
	
	override public function update():Void 
	{
		super.update();
		
		var templist = FlxG.gamepads.getActiveGamepads();
		
		for (i in 0...templist.length)
		{
			var exists:Bool = false;
			for (j in 0...gamepads.length)
			{
				if (templist[i].id == gamepads[j].id)
				{
					exists = true;
				}
			}
			if (!exists) gamepads.push(templist[i]);
		}
		
		templist = [];
	} 
	
	public function isPressedJump(player:Int):Bool
	{
		if (gamepads[player] != null)
		{
			var gamepad:FlxGamepad = gamepads[player];
			if(gamepad.anyPressed([XboxButtonID.A]))
			{
				return true;
			}
		}
		else
		{
			if (FlxG.keys.anyPressed(["UP", "W"]))
			{
				return true;
			}
		}
		return false;
	}
	
	public function isJustPressedJump(player:Int):Bool
	{
		if (gamepads[player] != null)
		{
			var gamepad:FlxGamepad = gamepads[player];
			if(gamepad.anyJustPressed([XboxButtonID.A]))
			{
				return true;
			}
		}
		else
		{
			if (FlxG.keys.anyJustPressed(["UP", "W"]))
			{
				return true;
			}
		}
		return false;
	}
	
	public function isJustReleasedJump(player:Int):Bool
	{
		if (gamepads[player] != null)
		{
			var gamepad:FlxGamepad = gamepads[player];
			if(gamepad.anyJustReleased([XboxButtonID.A]))
			{
				return true;
			}
		}
		else
		{
			if (FlxG.keys.anyJustReleased(["UP", "W"]))
			{
				return true;
			}
		}
		return false;
	}
	
	public function isRight(player:Int):Bool
	{
		var gamepad = gamepads[player];
		if (gamepad != null)
		{
			if (gamepad.getXAxis(XboxButtonID.LEFT_ANALOGUE_X) > 0)
			{
				return true;
			}
		}
		else
		{
			if (FlxG.keys.anyJustPressed(["RIGHT", "D"]))
			{
				return true;
			}
		}
		return false;
	}
	
	public function isLeft(player:Int):Bool
	{
		var gamepad = gamepads[player];
		if (gamepad != null)
		{
			if (gamepad.getXAxis(XboxButtonID.LEFT_ANALOGUE_X) < 0)
			{
				return true;
			}
		}
		else
		{
			if (FlxG.keys.anyJustPressed(["LEFT", "A"]))
			{
				return true;
			}
		}
		return false;
	}
}