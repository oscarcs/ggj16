package object;
import flixel.FlxSprite;

/**
 * ...
 * @author oscarcs
 */
class Spikes extends FlxSprite
{

	public function new(x:Int, y:Int) 
	{
		super(x, y, "assets/objects/spikes/SpikesUp.png");
	}
	
	public function makeBloody()
	{
		loadGraphic("assets/objects/spikes/SpikesUp_Blood.png");
	}
}