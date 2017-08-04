package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;

/**
 * @author galoyo
 */

class ObjectSpikeTrap extends FlxSprite
{
	private var _startx:Float;
	private var _starty:Float;
	
	public function new(x:Float, y:Float, id:Int) 
	{		
		super(x, y);

		_startx = x;
		_starty = y;
		
		if (id == 1)
			loadGraphic("assets/images/objectSpikeTrap1.png", false, Reg._tileSize, 15);
			
		if (id == 2)
			loadGraphic("assets/images/objectSpikeTrap2.png", false, 15, Reg._tileSize);	

		if (id == 3)
			loadGraphic("assets/images/objectSpikeTrap3.png", false, Reg._tileSize, 15);

		if (id == 4)
			loadGraphic("assets/images/objectSpikeTrap4.png", false, 15, Reg._tileSize);	
		
		if (id >= 5 && id <= 8)
			loadGraphic("assets/images/objectSpikeTrap"+id+".png", false, Reg._tileSize, Reg._tileSize);
		
		if (id == 9)
			loadGraphic("assets/images/objectSpikeTrap9.png", false, Reg._tileSize, 8);
			
		immovable = false;
		
	}
	
	override public function update(elapsed:Float):Void 
	{		
		reset(_startx, _starty);
		
		FlxG.collide(this, Reg.state.player, playerCollide);			
		FlxG.collide(this, Reg.state.enemies, mobCollide);	
		
		/*if ( FlxG.collide(this, Reg.state.player) && FlxG.collide(this, Reg.state.player)
		FlxG.collide(this, Reg.state.player, playerCollide);
		
		if( FlxG.collide(this, Reg.state.enemies) && FlxG.collide(this, Reg.state.enemies)
		FlxG.collide(this, Reg.state.enemies, mobCollide);	
		*/
		super.update(elapsed);
	}
	
	private function playerCollide(t:FlxSprite, p:Player):Void 
	{
		// determine if player can take a hit.
		if (FlxSpriteUtil.isFlickering(p) == false)
			p.hurt(5);
		
		reset(_startx, _starty);
	}
	
	private function mobCollide(t:FlxSprite, e:FlxSprite):Void 
	{
		if (FlxSpriteUtil.isFlickering(e) == false)
			e.hurt(5);
			
		reset(_startx, _starty);
	}
}