package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.FlxGraphic;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import openfl.system.System;
import openfl.text.Font;

/**
 * @author galoyo
 */

class Dialog extends FlxSubState
{	
	// used to loop through the dialogText array.
	private var next:Int = -1;
	private var ticks:Float = 0;
	var fastDialogText:FlxText;	
	var typeTheDialogText:FlxTypeText;	
	var screenBox:FlxSprite;
	
	// the soild box that is underneath the text.
	var dialogBox:FlxSprite;
	var dialogBoxYesNo:FlxSprite;
	var yesNoArrow:FlxSprite;
	var backgroundForFaces:FlxSprite;
	var facesImageDisplayIt:FlxSprite;
	var backgroundForIcon:FlxSprite;	
	var iconImageDisplayIt:FlxSprite;
	var dialogYesNoText:FlxText;
	
	public var _buttonsNavigation:ButtonsNavigation; // left, right, jump, etc, buttons at the bottom of the screen.
	
	private var _shouldTextBeAdvanced:Bool = false;
	
	public function new():Void
	{
		super();
		
		if (Reg._F1KeyUsedFromMenuState == false)
			Reg.state._playerAirRemainingTimer.active = false;
		
		_buttonsNavigation = new ButtonsNavigation();		
		add(_buttonsNavigation);
		
		screenBox = new FlxSprite(10, 10);
		if (Reg.exitGameMenu == false)
			screenBox.makeGraphic(FlxG.width, FlxG.height, 0x77000000);
		else screenBox.loadGraphic("assets/images/exit.jpg", true, 800, 600);
		
		screenBox.setPosition(0, 0); 
		screenBox.scrollFactor.set(0, 0);	
		add(screenBox);
		
		if (Reg.exitGameMenu == false)
		{
			// background behind the characters faces.
			backgroundForFaces = new FlxSprite(10, 10);
			backgroundForFaces.makeGraphic(140, 170, 0xFF000044);
			backgroundForFaces.setPosition(50, 350);
			backgroundForFaces.scrollFactor.set(0, 0);
			add(backgroundForFaces);
			
			// is a character talking?
			if (Reg.dialogCharacterTalk[0] != "")
			{
				facesImageDisplayIt = new FlxSprite(10, 10);
				facesImageDisplayIt.loadGraphic("assets/images/" + Reg.dialogCharacterTalk[0], false, 110, 110);
				facesImageDisplayIt.setPosition(67, 383);
				facesImageDisplayIt.scrollFactor.set(0, 0);	
				add(facesImageDisplayIt);
			}
			
			// the solid box that is underneath the text.
			if (Reg.dialogCharacterTalk[0] != "" )
			{
				dialogBox = new FlxSprite(10, 10);
				dialogBox.makeGraphic(FlxG.width - 250, 170, 0xFF000044);
				dialogBox.setPosition(210, 350);
				dialogBox.scrollFactor.set(0, 0);	
			}
			else
			{
				dialogBox = new FlxSprite(10, 10);
				dialogBox.makeGraphic(FlxG.width - 150, 170, 0xFF000044);
				dialogBox.setPosition(100, 350); 
				dialogBox.scrollFactor.set(0, 0);
			}
			add(dialogBox);			

			// display the icon that was picked up.
			if (Reg.dialogCharacterTalk[0] == "" && Reg.dialogIconFilename != "" && Reg.dialogIconFilename != "savePoint.png")
			{
				// the bar displayed underneath the icon image. bottom left corner.
				backgroundForIcon = new FlxSprite(10, 10);
				backgroundForIcon.makeGraphic(340, 60, 0xFF000044);
				backgroundForIcon.setPosition(100, 270); 
				backgroundForIcon.screenCenter(X);
				backgroundForIcon.scrollFactor.set(0, 0);			
				add(backgroundForIcon);
				
				iconImageDisplayIt = new FlxSprite(10, 10);
				iconImageDisplayIt.loadGraphic("assets/images/" + Reg.dialogIconFilename, true, Reg._tileSize, Reg._tileSize);
				iconImageDisplayIt.setPosition(67, 284);
				iconImageDisplayIt.screenCenter(X);
				iconImageDisplayIt.scrollFactor.set(0, 0);	
				add(iconImageDisplayIt);
			}
			
			// setup the text properties.
			if (Reg.dialogCharacterTalk[0] != "" )
			{
				typeTheDialogText = new FlxTypeText(100, 0, FlxG.width - 300, "", 15, true);	
				typeTheDialogText.eraseDelay = 0;
				typeTheDialogText.showCursor = true;
				typeTheDialogText.cursorBlinkSpeed = 1.0;
				typeTheDialogText.prefix = "";
				typeTheDialogText.autoErase = true;
				typeTheDialogText.waitTime = 2.0;
				typeTheDialogText.setTypingVariation(0.75, true);
				typeTheDialogText.color = 0xFFFFFFFF;
				typeTheDialogText.setPosition(230, 360); 
				typeTheDialogText.scrollFactor.set(0, 0);
				typeTheDialogText.cursorCharacter = "";	
			}
			else 
			{
				typeTheDialogText = new FlxTypeText(0, 0, FlxG.width - 160, "", 15, true);					
				typeTheDialogText.eraseDelay = 0;
				typeTheDialogText.showCursor = true;
				typeTheDialogText.cursorBlinkSpeed = 0;
				typeTheDialogText.prefix = "";
				typeTheDialogText.autoErase = true;
				typeTheDialogText.waitTime = 2.0;
				typeTheDialogText.setTypingVariation(0.75, true);
				typeTheDialogText.color = 0xFFFFFFFF;
				typeTheDialogText.setPosition(90, 360); 
				typeTheDialogText.scrollFactor.set(0, 0);
				typeTheDialogText.cursorCharacter = "";
			}
			add(typeTheDialogText);
			
			// the box that is underneath the text.
			dialogBoxYesNo = new FlxSprite(100, 100);
			dialogBoxYesNo.makeGraphic(250, 60, 0xFF440000);
			dialogBoxYesNo.setPosition(450, 270); 
			dialogBoxYesNo.scrollFactor.set(0, 0);
			dialogBoxYesNo.exists = false;		
			add(dialogBoxYesNo);
			
			// arrow used to select yes or no.
			yesNoArrow = new FlxSprite(10, 10);
			yesNoArrow.loadGraphic("assets/images/dialogYesNoArrow.png", false, Reg._tileSize, Reg._tileSize);
			yesNoArrow.setPosition(457, 283); 
			yesNoArrow.scrollFactor.set(0, 0);
			//yesNoArrow.exists = false;
			yesNoArrow.color = 0xFFFFFFFF;
			yesNoArrow.exists = false;
			
			FlxG.keys.reset; // if key is pressed then do not yet count it as a key press. 
			add(yesNoArrow);
			
			if (FlxG.keys.anyPressed(["A"])) {}; // trap key press.
			
			ticks = 0;
			nextText();	
		}
	}
	
	private function startText():Void
	{		
	
		typeTheDialogText.delay = 0.005;
		typeTheDialogText.start(0.002, false, false, ["DOWN"], completedCallback);
	}
	
	private function nextText():Void
	{	
		// used to loop through the dialogText array.
		next++;
		
		// is there a paragraph to be displayed.
		if (Reg.dialogIconText[next] != null && Reg.dialogIconText[next] != "@" )
		{
			// set the text folder. inside the text at the end of each paragraph begins a number. that number is stored as an array in Reg.dialogCharacterTalk. see the dialog commands when an object is picked up or a chat is started at playState.
			var i = Std.parseInt(Reg.dialogIconText[next].substr(Reg.dialogIconText[next].length - 1, 1));
			
			if (i != null)
			{
				facesImageDisplayIt.loadGraphic("assets/images/" + Reg.dialogCharacterTalk[i], true, 110, 110);
			
				typeTheDialogText.resetText(Reg.dialogIconText[next].substr(0, Reg.dialogIconText[next].length - 1));			
			}
			else 
			{
				typeTheDialogText.resetText(Reg.dialogIconText[next]);
			}
			
			startText();
		}  
			
		// if there is no paragraphs to display then close the dialog and return to playState.
		else 
		{
			Reg.state._playerAirRemainingTimer.active = true;
			Reg._ignoreIfMusicPlaying = false;
			close(); 
		}
	}		
	
	override public function update(elapsed:Float):Void 
	{				
		ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
		if (ticks > 15)
		{
		
			if (Reg.exitGameMenu == false)
			{
				// this action key is used to display the next paragraph.
				if (FlxG.keys.anyJustReleased(["Z"]) && Reg.displayDialogYesNo == false  
				|| Reg._mouseClickedButtonZ == true && Reg.displayDialogYesNo == false
				|| FlxG.keys.anyJustReleased(["X"]) && Reg.displayDialogYesNo == false  
				|| Reg._mouseClickedButtonX == true && Reg.displayDialogYesNo == false
				|| FlxG.keys.anyJustReleased(["C"]) && Reg.displayDialogYesNo == false  
				|| Reg._mouseClickedButtonC == true && Reg.displayDialogYesNo == false
				)
				{
					_shouldTextBeAdvanced = true;
					nextText();		
					_shouldTextBeAdvanced = false;
				}
				
				// these keys are used to navigate the arrow at the yes / no answers.
				if (FlxG.keys.anyPressed(["RIGHT"]) && Reg.displayDialogYesNo == true || Reg._mouseClickedButtonRight == true && Reg.displayDialogYesNo == true)
					yesNoArrow.setPosition(572, 283); 
					
				if (FlxG.keys.anyPressed(["LEFT"]) && Reg.displayDialogYesNo == true || Reg._mouseClickedButtonLeft == true && Reg.displayDialogYesNo == true)
					yesNoArrow.setPosition(457, 283); 
				
				// display the arrow key at either the yes or no answer.
				if (FlxG.keys.anyJustReleased(["Z"]) && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true && _shouldTextBeAdvanced == true 
				|| Reg._mouseClickedButtonZ == true && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true && _shouldTextBeAdvanced == true
				|| FlxG.keys.anyJustReleased(["X"]) && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true && _shouldTextBeAdvanced == true 
				|| Reg._mouseClickedButtonX == true && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true && _shouldTextBeAdvanced == true
				|| FlxG.keys.anyJustReleased(["C"]) && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true && _shouldTextBeAdvanced == true 
				|| Reg._mouseClickedButtonC == true && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true && _shouldTextBeAdvanced == true)
				{
					Reg._dialogYesNoWasAnswered = true;
					
					if (yesNoArrow.x == 457)
						Reg._dialogAnsweredYes = true;
					else Reg._dialogAnsweredYes = false;
					
					_shouldTextBeAdvanced = false;
					Reg._ignoreIfMusicPlaying = false;
					close();
				}
				
				if ( Reg._dialogFastTextEnabled == true) 
				{
					typeTheDialogText.skip();
				}
			}
			else
			{
				if (FlxG.keys.anyJustPressed(["F1"]))
				{
					#if FLX_NO_KEYBOARD
						#if android // android back button pressed. quit app.
						if (FlxG.android.getKey(27).justPressed) Sys.exit(0);
						#end
					#else
						System.exit(0);				
					#end
				}
					
				if (FlxG.keys.anyJustPressed(["F2"])) {Reg.resetRegVars(); FlxG.resetGame();}
				if (FlxG.keys.anyJustPressed(["F3"])) {Reg.exitGameMenu = false; Reg._ignoreIfMusicPlaying = false; close();}
			}
		}
		
		super.update(elapsed);
	}	
	
	public function dialogYesNo():Void
	{				
		
		if (Reg.displayDialogYesNo == true)
		{	
			dialogBoxYesNo.exists = true;
			
			dialogYesNoText = new FlxText(493, 280, 0, "Yes     No", 28, true);		
			dialogYesNoText.scrollFactor.set(0, 0);
			dialogYesNoText.color = 0xFF00FF00;
			add(dialogYesNoText);			
			
			yesNoArrow.exists = true;
		}
	}
	
	public function completedCallback():Void
	{			
		_shouldTextBeAdvanced = true;
		
		if (Reg.displayDialogYesNo == true)
			dialogYesNo();		
	}
}