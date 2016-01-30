package object;
import flixel.FlxSprite;

/**
 * ...
 * @author oscarcs
 */
class Spikes extends FlxSprite
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
		if (game.isSpikes(x, y))
		{
			
		}
		type = 'up';
		
		var assetPath = 'assets/objects/spikes/Spikes';
		switch(type)
		{
			case 'up':
				loadGraphic(assetPath + 'Up.png');
			case 'down':
				loadGraphic(assetPath + 'Down.png');
			case 'left':
				loadGraphic(assetPath + 'Left.png');
			case 'right':
				loadGraphic(assetPath + 'Right.png');
				
		}
	}
	
	public function makeBloody()
	{
		var assetPath = 'assets/objects/spikes/Spikes';
		switch(type)
		{
			case 'up':
				loadGraphic(assetPath + 'Up_Blood.png');
			case 'down':
				loadGraphic(assetPath + 'Down_Blood.png');
			case 'left':
				loadGraphic(assetPath + 'Left_Blood.png');
			case 'right':
				loadGraphic(assetPath + 'Right_Blood.png');
				
		}
	}
}