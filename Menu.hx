package;
import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author oscarcs
 */
class Menu extends FlxState
{
	public static var SKIP_MENU:Bool = false;
	public var control:Control;
	
	override public function create():Void 
	{
		#if debug
		SKIP_MENU = true;
		#end
		
		super.create();
		
		control = new Control();
		add(control);
		
		if (SKIP_MENU)
		{
			//FlxG.switchState(new Game());
		}
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
}