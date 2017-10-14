package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * @author galoyo
 */

class OverlayPipeChildClass extends FlxSprite 
{
	private var _startx:Float;
	private var _starty:Float;
	
	private var alignPlayerToPipeOnce:Bool = false;
	
	public function new(x:Float, y:Float, id:Int) 
	{
		super(x, y);
		
		_startx = x;
		_starty = y;
		
		ID = id;
	}
	
	override public function update(elapsed:Float):Void 
	{		
		if (isOnScreen()) 
		{
			// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
		InputControls.checkInput();
		
			FlxG.overlap(this, Reg.state.player, pipePlayer);
		}
		
		super.update(elapsed);
	}	
	
	/***********************
	 * player can move through the pipes using the arrow keys at a pipe junction.
	 */
	public function pipePlayer(w:FlxSprite, p:Player):Void 
	{		
		Reg._playersYLastOnTile = p.y; // no fall damage when exiting pipe from the bottom.
		Reg.state._ticksTrackerDown = 0; // no tracker when leaving pipes.
		Reg.state._ticksTrackerUp = 0;
		Reg._guildlineInUseTicks = 0; // no gulde lines displayed when leaving a pipe.
		
		if (p._setPlayerOffset == false) 
		{
			if (Reg._soundEnabled == true) FlxG.sound.play("pipeEnter", 1, false);	
		}
		p._setPlayerOffset = true;		
		
		//################### AUTO MOVEMENT THROUGH PIPES ###################
		// if the player is at a vertical pipe then align the player horizontally
		// and then move the player either up or down, depending on what direction
		// an arror key was pressed.
		if (ID == 5 || ID == 8 || ID == 14) // north-south moving pipes. 
		{
			p.x = x; // align the player to the pipe.
			if (Reg._lastArrowKeyPressed == "up")
			{
				p.velocity.y = -Reg._pipeVelocityY; // move the player upward.			
				Reg._lastArrowKeyPressed = "up";
			}
			
			if (Reg._lastArrowKeyPressed == "down")
			{
				p.velocity.y = Reg._pipeVelocityY;			
				Reg._lastArrowKeyPressed = "down";			
			}
			
			alignPlayerToPipeOnce = false;
		}
		
		// align the player vertically and then move the player through the horizontal pipe.
		else if (ID == 2 || ID == 3 || ID == 4) // east moving pipes. 
		{
			p.y = y; // align the player to the pipe.
			if(Reg._lastArrowKeyPressed == "right")
			{
				p.velocity.x = Reg._pipeVelocityX; // move the player right.			
				Reg._lastArrowKeyPressed = "right";
			}
			
			if (Reg._lastArrowKeyPressed == "left")
			{
				p.velocity.x = -Reg._pipeVelocityX; // move the player left.
				Reg._lastArrowKeyPressed = "left";
			}
			
			alignPlayerToPipeOnce = false;
		}
		
		//#################### END AUTO MOVEMENTS #####################	 	
		
		//##################### CHANGE DIRECTION ######################
		// at a pipe intersection that player will not moved. the game will wait until a key is pressed. once pressed, the direction the arrow key was pressed is saved so what when moving through a non-pipe intersection the player will move in that direction.
		if (InputControls.up.pressed && alignPlayerToPipeOnce == true)
		{
			// these are the junctions that require an arrow key to be pressed.
			if (ID == 1 || ID == 7 || ID == 12 || ID == 13) p.y = y - 32;
			alignPlayerToPipeOnce = false;
			Reg._lastArrowKeyPressed = "up";
			
			if (Reg._soundEnabled == true) FlxG.sound.play("pipeChangeDirection", 1, false);			
		}
		
		else if (InputControls.left.pressed && alignPlayerToPipeOnce == true)
		{
			if (ID == 1 || ID == 6 || ID == 7 || ID == 13) p.x = x - 32;		
			alignPlayerToPipeOnce = false;
			Reg._lastArrowKeyPressed = "left";
			
			if (Reg._soundEnabled == true) FlxG.sound.play("pipeChangeDirection", 1, false);	
		}
		
		else if (InputControls.down.pressed && alignPlayerToPipeOnce == true)
		{
			if (ID == 1 || ID == 6 || ID == 7 || ID == 12) p.y = y + 32;
			alignPlayerToPipeOnce = false;
			Reg._lastArrowKeyPressed = "down";
			
			if (Reg._soundEnabled == true) FlxG.sound.play("pipeChangeDirection", 1, false);	
		}
		
		else if (InputControls.right.pressed && alignPlayerToPipeOnce == true)
		{
			if (ID == 1 || ID == 6 || ID == 12 || ID == 13) p.x = x + 32;
			alignPlayerToPipeOnce = false;
			Reg._lastArrowKeyPressed = "right";
			
			if (Reg._soundEnabled == true) FlxG.sound.play("pipeChangeDirection", 1, false);	
		}	
		//##################### END CHANGE DIRECTION #######################
		
		//############# ALIGN PIPES WITH NO AUTO MOVEMENT #############
		// the player is aligned to a pipe when the player is underneath any of these pipes.
		else if (ID == 1  || ID == 6 || ID == 7 || ID == 9 || ID == 10 || ID == 12  || ID == 13 || ID == 15 || ID == 16) 
		{			
			// the player was moved to these ids by velocity. so we need to stop that player.
			p.velocity.x = 0; p.velocity.y = 0;
			p.acceleration.x = p.acceleration.y = 0;
			p.drag.x = 50000;
			p.drag.y = 50000;
			
			// align the player to the pipe that requires an arror key press. 
			p.x = x + 2;			
			//xif(isTouching(FlxObject.FLOOR)) // align the player but not under these conditions.
				p.y = y + 2;
			
			// if this value if true then the game can now accept arrow key presses.
			alignPlayerToPipeOnce = true;			

		}		
		
		//###################### END ALIGNMENT ########################	
		
		//################ MOVING THROUGH JUNCTION ####################
		// in this section, the player is moving through a pipe junction. automatically set the direction of the arrow and set the slignPlayerToPipeOnce var to false, so that when touching an intersection that the player will stop.
		
		if (ID == 9 && Reg._lastArrowKeyPressed == "left" || ID == 9 && Reg._lastArrowKeyPressed == "down") 
		{
			p.y = y + 32; 
			alignPlayerToPipeOnce = false; 
			Reg._lastArrowKeyPressed = "down"; 			
		}
		else if (ID == 9 && Reg._lastArrowKeyPressed == "up" || ID == 9 && Reg._lastArrowKeyPressed == "right") 
		{
			p.x = x + 32; 
			alignPlayerToPipeOnce = false; 
			Reg._lastArrowKeyPressed = "right"; 
		}
			
		else if (ID == 15 && Reg._lastArrowKeyPressed == "down" || ID == 15 && Reg._lastArrowKeyPressed == "right") 
		{
			p.x = x + 32; 
			alignPlayerToPipeOnce = false; 
			Reg._lastArrowKeyPressed = "right"; 			
		}
		else if (ID == 15 && Reg._lastArrowKeyPressed == "left" || ID == 15 && Reg._lastArrowKeyPressed == "up") 
		{
			p.y = y - 32; 
			alignPlayerToPipeOnce = false; 
			Reg._lastArrowKeyPressed = "up";			
		}
		
		else if (ID == 10 && Reg._lastArrowKeyPressed == "right" || ID == 10 && Reg._lastArrowKeyPressed == "down") 
		{
			p.y = y + 32; 
			alignPlayerToPipeOnce = false; 
			Reg._lastArrowKeyPressed = "down";			
		}
		else if (ID == 10 && Reg._lastArrowKeyPressed == "up" || ID == 10 && Reg._lastArrowKeyPressed == "left") 
		{
			p.x = x - 32;
			alignPlayerToPipeOnce = false;
			Reg._lastArrowKeyPressed = "left";
		}
		
		else if (ID == 16 && Reg._lastArrowKeyPressed == "down" || ID == 16 && Reg._lastArrowKeyPressed == "left") 
		{
			p.x = x - 32; 
			alignPlayerToPipeOnce = false;
			Reg._lastArrowKeyPressed = "left";			
		}
		else if (ID == 16 && Reg._lastArrowKeyPressed == "right" || ID == 16 && Reg._lastArrowKeyPressed == "up") 
		{
			p.y = y - 32; 
			alignPlayerToPipeOnce = false; 
			Reg._lastArrowKeyPressed = "up"; 
			
		}
	
	//################## END MOVING THROUGH JUNCTION ####################	
		
		
	}
}