package;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileCircle;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class Transition extends PlayState
{
	public static function init():Void
	{
		if (Reg._transitionInitialized == false)
		{
			Reg._transitionInitialized = true;
			
			//If this is the first time we've run the program, we initialize the TransitionData
			
			//When we set the default static transIn/transOut values, on construction all 
			//FlxTransitionableStates will use those values if their own transIn/transOut states are null
			FlxTransitionableState.defaultTransIn = new TransitionData();
			FlxTransitionableState.defaultTransOut = new TransitionData();
			
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;
			
			FlxTransitionableState.defaultTransIn.tileData = { asset:diamond, width:32, height:32 };
			FlxTransitionableState.defaultTransOut.tileData = { asset:diamond, width:32, height:32 };
			
			//Of course, this state has already been constructed, so we need to set a transOut value for it right now:
			//transOut = FlxTransitionableState.defaultTransOut;
		}
		
		matchUI(false);
	}
	
	public static function matchUI(matchData:Bool=true):Void
	{
		var in_duration:Float = 1;
		var in_type:String = "tiles";
		var in_tile:String = "diamond";
		var in_tile_text:String = "diamond";
		var in_color:FlxColor = FlxColor.BLACK;
		var in_dir:String = "nw";
		
		var out_duration:Float = 1;
		var out_type:String = "tiles";
		var out_tile:String = "diamond";
		var out_tile_text:String = "diamond";
		var out_color:FlxColor = FlxColor.BLACK;
		var out_dir:String = "se";
		
		FlxTransitionableState.defaultTransIn.color = in_color;
		FlxTransitionableState.defaultTransIn.type = cast in_type;
		setDirectionFromStr(in_dir, FlxTransitionableState.defaultTransIn.direction);
		FlxTransitionableState.defaultTransIn.duration = in_duration;
		FlxTransitionableState.defaultTransIn.tileData.asset = getDefaultAsset(in_tile);
		
		FlxTransitionableState.defaultTransOut.color = out_color;
		FlxTransitionableState.defaultTransOut.type = cast out_type;
		setDirectionFromStr(out_dir, FlxTransitionableState.defaultTransOut.direction);
		FlxTransitionableState.defaultTransOut.duration = 1;
		FlxTransitionableState.defaultTransOut.tileData.asset = getDefaultAsset(out_tile);
		
		//transIn = FlxTransitionableState.defaultTransIn;
		//transOut = FlxTransitionableState.defaultTransOut;
		
	}
	
	public static function getDefaultAssetStr(c:FlxGraphic):String
	{
		return switch (c.assetsClass)
		{
			case GraphicTransTileCircle: "circle";
			case GraphicTransTileSquare: "square";
			case GraphicTransTileDiamond, _: "diamond";
		}
	}
	
	public static function getDefaultAsset(str):FlxGraphic
	{
		var graphicClass:Class<Dynamic> = switch (str)
		{
			case "circle": GraphicTransTileCircle;
			case "square": GraphicTransTileSquare;
			case "diamond", _: GraphicTransTileDiamond;
		}
		
		var graphic:FlxGraphic = FlxGraphic.fromClass(cast graphicClass);
		graphic.persist = true;
		graphic.destroyOnNoUse = false;
		return graphic;
	}
			
	public static function setDirectionFromStr(str:String,p:FlxPoint=null):FlxPoint
	{
		if (p == null)
		{
			p = new FlxPoint();
		}
		switch (str)
		{
			case "n": p.set(0, -1);
			case "s": p.set(0, 1);
			case "w": p.set(-1, 0);
			case "e": p.set(1, 0);
			case "nw": p.set( -1, -1);
			case "ne": p.set(1, -1);
			case "sw":p.set( -1, 1);
			case "se":p.set(1, 1);
			default: p.set(0, 0);
		}
		return p;
	}
	
	public static function transition():Void
	{
		FlxG.switchState(new PlayState());
	}
	
}