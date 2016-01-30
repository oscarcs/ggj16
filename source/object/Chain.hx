package object;
import flixel.FlxSprite;

/**
 * ...
 * @author oscarcs
 */
class Chain extends FlxSprite
{
	private var game:Game;
	private var type:String;

	public function new(x:Float, y:Float, game:Game) 
	{
		super(x, y);
		this.game = game;
	}
	
	public function resolveType()
	{
		var UP:Bool = game.isChain(x, y - Game.TILE_HEIGHT);
		var DOWN:Bool = game.isChain(x, y + Game.TILE_HEIGHT);
		trace(UP, DOWN);
		
		if (UP && DOWN)
		{
			type = 'middle';
		}
		else if (UP)
		{
			type = 'bottom';
		}
		else if (DOWN)
		{
			type = 'top';
			y -= 3;
		}
		else
		{
			type = 'bottom';
		}
		
		var assetPath = 'assets/objects/chain/Chain_';
		switch(type)
		{
			case 'top':
				loadGraphic(assetPath + 'Top_Brown.png');
			case 'middle':
				loadGraphic(assetPath + 'Mid_Brown.png');
			case 'bottom':
				loadGraphic(assetPath + 'Bottom_Brown.png');
		}
	}
}