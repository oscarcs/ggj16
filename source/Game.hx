package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.addons.display.FlxBackdrop;
#if !flash
import sys.net.Socket;
#end
#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end 
import object.Chain;
import object.Spikes;

import world.Level;

class Game extends FlxState
{
	public static var TILE_WIDTH:Int = 32;
	public static var TILE_HEIGHT:Int = 32;
	public static var GRAVITY:Int = 1200;
	
	public var control:Control;
	public var level:Level;
	public var players:FlxGroup;
	public var red:Player;
	public var orange:Player;
	public var green:Player;
	public var yellow:Player;
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
	public var spikes:FlxGroup;
	public var ip = /*"192.168.1.77";//*/"10.30.0.52";
	public var levelArray:Array<Int>;
	
	override public function new(control:Control)
	{
		super();
		this.control = control;
	}
	
	override public function create():Void
	{
		super.create();
		FlxG.worldBounds.set(0, 0, 10000, 10000);
		
		
		add(control);
		
		//set up the backgrounds
		addBackgrounds();
		
		chains = new FlxGroup();
		spikes = new FlxGroup();
		
		level = new Level(this);
		levelArray = GetRandomLevel(3);
		trace(levelArray);
		level.loadSections(levelArray);
		
		resolveChains();
		resolveSpikes();
		add(chains);
		add(spikes);
		
		players = new FlxGroup();
		red = new Player(this, 32, 32, "assets/player/red.png", 0);
		orange = new Player(this, 64, 32, "assets/player/orange.png", 1);
		yellow = new Player(this, 96, 32, "assets/player/yellow.png", 2);
		green = new Player(this, 128, 32, "assets/player/green.png", 3);
		players.add(red);
		players.add(orange);
		players.add(yellow);
		players.add(green);
		
		
		fog = new FlxBackdrop("assets/bg/fog.png", 1, 0, true, false);
		add(fog);
		
		#if !flash
		socket = new sys.net.Socket();
		socket.connect(new sys.net.Host(ip), 8080);
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
		control.update();
		
		#if !flash
		var clientData = Thread.readMessage(false);
		if(clientData != null)
			trace(clientData);
		#end
		
		//scroll fog
		fog.x --;
		
		super.update();
		FlxG.camera.follow(red, 1);
		
		for (i in 0...level.tilemaps.length)
		{
			FlxG.collide(players, level.tilemaps[i]);
		}
	}
	
	public function resolveChains()
	{
		for (chain in chains.members)
		{
			var chain:Chain = cast chain;
			chain.resolveType();
		}
	}
	
	public function resolveSpikes()
	{
		for (spike in spikes.members)
		{
			var spike:Spikes = cast spike;
			spike.resolveType();
		}
	}
	
	public function isChain(x:Float, y:Float):Bool
	{
		
		for (chain in chains.members)
		{
			var chain:Chain = cast chain;
			if (chain.x == x && chain.y == y)
			{
				trace(chain.x, x, chain.y, y);
				return true;
			}
		}
		
		return false;
	}
	
	public function isSpikes(x:Float, y:Float):Bool
	{
		for (spike in spikes.members)
		{
			var spike:Spikes = cast spike;
			if (spike.x == x && spike.y == y)
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function killedBySpike(obj1:FlxObject, obj2:FlxObject)
	{
		if (Type.getClass(obj1) == Spikes) 
		{
			var spikes:Spikes = cast obj1;
			spikes.makeBloody();
		}
		else if (Type.getClass(obj2) == Spikes)
		{
			var spikes:Spikes = cast obj2;
			spikes.makeBloody();
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
	
	function GetRandomLevel(length:Int = -1):Array<Int>
	{
		var result:Array<Int> =  new Array<Int>();
		var actualLength = length;
		if (actualLength < 0)
			actualLength = FlxRandom.intRanged(10, 20);
			
		for (i in 0...actualLength)
		{
			result.push(FlxRandom.intRanged(0, 3));
		}
		return result;
	}
}