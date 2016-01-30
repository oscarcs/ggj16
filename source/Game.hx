package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.addons.display.FlxBackdrop;
#if !flash
import sys.net.Socket;
#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

import world.Level;

class Game extends FlxState
{
	public static var TILE_WIDTH:Int = 32;
	public static var TILE_HEIGHT:Int = 32;
	public static var GRAVITY:Int = 600;
	
	public var level:Level;
	public var player:Player;
	public var back:FlxBackdrop;
	public var mid:FlxBackdrop;
	public var fore:FlxBackdrop;
	public var fog:FlxBackdrop;
	#if !flash
	public var socket:Socket;
    public var clientThread:Thread;
	#end
	
	//objects and such
	public var chains:FlxGroup;
	
	override public function create():Void
	{
		super.create();
		FlxG.worldBounds.set(0, 0, 10000, 10000);
		
		//set up the backgrounds
		addBackgrounds();
		
		chains = new FlxGroup();
		
		level = new Level(this);
		level.loadSections([0, 1]);
		
		add(chains);
		
		player = new Player(this, 32, 32, "assets/player.png");
		
		
		fog = new FlxBackdrop("assets/bg/fog.png", 0, 0, true, false);
		add(fog);
		
		#if !flash
		socket = new sys.net.Socket();
		socket.connect(new sys.net.Host("10.30.0.71"), 8080);
		clientThread = Thread.create(getMsgs);
		clientThread.sendMessage(Thread.current());
		#end
	}

	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		#if !flash
		var clientData = Thread.readMessage(false);
		if(clientData != null)
			trace(clientData);
		#end
		fog.x --;
		
		super.update();
		FlxG.camera.follow(player, 1);
		
		for (i in 0...level.tilemaps.length)
		{
			FlxG.collide(player, level.tilemaps[i]);
		}
	}
	
	private function addBackgrounds()
	{
		back = new FlxBackdrop("assets/bg/back.png", 0.2, 0, true, false);
		mid = new FlxBackdrop("assets/bg/mid.png", 0.3, 0, true, false); 
		fore = new FlxBackdrop("assets/bg/fore.png", 0.75, 0, true, false);
		add(back);
		add(mid);
		add(fore);
	}
	
	#if !flash
	function getMsgs()
	{
		var main:Thread = Thread.readMessage(true);
		while (true)
		{
			trace("b");
			var clientData:String;
			clientData = socket.input.readLine();
			trace(clientData);
			if (clientData.length > 0)
			{
				main.sendMessage(clientData);
			}
		}
	}
	#end
}