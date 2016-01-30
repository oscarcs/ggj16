package object;
import flixel.FlxSprite;

/**
 * ...
 * @author oscarcs
 */
class Spikes extends FlxSprite
{

	public function new(x:Float, y:Float) 
	{
		super(x, y, "assets/objects/spikes/SpikesUp.png");
		//this.height = 16;
		//this.offset.set(0, 16);
	}
	
	public function makeBloody()
	{
		loadGraphic("assets/objects/spikes/SpikesUp_Blood.png");
	}
}