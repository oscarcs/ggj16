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
		trace(templist.length);
		
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
		
		trace(gamepads.length);
		
		templist = [];
	} 
	
	public function isPressedJump(player:Int):Bool
	{
		return false;
	}
}