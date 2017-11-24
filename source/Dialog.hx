package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.system.System;
import openfl.text.Font;

#if !MOBILE
	import flixel.input.keyboard.FlxKey;
#end

/**
 * @author galoyo
 */

class Dialog extends FlxSubState
{	
	//##################################################################
	//################ These values must NOT be changed. ###############
	//##################################################################
	
	/*******************************************************************************************************
	 * Used to loop through the dialogIconText array.
	 */
	private var next:Int = -1;
	
	/*******************************************************************************************************
	 * This var gives the user a chance to read a dialog text even when the user clicks the action key at the beginning of that text being displayed. This var is used to ignore a key press at the beginning of a dialog text being displayed.
	 */
	private var ticks:Float = 0;

	/*******************************************************************************************************
	 * This is the var used to display the dialog text. If Reg._dialogFastTextEnabled equals false then the text will be typed one letter at a time but quickly. True, then one page at a time will be displayed simultaneously.
	 */ 
	private var typeTheDialogText:FlxTypeText;	
	
	/*******************************************************************************************************
	 * The background of this dialog's subState.
	 */
	private var background:FlxSprite;
	
	/*******************************************************************************************************
	 * This sprite is the background for a dialog text.
	 */ 
	private var dialogBox:FlxSprite;
	
	/*******************************************************************************************************
	 * This as a rectangular box displayed underneath of the text "YES" and "NO" text. This is used only for  decoration.
	 */
	private var dialogBoxYesNo:FlxSprite;
	
	/*******************************************************************************************************
	 * The image that displays an arrow beside the YES / NO text. Clicking the left or right arrow key / button will change the arrow to point at either the YES or NO text.
	 */
	private var yesNoArrow:FlxSprite;
	
	/*******************************************************************************************************
	 * Background behind the character's face. For example, when the doctor is talking then the doctor's face will be displayed in front of this sprite. This is used only for  decoration.
	 */
	private var backgroundForFaces:FlxSprite;
	
	/*******************************************************************************************************
	 * The current face of the mob talking at the dialog.
	 */
	private var CurrentFaceToDisplay:FlxSprite;
	
	/*******************************************************************************************************
	 * This is the background art that is displayed underneath the item that the player had just picked up.
	 */
	private var backgroundForIcon:FlxSprite;	
	
	/*******************************************************************************************************
	 * This item displayed at this dialog screen is the exact item that the player had picked up.
	 */
	private var iconImage:FlxSprite;
	
	/*******************************************************************************************************
	 * This is the "YES / NO" text displayed at this dialog when desktop is used to play this game. When mobile phones are used to play this game then the YES button and NO button will replace this text.
	 */
	private var dialogYesNoText:FlxText;
	
	// BUTTONS WHEN USING MOBILE PHONES.####################################################################
	// When using desktop, Z, X or C will display the next dialog and the arrow key will be used to select the YES or NO answer to the question to the dialog text. When using mobile phones, the OK button will be used to display the next dialog and the YES and NO buttons will be used to answer the question to the dialog text.
	
	/*******************************************************************************************************
	 * USed to display the next dialog.
	 */
	private var buttonOK:Button;
	
	/*******************************************************************************************************
	 * Used to answer "YES" to a dialog question.
	 */
	private var buttonYes:Button;
	
	/*******************************************************************************************************
	 * Used to answer "NO" to a dialog question.
	 */
	private var buttonNo:Button;
	
	//######################################################################################################
	
	/*******************************************************************************************************
	 * This is the Exit button at the "Exit game menu". When playing the game, the "Exit game menu" can be accessed by pressing the M key.
	 */
	private var buttonExit:Button;
	
	/*******************************************************************************************************
	 * This is the Title button at the Exit game menu".
	 */
	private var buttonTitle:Button;
	
	/*******************************************************************************************************
	 * This is the Resume button at the Exit game menu".
	 */
	private var buttonResume:Button;
	
	/*******************************************************************************************************
	 * Buttons displayed at the bottom of the screen. The images of those buttons are the left, up, down, right arrows, and the big letters of Z, X, C, I.
	 */
	public var _buttonsNavigation:ButtonsNavigation;
	
	public function new():Void
	{
		super();		
		
		Reg.state._playerAirRemainingTimer.active = false;
		
		_buttonsNavigation = new ButtonsNavigation();		
		add(_buttonsNavigation);
		
		background = new FlxSprite(0, 0);
		if (Reg.exitGameMenu == false) background.makeGraphic(FlxG.width, FlxG.height, 0x77000000);	
		else {Reg.playTwinkle(); background.makeGraphic(FlxG.width, FlxG.height, 0xCC000000); }	
		background.scrollFactor.set(0, 0);	
		add(background);
		
		if (Reg.exitGameMenu == false)
		{
			// Background behind the character's face. For example, when the doctor is talking then the doctor's face will be displayed in front of this sprite. This is used only for  decoration.
			backgroundForFaces = new FlxSprite(10, 10);
			backgroundForFaces.makeGraphic(140, 170, 0xFF000044);
			backgroundForFaces.setPosition(50, 350);
			backgroundForFaces.scrollFactor.set(0, 0);
			add(backgroundForFaces);
			
			// is a character talking?
			if (Reg.dialogCharacterTalk[0] != "")
			{
				CurrentFaceToDisplay = new FlxSprite(10, 10);
				CurrentFaceToDisplay.loadGraphic("assets/images/" + Reg.dialogCharacterTalk[0], false, 110, 110);
				CurrentFaceToDisplay.setPosition(67, 383);
				CurrentFaceToDisplay.scrollFactor.set(0, 0);	
				add(CurrentFaceToDisplay);
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
				// This is the background art that is displayed underneath the item that the player had just picked up.
				backgroundForIcon = new FlxSprite(10, 10);
				backgroundForIcon.makeGraphic(340, 60, 0xFF000044);
				backgroundForIcon.setPosition(100, 270); 
				backgroundForIcon.screenCenter(X);
				backgroundForIcon.scrollFactor.set(0, 0);			
				add(backgroundForIcon);
				
				iconImage = new FlxSprite(10, 10);
				iconImage.loadGraphic("assets/images/" + Reg.dialogIconFilename, true, Reg._tileSize, Reg._tileSize);
				iconImage.setPosition(67, 284);
				iconImage.screenCenter(X);
				iconImage.scrollFactor.set(0, 0);	
				add(iconImage);
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
			
			#if !FLX_NO_KEYBOARD
				FlxG.keys.reset(); // if key is pressed then do not yet count it as a key press. 
			#end
			
			add(yesNoArrow);
			
			//---------------------- buttons for mobile. 
			// When using desktop, Z, X or C will display the next dialog and the arrow key will be used to select the YES or NO answer to the question to the dialog text. When using mobile phones, the OK button will be used to display the next dialog and the YES and NO buttons will be used to answer the question to the dialog text.
			buttonOK = new Button(80, 300, "OK", 80, 35, null, 16, 0xFFCCFF33, 0, advanceText, 0xFF000044);
			buttonYes = new Button(490, 282, "YES", 80, 35, null, 16, 0xFFCCFF33, 0, yesButtonClicked, 0xFF000044);
			buttonNo = new Button(580, 282, "No", 80, 35, null, 16, 0xFFCCFF33, 0, noButtonClicked, 0xFF000044);
			buttonOK.set_visible(false);
			buttonYes.set_visible(false);
			buttonNo.set_visible(false);
			add(buttonOK);
			add(buttonYes);
			add(buttonNo);
			
			if (InputControls.i.pressed) {}; // trap key press.
			if (InputControls.i.justReleased) {};
			
			ticks = 0;
			nextText();	
		}
		
		else
		{
			buttonExit = new Button(117, 350, "e: Exit", 160, 35, null, 16, 0xFFCCFF33, 0, buttonExitClicked);	
			buttonTitle = new Button(317, 350, "t: Title", 160, 35, null, 16, 0xFFCCFF33, 0, buttonTitleClicked);	
			buttonResume = new Button(517, 350, "r: Resume", 160, 35, null, 16, 0xFFCCFF33, 0, buttonResumeClicked);	
			add(buttonExit);
			add(buttonTitle);
			add(buttonResume);
		}
	}
	
	private function startText():Void
	{		
	
		typeTheDialogText.delay = 0.005;
		typeTheDialogText.start(0.002, false, false, null, completedCallback);
	}
	
	private function nextText():Void
	{	
		// Used to loop through the dialogIconText array.
		next++;
		
		// is there a paragraph to be displayed.
		if (Reg.dialogIconText[next] != null && Reg.dialogIconText[next] != "@" )
		{
			// set the text folder. inside the text at the end of each paragraph begins a number. that number is stored as an array in Reg.dialogCharacterTalk. see the dialog commands when an object is picked up or a chat is started at playState.
			var i = Std.parseInt(Reg.dialogIconText[next].substr(Reg.dialogIconText[next].length - 1, 1));
			
			if (i != null)
			{
				CurrentFaceToDisplay.loadGraphic("assets/images/" + Reg.dialogCharacterTalk[i], true, 110, 110);
			
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
			Reg._stopDemoFromPlaying = false;
			close(); 
		}
	}		
	
	override public function update(elapsed:Float):Void 
	{				
		// InputControls class is used for most buttons and keys while playing the game. If device has keyboard then keyboard keys are used else if mobile without keyboard then buttons are enabled and used.
		InputControls.checkInput();		
		
		ticks = Reg.incrementTicks(ticks, 60 / Reg._framerate);
		if (ticks > 15)
		{
		
			if (Reg.exitGameMenu == false)
			{
				// this action key is used to display the next paragraph.
				#if !FLX_NO_KEYBOARD
					if (InputControls.z.justReleased && Reg.displayDialogYesNo == false  
					 || InputControls.x.justReleased && Reg.displayDialogYesNo == false  
					 || InputControls.c.justReleased && Reg.displayDialogYesNo == false  
					)

					{
						nextText();		
					}
									
					// these keys are used to navigate the arrow at the yes / no answers.
					if (InputControls.right.pressed && Reg.displayDialogYesNo == true)
						yesNoArrow.setPosition(572, 283); 
						
					if (InputControls.left.pressed && Reg.displayDialogYesNo == true)
						yesNoArrow.setPosition(457, 283); 
					
					// display the arrow key at either the yes or no answer.
					if (InputControls.z.justReleased && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true
					 || InputControls.x.justReleased && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true 
					 || InputControls.c.justReleased && Reg.displayDialogYesNo == true && dialogBoxYesNo.exists == true )
					{
						Reg._dialogYesNoWasAnswered = true;
						
						if (yesNoArrow.x == 457)
							Reg._dialogAnsweredYes = true;
						else Reg._dialogAnsweredYes = false;
						
						Reg._stopDemoFromPlaying = false;
						close();
					}
				#end
				
				if ( Reg._dialogFastTextEnabled == true) 
				{
					if (typeTheDialogText != null) typeTheDialogText.skip();
				}
			}
			else
			{
				#if !FLX_NO_KEYBOARD
					if (FlxG.keys.anyJustPressed(["E"])) {Reg.exitProgram();}	
					if (FlxG.keys.anyJustPressed(["T"])) {Reg.playTwinkle(); new FlxTimer().start(0.15, delayRestartGame,1);}
					if (FlxG.keys.anyJustPressed(["R"])) {Reg.playTwinkle(); new FlxTimer().start(0.15, delayCloseSubstate,1);}
				#end								
			}
		}
		
		super.update(elapsed);
	}	
	
	private function delayRestartGame(Timer:FlxTimer):Void
	{
		Reg.resetRegVars(); 
		FlxG.resetGame(); 
	}
	
	private function delayCloseSubstate(Timer:FlxTimer):Void
	{
		Reg.exitGameMenu = false; 
		Reg._stopDemoFromPlaying = false; 
		close(); 
	}
	
	private function buttonExitClicked():Void
	{
		Reg.exitProgram();
	}
	
	private function buttonTitleClicked():Void
	{
		Reg.playTwinkle(); 
		new FlxTimer().start(0.15, delayRestartGame,1);
	}
	
	private function buttonResumeClicked():Void
	{
		Reg.playTwinkle(); 
		new FlxTimer().start(0.15, delayCloseSubstate,1);
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
		#if !FLX_NO_KEYBOARD
			if (Reg.displayDialogYesNo == true)
				dialogYesNo();
		#else
			dialogBoxYesNo.exists = true;
			
			if (Reg.displayDialogYesNo == true)
			{
				buttonOK.set_visible(false);
				buttonYes.set_visible(true);
				buttonNo.set_visible(true);
			}
			else {dialogBoxYesNo.exists = false; buttonOK.set_visible(true);}
		#end
	}
	
	private function advanceText():Void
	{
		nextText();		
	}
	
	private function yesButtonClicked():Void
	{
		Reg._dialogYesNoWasAnswered = true;
		Reg._dialogAnsweredYes = true;
		Reg._stopDemoFromPlaying = false;
		
		buttonOK.set_visible(true);
		buttonYes.set_visible(false);
		buttonNo.set_visible(false);
		
		close();
	}
	
	private function noButtonClicked():Void
	{
		Reg._dialogYesNoWasAnswered = true;
		Reg._dialogAnsweredYes = false;
		Reg._stopDemoFromPlaying = false;
		
		buttonOK.set_visible(true);
		buttonYes.set_visible(false);
		buttonNo.set_visible(false);
		
		close();
	}
}