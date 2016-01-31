package;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxInputText;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxTextField;
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
	private var bg:FlxSprite;
	private var selector:FlxSprite;
	private var selectIndex:Int = 0;
	private var selectorDelay:Int = 0;
	private var titleText:FlxText;
	private var creditText:FlxText;
	private var controllerText:FlxText;
	private var numControllers:Int;
	private var controllerTexts:Array<FlxText> = [];
	private var fog:FlxBackdrop;
	
	private var input:FlxInputText;
	
	private var xpc:Float = 0.64;
	private var ypc:Float = 0.43;
	
	override public function create():Void 
	{
		#if debug
		//SKIP_MENU = true;
		#end
		
		super.create();
		
		control = new Control();
		add(control);
		
		//set up menu shit
		bg = new FlxSprite(0, 0, 'assets/menu/bg.png');
		selector = new FlxSprite(0, 0, "assets/objects/chain.png");
		titleText = new FlxText(0, 0, 0, 'A Cool Game', 20);
		titleText.setFormat('assets/berryrotunda.ttf', 20);
		titleText.color = FlxColor.WHITE;
		creditText = new FlxText(0, 0, 0, 'A game by fhdhdhshahahh', 16);
		creditText.setFormat('assets/berryrotunda.ttf', 16);
		creditText.color = titleText.color;
		controllerText = new FlxText(0, 0, 0, 'Press X to join!', 16);
		controllerText.setFormat('assets/berryrotunda.ttf', 16);
		
		input = new FlxInputText(0, 0, 250, 'Enter IP Address', 16);
		input.height = 40;
		input.setFormat('assets/berryrotunda.ttf', 16);
		input.backgroundColor = FlxColor.TRANSPARENT;
		input.color = titleText.color;
		
		//arrange menu shit
		bg.setPosition(-((bg.width - FlxG.width) / 2), -((bg.height - FlxG.height) / 2));
		titleText.setPosition((FlxG.width - titleText.width) / 2, FlxG.height * 0.1);
		creditText.setPosition((FlxG.width - creditText.width) / 2, FlxG.height * 0.15);
		controllerText.setPosition(FlxG.width * xpc - 52, (FlxG.height * ypc) - 30);
		input.setPosition((FlxG.width - input.width) / 2, FlxG.height * 0.9);
		add(bg);
		add(titleText);
		add(creditText);
		add(controllerText);
		add(selector);
		add(input);
		
		for (i in 0...4)
		{
			var num = i + 1;
			var controllerText = new FlxText(FlxG.width * xpc, (FlxG.height * ypc) + (25 * i), 0, num + ' Player', 16);
			controllerText.setFormat('assets/berryrotunda.ttf', 16);
			controllerText.color = FlxColor.GRAY;
			add(controllerText);
			controllerTexts.push(controllerText);
		}
		
		fog = new FlxBackdrop("assets/bg/fog.png", 1, 0, true, false);
		add(fog);
		
		if (SKIP_MENU)
		{
			FlxG.switchState(new Game(control, 1, [0]));
		}
	}
	
	override public function update():Void 
	{
		fog.x --;
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
		selector.setPosition(FlxG.width * xpc - (selector.width + 20), (FlxG.height * ypc) + (selectIndex * 25));
		
		if (control.isSelect(0) || control.isSelect(1) || control.isSelect(2) || control.isSelect(3))
		{
			var cpi = [for (i in 0...(selectIndex + 1)) i];
			FlxG.switchState(new Game(control, selectIndex + 1, cpi));
		}
		

	}
	
	override public function destroy():Void 
	{
		super.destroy();
	}
	
}