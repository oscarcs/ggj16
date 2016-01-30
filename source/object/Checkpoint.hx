package object;
import flixel.FlxSprite;

/**
 * ...
 * @author oscarcs
 */
class Checkpoint extends FlxSprite
{
	private var game:Game;
	private var type:String;
	
	public function new(x:Float, y:Float, game:Game) 
	{
		super(x, y);
		this.game = game;
		loadGraphic('assets/objects/checkpoint/Checkpoint_Unlit.png');
	}
	
	public function light()
	{
		loadGraphic('assets/objects/checkpoint/Checkpoint_Lit.png');
	}
	
}