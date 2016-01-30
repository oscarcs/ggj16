package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

/**
 * ...
 * @author oscarcs
 */
class Menu extends FlxState
{
	public static var SKIP_MENU:Bool = false;
	public var control:Control;
	
	//text and menu
	private var selector:FlxSprite;
	private var selectIndex:Int = 0;
	private var selectorDelay:Int = 0;
	private var titleText:FlxText;
	private var creditText:FlxText;
	private var numControllers:Int;
	private var controllerTexts:Array<FlxText> = [];
	
	override public function create():Void 
	{
		#if debug
		//SKIP_MENU = true;
		#end
		
		super.create();
		
		control = new Control();
		add(control);
		
		//set up menu shit
		selector = new FlxSprite(0, 0, "assets/objects/chain.png");
		titleText = new FlxText(0, 0, 0, 'A Cool Game', 20);
		titleText.color = FlxColor.WHITE;
		creditText = new FlxText(0, 0, 0, 'A game by fhdhdhshahahh', 16);
		creditText.color = titleText.color;
		for (i in 0...4)
		{
			var num = i + 1;
			var controllerText = new FlxText(FlxG.width * 0.75, (FlxG.height * 0.7) + (25 * i), 0, num + ' Player', 16);
			controllerText.color = titleText.color;
			add(controllerText);
			controllerTexts.push(controllerText);
		}
		
		//arrange menu shit
		titleText.setPosition((FlxG.width - titleText.width) / 2, FlxG.height * 0.2);
		creditText.setPosition((FlxG.width - creditText.width) / 2, FlxG.height * 0.3);
		add(titleText);
		add(creditText);
		add(selector);
		
		if (SKIP_MENU)
		{
			FlxG.switchState(new Game(control, 1));
		}
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (control.gamepads.length != numControllers)
		{
			numControllers = control.gamepads.length;
			for (i in 0...numControllers)
			{
				controllerTexts[i].color = titleText.color;
			}
			for (i in numControllers...4)
			{
				controllerTexts[i].color = FlxColor.GRAY;
			}
		}
		
		selectorDelay ++;
		if (selectorDelay > 15) selectorDelay = 15;
		
		if (selectorDelay == 15 && 
			(control.isUp(0) || control.isUp(1) || control.isUp(2) || control.isUp(3)))
		{
			selectorDelay = 0;
			selectIndex --;
		}
		else if(selectorDelay == 15 && 
			(control.isDown(0) || control.isDown(1) || control.isDown(2) || control.isDown(3)))
		{
			selectorDelay = 0;
			selectIndex ++;
		}
		
		if (selectIndex >= numControllers)
		{
			selectIndex = 0;
		}
		else if (selectIndex < 0)
		{
			selectIndex = numControllers - 1;
		}
		selector.setPosition(FlxG.width * 0.75 - (selector.width + 20), (FlxG.height * 0.7) + (selectIndex * 25));
		
		if (control.isSelect(0) || control.isSelect(1) || control.isSelect(2) || control.isSelect(3))
		{
			FlxG.switchState(new Game(control, selectIndex + 1));
		}
		

	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
}