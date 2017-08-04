package;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * @author galoyo
 */

class HudBox extends FlxSpriteGroup
{
	/*******************************************************************************************************
	 * Animation style enum. NONE, LOOP, PLAY_ON_CHANGE(default), LOOP_ON_FULL and PLAY_AND_LOOP.
	 */ 
	@:isVar
	public var animationStyle(get, set):AnimationStyle = AnimationStyle.PLAY_ON_CHANGE;
	/*******************************************************************************************************
	 * Whether to automatically max the HudBox value when power > 0 and decrease power by 1.
	 */
	@:isVar
	public var autoPowerUp(get, set):Bool = false;
	/*******************************************************************************************************
	 * The bar border color. Ignored if barShowBorder is false.
	 */
	@:isVar
	public var barBorderColor(get, set):FlxColor = 0xFFFFFFFF;
	/*******************************************************************************************************
	 * The HudBox border color. Ignored if borderWidth is 0.
	 */
	@:isVar
	public var borderColor(get, set):FlxColor = 0xFFFFFFFF;
	/*******************************************************************************************************
	 * The width of the border for this HudBox. 
	 */
	@:isVar
	public var borderWidth(get, set):Int = 0;
	/*******************************************************************************************************
	 * The bar empty color(s) array. Use only one color for a solid empty bar [0xFF006600], or multiple colors for gradient [0xFF006600, 0xFF666600, 0xFF660000].
	 */
	@:isVar
	public var barEmptyColors(get, set):Array<FlxColor> = [0xFF006600, 0xFF666600];
	/*******************************************************************************************************
	 * The bar fill color(s) array. Use only one color for a solid fill bar [0xFF00CC00], or multiple colors for gradient [0xFF00FF00, 0xFFFFFF00, 0xFFFF0000].
	 */
	@:isVar
	public var barFillColors(get, set):Array<FlxColor> = [0xFF00CC00, 0xFFCCCC00];
	/*******************************************************************************************************
	* Height of the bar.
	*/
	@:isVar
	public var barHeight(get, set):Float = 10;
	/*******************************************************************************************************
	* Padding space araound the bar.
	*/
	@:isVar
	public var barPadding(get, set):Int = 2;
	/*******************************************************************************************************
	* Background color of the HudBox.
	*/
	@:isVar
	public var bgColor(get, set):FlxColor = 0xFF000000;
	/*******************************************************************************************************
	* Corner radius of the background. 0 is square corners.
	*/
	@:isVar
	public var bgCornerRadius(get, set):Int = 0;
	/*******************************************************************************************************
	 * Is the HudBox enabled?
	 */
	@:isVar
	public var enabled(get, set):Bool = true;
	/*******************************************************************************************************
	 * This function will be called once when value reaches its minimum. Use setCallbacks() function to set.
	 */
	public var emptyCallback:Void->Void;
	/*******************************************************************************************************
	 * This function will be called once when value reaches its maximum. Use setCallbacks() function to set.
	 */
	public var filledCallback:Void->Void;
	/*******************************************************************************************************
	 * This function will be called when the value changes. Use setCallbacks() function to set.
	 */
	public var changeCallback:Void->Void;
	/*******************************************************************************************************
	 * This function will be called once when the warningValue is reached. Use setCallbacks() function to set.
	 */
	public var warningCallback:Void->Void;
	/*******************************************************************************************************
	 * Whether or not to hide the power text when it is 0.
	 */
	@:isVar
	public var hidePowerWhenZero(get, set):Bool = true;
	/*******************************************************************************************************
	 * Whether or not to hide the value text when it is 0.
	 */
	@:isVar
	public var hideValueWhenZero(get, set):Bool = true;
	/*******************************************************************************************************
	 * Animation frames for the icon.
	 */
	@:isVar
	public var iconFrames(get, set):Array<Int> = [0];
	/*******************************************************************************************************
	 * Animation framerate for the icon.
	 */
	@:isVar
	public var iconFrameRate(get, set):Int = 16;
	/*******************************************************************************************************
	 * Animation frame to show when icon is idle.
	 */
	@:isVar
	public var iconIdleFrame(get, set):Int = 0;
	/*******************************************************************************************************
	 * Full path and file name of the icon image.
	 */
	@:isVar
	public var iconPath(get, set):String;
	/*******************************************************************************************************
	 * If true, the value text is shown as a percentage. You may want to set valuePrefix to "%".
	 */
	@:isVar
	public var isPercent(get, set):Bool = false;
	/*******************************************************************************************************
	 * If true, it sets enabled to false when the value reaches min.
	 */
	@:isVar
	public var disableOnEmpty(get, set):Bool = false;
	/*******************************************************************************************************
	 * If true, it sets enabled to true when the value is > min. Ignored if disableOnEmpty = false.
	 */
	@:isVar
	public var enableOnNotEmpty(get, set):Bool = true;
	/*******************************************************************************************************
	 * If true, it sets visible to false when the value reaches min.
	 */
	@:isVar
	public var hideOnEmpty(get, set):Bool = false;
	/*******************************************************************************************************
	 * If true, it sets visible to true when the value is > min. Ignored if hideOnEmpty = false.
	 */
	@:isVar
	public var showOnNotEmpty(get, set):Bool = true;
	/*******************************************************************************************************
	 * Label displayed at the top of the HudBox.
	 */
	@:isVar
	public var label(get, set):String = "";
	/*******************************************************************************************************
	 * The label text color.
	 */
	@:isVar
	public var labelColor(get, set):FlxColor = 0xFFFFFFFF;
	/*******************************************************************************************************
	 * The minimum value of the HudBox. Read-only. Use setRange() to change min and max values.
	 */
	public var min(default, null):Float = 0;
	/*******************************************************************************************************
	 * The maximum value of the HudBox. Read-only. Use setRange() to change min and max values.
	 */
	public var max(default, null):Float = 100;
	/*******************************************************************************************************
	 * The maximum power value. Set maxPower = 0 for no limit.
	 */
	@:isVar
	public var maxPower(get, set):Int = 0;
	/*******************************************************************************************************
	 * Object to track value from. Use setParent() to set.
	 */
	public var parent:Dynamic;
	/*******************************************************************************************************
	 * Property of parent object to track. Use setParent() to set.
	 */
	public var parentVariable:String = "";
	/*******************************************************************************************************
	 * The power value. A value of 1 is equivalent to max, 2 is max * 2, etc.
	 */
	@:isVar
	public var power(get, set):Int = 0;
	/*******************************************************************************************************
	 * The power text color.
	 */
	@:isVar
	public var powerColor(get, set):FlxColor = 0xFFFFFFFF;
	/*******************************************************************************************************
	 * Whether the bar should have a 1px border.
	 */
	@:isVar
	public var showBarBorder(get, set):Bool = false;
	/*******************************************************************************************************
	 * Whether or not to show the icon if there is one. Ignored if no icon is added.
	 */
	@:isVar
	public var showIcon(get, set):Bool = false;
	/*******************************************************************************************************
	 * If true, the power text is shown.
	 */
	@:isVar
	public var showPower(get, set):Bool = false;
	/*******************************************************************************************************
	 * If true, the value text is shown.
	 */
	@:isVar
	public var showValue(get, set):Bool = false;
	/*******************************************************************************************************
	 * If true, the value text is shown during the warning. NOTE - Ignored if showValue == true.
	 */
	@:isVar
	public var showValueOnWarning(get, set):Bool = false;
	/*******************************************************************************************************
	 * Size of the label and value text. Power text is textSize * 1.3.
	 */
	@:isVar
	public var textSize(get, set):Int = 8;
	/*******************************************************************************************************
	 * The value of the HudBox.
	 */
	@:isVar
	public var value(get, set):Float;
	/*******************************************************************************************************
	 * The value text color.
	 */
	@:isVar
	public var valueColor(get, set):FlxColor = 0xFFFFFFFF;
	/*******************************************************************************************************
	 * Prefix string to add to the beginning of the value text. Usefull for adding the $ if used for cash.
	 */
	@:isVar
	public var valuePrefix(get, set):String = "";
	/*******************************************************************************************************
	 * Suffix string to add to the end of the value text. Usefull for adding the % if used for percent value.
	 */
	@:isVar
	public var valueSuffix(get, set):String = "";
	/*******************************************************************************************************
	 * Warning flag: true when value < warningValue && > min, and false when value <= min || > warningValue. 
	 */
	public var warning:Bool = false;
	/*******************************************************************************************************
	 * The rate that the HudBox flashes when warningValue is reached. Ignored if warningFlash = false.
	 */
	@:isVar
	public var warningRate(get, set):Float = 0.2;
	/*******************************************************************************************************
	 * The WarningStyle to use when waningValue is reached. NONE, FLASH_ALL, FLASH_BAR(default). Ignored if warningFlash = false.
	 */
	@:isVar
	public var warningStyle(get, set):WarningStyle = WarningStyle.FLASH_BAR;
	/*******************************************************************************************************
	 * The value when the onWarning callback will trigger and the HudBox will flash if warningFlash = true.
	 */
	@:isVar
	public var warningValue(get, set):Float = 0;
	/*******************************************************************************************************
	 * The FlxBar object for the HudBox. You can use the properties directly. ie hudBox.barValue.property
	 */
	public var barValue:FlxBar;
	/*******************************************************************************************************
	 * The Label FlxText object for the HudBox. You can use the properties directly. ie hudBox.txtLabel.property
	 */
	public var txtLabel:FlxText;
	/*******************************************************************************************************
	 * The Value FlxText object for the HudBox. You can use the properties directly. ie hudBox.txtValue.property
	 */
	public var txtValue:FlxText;
	/*******************************************************************************************************
	 * The Power FlxText object for the HudBox. You can use the properties directly. ie hudBox.txtPower.property
	 */
	public var txtPower:FlxText;
	/*******************************************************************************************************
	 * The Icon FlxSprite object for the HudBox. You can use the properties directly. ie hudBox.sprIcon.property
	 */
	public var sprIcon:FlxSprite;
	/*******************************************************************************************************
	 * The background FlxSprite object for the HudBox. You can use the properties directly. ie hudBox.sprBg.property
	 */
	public var sprBg:FlxSprite;
	/*******************************************************************************************************/
	
	/*******************************************************************************************************
	 * Creates a new HudBox for your Hud.
	 * 
	 * @param   x                   X coordinate of the HudBox.
	 * @param   y                   Y coordinate of the HudBox.
	 * @param   width               Width of the HudBox.
	 * @param   height              Height of the HudBox. NOTE! If you are adding an icon, the height of the icon will be added to this value.
	 * @param   label               Label text displayed at the top of the HudBox.
	 * @param   min                 Minimum value of the HudBox.
	 * @param   max                 Maximum value of the HudBox.
	 * @param   parentRef           Parent object to track from.
	 * @param   parentRefVariable   Property of parent object to track.
	 * @param   textSize            Text size of the label and value text. The power text size is textSize *1.3
	 * @param   barHeight           Height of the FlxBar.
	 * @param   bgCornerRadius      Corner radius size for the background sprite.
	 * @param   bgColor             Color of the background sprite.
	 * @param   iconPath            Full path to the icon including filename.
	 * @param   barEmptyColors      Color array for the bars empty color(s). Use one for solid bar [0xFF006600], or many for gradient. Must be an array.
	 * @param   barFillColors       Color array for the bars full color(s). Use one for solid bar [0xFF00CC00], or many for gradient. Must be an array.
	 * @param   labelColor          Color of the label text.
	 * @param   valueColor          Color of the value text.
	 * @param   powerColor          Color of the power text.
	 */
	public function new(
		x:Float = 0, y:Float = 0, width:Float = 48, height:Float = 28, 
		label:String = "", min:Float = 0, max:Float = 100, ?parentRef:Dynamic, parentRefVariable:String = "", 
		textSize:Int = 8, barHeight:Float = 10, bgCornerRadius:Int = 0, bgColor:FlxColor = 0xFF000000, ?iconPath:String, 
		?barEmptyColors:Array<FlxColor>, ?barFillColors:Array<FlxColor>, 
		labelColor:FlxColor = 0xFFFFFFFF, valueColor:FlxColor = 0xFFFFFFFF, powerColor:FlxColor = 0xFFFFFFFF)
	{
		
		super();
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		
		txtLabel = new FlxText(x, y, width, label, textSize);
		txtPower = new FlxText(x, y + height - barHeight, width - 2, "0", Std.int(textSize * 1.3));
		txtPower.visible = showPower;
		txtValue = new FlxText(x, y + height - barHeight, width, "0", textSize);
		txtValue.visible = showValue;
		barValue = new FlxBar(x + barPadding, y + height - barHeight - barPadding, null, Std.int(width - 4), Std.int(barHeight), parentRef, parentVariable, min, max, true);
	
		this.bgColor = bgColor;
		this.bgCornerRadius = bgCornerRadius;
		this.label = label;
		this.textSize = textSize;
		this.labelColor = labelColor;
		this.valueColor = valueColor;
		this.powerColor = powerColor;
		this.barHeight = barHeight;
		
		if (barEmptyColors != null)
			this.barEmptyColors = barEmptyColors;
		
		if (barFillColors != null)
			this.barFillColors = barFillColors;
		
		setRange(min, max);
		
		sprBg = new FlxSprite().makeGraphic(Std.int(width), Std.int(height), 0x00000000, true);
		
		if (parentRef != null)
			setParent(parentRef, parentRefVariable);
			
		updateTextFormat();
		updateBar();
		
		add(sprBg);
		add(barValue);
		add(txtLabel);
		add(txtValue);
		add(txtPower);
		
		if (iconPath != null)
		{
			createIcon(iconPath, iconFrames, iconFrameRate, iconIdleFrame);
			
			this.iconPath = iconPath;
			
			if (showIcon)
				resizeHudBox(width, height + sprIcon.height);
			else	
				resizeHudBox(width, height);
		}
		
		scrollFactor.set();
	}
	
	/*******************************************************************************************************/
	
	override public function update(elapsed:Float):Void
	{
		if (!enabled && !enableOnNotEmpty)
			return;
		
		if (barValue.parent != null)
		{
			if (Reflect.getProperty(barValue.parent, barValue.parentVariable) != value)
				updateValueFromParent();
			
			if (value <= min && autoPowerUp && power > 0)
			{
				Reflect.setProperty(barValue.parent, barValue.parentVariable, max);
				updateValueFromParent();
				power--;
			}
			else if (Reflect.getProperty(barValue.parent, barValue.parentVariable) > max && autoPowerUp)
			{
				while (Reflect.getProperty(barValue.parent, barValue.parentVariable) > max && ((power < maxPower && maxPower > 0) || maxPower == 0))
				{
					power += 1;
					Reflect.setProperty(barValue.parent, barValue.parentVariable, Reflect.getProperty(barValue.parent, barValue.parentVariable) - max);
					updateValueFromParent();
				}
			}
		}
		
		if (value != barValue.value)
		{
			value = barValue.value;
			updateValueText();
		}
		
		if (showValueOnWarning && !showValue)
		{
			if (value <= warningValue && power <= 0 && !txtValue.visible)
				txtValue.visible = true;
			else if (value > warningValue && txtValue.visible)
				txtValue.visible = false;
		}
		
		if (hideValueWhenZero && (showValue || showValueOnWarning))
		{
			if (value <= 0 && txtValue.visible)
				txtValue.visible = false;
			else if (value > 0 && !txtValue.visible)
				if (!showValueOnWarning || showValue)
					txtValue.visible = true;
		}
		
		if (showPower == true)
		{
			if (Reg._gunHudBoxDisplayMaximumText == true)
				txtPower.visible = false;
			else txtPower.visible = true;
		} else txtPower.visible = false;
		
		super.update(elapsed);
	}
	
	/*******************************************************************************************************
	 * Sets callbacks which will be triggered when the value of this HudBox reaches min, max, warning or changes.
	 * Functions will only be called once and not again until the value changes.
	 * 
	 * @param   onEmpty          The function that is called if the value of this HudBox reaches min.
	 * @param   onFilled         The function that is called if the value of this HudBox reaches max.
	 * @param   onChange         The function that is called when the value of this HudBox changes.
	 * @param   onWarning        The function that is called when the value of this HudBox reached warningValue.
	 */
	public function setCallbacks(onEmpty:Void->Void, onFilled:Void->Void, onChange:Void->Void, onWarning:Void->Void):Void
	{
		emptyCallback   = (onEmpty != null)   ? onEmpty   : emptyCallback;
		filledCallback  = (onFilled != null)  ? onFilled  : filledCallback;
		changeCallback  = (onChange != null)  ? onChange  : changeCallback;
		warningCallback = (onWarning != null) ? onWarning : warningCallback;
	}
	
	/*******************************************************************************************************
	 * Sets a parent for this HudBox. Instantly replaces any previously set parent and refreshes the bar.
	 * 
	 * @param   parentRef   A reference to an object in your game that you wish the bar to track
	 * @param   variable    The variable of the object that is used to determine the bar position. For example if the parent is a FlxSprite, this could be "health" to track the health value.
	 */
	public function setParent(parentRef:Dynamic, parentRefVariable:String):Void
	{
		barValue.parent = parentRef;
		barValue.parentVariable = parentRefVariable;
		updateValueFromParent();
	}
	
	/*******************************************************************************************************
	 * Set the minimum and maximum allowed values for the HudBox
	 * 
	 * @param   min   The minimum value.
	 * @param   max   The maximum value the bar can reach.
	 */
	public function setRange(min:Float, max:Float):Void
	{
		if (max <= min)
		{
			throw "HudBox: max cannot be less than or equal to min";
			return;
		}
		
		this.min = min;
		this.max = max;
		
		barValue.setRange(min, max);
	}
	
	/*******************************************************************************************************
	 * Updates the size of the HudBox. Use this function after setting width or height properties.
	 * NOTE! This is a temporary, hack function needed until I make it unnecessary!
	 * If you specify the width and height in new(), or not last in property setup, it's not needed.
	 */
	public function updateResize():Void
	{
			if (showIcon && sprIcon != null)
				resizeHudBox(width, height + sprIcon.height);
			else	
				resizeHudBox(width, height);
	}
	
	/*******************************************************************************************************/
	/* private functions */
	/*******************************************************************************************************/
	
	private function createIcon(?iconPath:String, ?iconFrames:Array<Int>, ?iconFrameRate:Int = 16, ?iconIdleFrame:Int = 0):Void
	{
		if (iconPath == null)
			return;
		
		if (sprIcon != null)
			sprIcon.destroy();
		
		sprIcon = new FlxSprite();
		
		sprIcon.loadGraphic(iconPath, true);
		sprIcon.animation.add("play", iconFrames, iconFrameRate, false);
		sprIcon.animation.add("loop", iconFrames, iconFrameRate, true);
		sprIcon.animation.add("idle", [iconIdleFrame]);
		
		add(sprIcon);
		
		if (showIcon)
			resizeHudBox(width, height + sprIcon.height);
		else	
			resizeHudBox(width, height);
	}
	
	/*******************************************************************************************************/
	
	private function flash(warning:Bool):Void
	{
		if (warningStyle == WarningStyle.NONE)
			return;
		
		if (warning)
		{
			if (warningStyle == WarningStyle.FLASH_ALL)
			{
				if (sprIcon != null && showIcon)
					FlxSpriteUtil.flicker(sprIcon, warningRate * 2, warningRate);
				
				if (showPower)
					FlxSpriteUtil.flicker(txtPower, warningRate * 2, warningRate);
				
				if (showValue)
					FlxSpriteUtil.flicker(txtValue, warningRate * 2, warningRate);
				
				FlxSpriteUtil.flicker(txtLabel, warningRate * 2, warningRate);
				FlxSpriteUtil.flicker(sprBg, warningRate * 2, warningRate);
				FlxSpriteUtil.flicker(barValue, warningRate * 2, warningRate);
			}
			else if (warningStyle == WarningStyle.FLASH_BAR)
			{
				if (showValue)
					FlxSpriteUtil.flicker(txtValue, 0, warningRate);
				
				FlxSpriteUtil.flicker(barValue, 0, warningRate);
			}
		}
		else
		{
			if (warningStyle == WarningStyle.FLASH_ALL)
			{
				if (sprIcon != null && showIcon)
					FlxSpriteUtil.stopFlickering(sprIcon);
				
				if (showPower)
					FlxSpriteUtil.stopFlickering(txtPower);
				
				if (showValue)
					FlxSpriteUtil.stopFlickering(txtValue);
				
				FlxSpriteUtil.stopFlickering(txtLabel);
				FlxSpriteUtil.stopFlickering(sprBg);
				FlxSpriteUtil.stopFlickering(barValue);
			}
			else if (warningStyle == WarningStyle.FLASH_BAR)
			{
				if (showValue)
					FlxSpriteUtil.stopFlickering(txtValue);
				
				FlxSpriteUtil.stopFlickering(barValue);
			}
		}
	}
	
	/*******************************************************************************************************/
	
	private function getAnimation():String
	{
		switch (animationStyle)
		{
			case AnimationStyle.NONE:
				return "idle";
			
			case AnimationStyle.LOOP:
				return "loop";
			
			case AnimationStyle.LOOP_ON_FULL:
				if (value == max)
					return "loop";
				else
					return "idle";
			
			case AnimationStyle.PLAY_ON_CHANGE:
				return "play";
			
			case AnimationStyle.PLAY_AND_LOOP:
				if (value == max)
					return "loop";
				else
					return "play";
					
			case AnimationStyle.CUSTOM:
				return "";
					
			default:
				return "";
		}
	}
	
	/*******************************************************************************************************/
	
	private function resizeHudBox(?newWidth:Float, ?newHeight:Float):Void
	{
		updateBg(newWidth, newHeight);
		resizeBar(newWidth - (barPadding * 2) - (borderWidth * 2), barHeight);
		
		barValue.x = x + newWidth / 2 - barValue.width / 2;
		barValue.y = y + newHeight - barValue.height - barPadding - borderWidth;
		
		// HORIZONTAL ALIGNMENT NEEDS TO BE BETTER!! HACKED WITH - 2
		txtLabel.fieldWidth = newWidth - 2;
		txtValue.fieldWidth = newWidth - 2;
		txtPower.fieldWidth = newWidth - barPadding - borderWidth;
		
		txtLabel.x = x;
		txtValue.x = x;
		txtPower.x = x;
		
		txtLabel.y = y + borderWidth;
		
		// VERTICAL ALIGNMENT NEEDS TO BE BETTER!!
		txtValue.y = barValue.y + (barValue.height / 2 - txtValue.height / 2) + (0.5 * (barHeight - textSize) + 1);
		txtPower.y = barValue.y + (barValue.height / 2 - txtPower.height / 2) + (0.45 * (barHeight - (textSize * 1.3)));
		
		if (sprIcon != null && showIcon)
			sprIcon.setPosition(x + newWidth / 2 - sprIcon.width / 2, y + newHeight / 2 - sprIcon.height / 2);
	}
	
	/*******************************************************************************************************/
	
	private function resizeBar(newWidth:Float, newHeight:Float):Void
	{
		barValue.setGraphicSize(Std.int(newWidth), Std.int(newHeight));
		updateBar();
		barValue.updateHitbox();
	}
	
	/*******************************************************************************************************/
	
	private function setEnable():Void
	{
		if (disableOnEmpty && value <= min && enabled)
			enabled = false;
		
		if (enableOnNotEmpty && value > min && !enabled)
			enabled = true;
	}
	
	/*******************************************************************************************************/
	
	private function setVisible():Void
	{
		if (FlxSpriteUtil.isFlickering(barValue))
			flash(false);
			
		if (hideOnEmpty && value <= min)
			visible = false;
		
		if (showOnNotEmpty && value > min)
		{
			visible = true;
			
			if (sprIcon != null && !showIcon)
				sprIcon.visible = false;
				
			if (!showPower)
				txtPower.visible = false;
				
			if (!showValue)
				txtValue.visible = false;
		}
	}
	
	/*******************************************************************************************************/
	
	private function updateBar():Void
	{
		if (barValue == null)
			return;
		
		if (barEmptyColors.length > 1 && barFillColors.length > 1)
			barValue.createGradientBar(barEmptyColors, barFillColors, 1, 180, showBarBorder, barBorderColor);
		else
			barValue.createFilledBar(barEmptyColors[0], barFillColors[0], showBarBorder, barBorderColor);
	}
	
	/*******************************************************************************************************/
	
	private function updateBg(w:Float, h:Float):Void
	{
		if (sprBg == null)
			return;
		
		sprBg.setSize(w, h); // 0, 0
		sprBg.setPosition(0, 0);
		
		FlxSpriteUtil.fill(sprBg, 0x00000000).makeGraphic(Std.int(w), Std.int(h), 0x00000000, true);
		FlxSpriteUtil.drawRoundRect(sprBg, 0, 0, w, h, bgCornerRadius, bgCornerRadius, bgColor);
		
		if (borderWidth > 0)
		{
			var lineStyle:LineStyle = { color: borderColor, thickness: borderWidth };
			FlxSpriteUtil.drawRoundRect(sprBg, borderWidth / 2, borderWidth / 2, w - borderWidth, h - borderWidth, bgCornerRadius - borderWidth, bgCornerRadius - borderWidth, 0x00000000, lineStyle);
		}
		
		sprBg.x = x;
		sprBg.y = y;
	}
	
	/*******************************************************************************************************/
	
	private function updateIcon():Void
	{
		if (iconPath == null)
			return;
			
		if (sprIcon == null)
			createIcon(iconPath, iconFrames, iconFrameRate, iconIdleFrame);
		
		sprIcon.animation.destroyAnimations();
		
		sprIcon.animation.add("play", iconFrames, iconFrameRate, false);
		sprIcon.animation.add("loop", iconFrames, iconFrameRate, true);
		sprIcon.animation.add("idle", [iconIdleFrame], 0, false);
		
		if (getAnimation() != "")
			sprIcon.animation.play(getAnimation());
	}
	
	/*******************************************************************************************************/
	
	private function updateTextFormat():Void
	{
		if (textSize != txtValue.size)
		{
			txtLabel.size = textSize;
			txtPower.size = Std.int(textSize * 1.3);
			txtValue.size = textSize;
		}
		
		if (labelColor != txtLabel.textField.textColor)
			txtLabel.setFormat(null, textSize, labelColor, CENTER);
		
		if (powerColor != txtPower.textField.textColor)
			txtPower.setFormat(null, Std.int(textSize * 1.3), powerColor, RIGHT);
		
		if (valueColor != txtValue.textField.textColor)
			txtValue.setFormat(null, textSize, valueColor, CENTER);
	}
	
	/*******************************************************************************************************/
	
	private function updateValueText():Void
	{
		if (isPercent)
			txtValue.text = valuePrefix + Math.ceil(barValue.percent) + valueSuffix;
		else if (showValue == true)
		{
			if(valuePrefix == "" || this.txtLabel.text != "Gun Power")
				txtValue.text = valuePrefix + Math.ceil(value) + valueSuffix;
		
		}
		else
		{
			txtValue.text = valuePrefix;
			showValue = true;
			Reg._gunHudBoxDisplayMaximumText = true;
		}
				
	}	
	
	/*******************************************************************************************************/
	
	private function updateValueFromParent():Void
	{
		value = Reflect.getProperty(barValue.parent, barValue.parentVariable); //
		updateValueText();
	}
	
	/*******************************************************************************************************/
	/* setters & getters */
	/*******************************************************************************************************/
	
	public override function set_width(newWidth):Float
	{
		super.set_width(newWidth);
		width = newWidth;
		return newWidth;
	}
	
	public override function get_width():Float {
		super.get_width();
		return width;
	}
	
	/*******************************************************************************************************/
	
	public override function set_height(newHeight):Float
	{
		super.set_height(newHeight);
		height = newHeight;
		return newHeight;
	}
	
	public override function get_height():Float {
		super.get_height();
		return height;
	}
	
	/*******************************************************************************************************/
	
	private function set_animationStyle(newAnimationStyle:AnimationStyle):AnimationStyle
	{
		animationStyle = newAnimationStyle;
		updateIcon();
		return newAnimationStyle;
	}
	
	private function get_animationStyle():AnimationStyle { return animationStyle; }
	
	/*******************************************************************************************************/
	
	private function set_autoPowerUp(newAutoPowerUp:Bool):Bool
	{
		autoPowerUp = newAutoPowerUp;
		return newAutoPowerUp;
	}
	
	private function get_autoPowerUp():Bool { return autoPowerUp; }
	
	/*******************************************************************************************************/
	
	private function set_barBorderColor(newBarBorderColor:FlxColor):FlxColor
	{
		barBorderColor = newBarBorderColor;
		updateBar();
		return newBarBorderColor;
	}
	
	private function get_barBorderColor():FlxColor { return barBorderColor; }
	
	/*******************************************************************************************************/
	
	private function set_borderColor(newBorderColor:FlxColor):FlxColor
	{
		borderColor = newBorderColor;
		resizeHudBox(width, height);
		return newBorderColor;
	}
	
	private function get_borderColor():FlxColor { return borderColor; }
	
	/*******************************************************************************************************/
	
	private function set_borderWidth(newBorderWidth:FlxColor):FlxColor
	{
		borderWidth = newBorderWidth;
		resizeHudBox(width, height);
		return newBorderWidth;
	}
	
	private function get_borderWidth():FlxColor { return borderWidth; }
	
	/*******************************************************************************************************/
	
	private function set_barEmptyColors(newBarEmptyColors:Array<FlxColor>):Array<FlxColor>
	{
		barEmptyColors = newBarEmptyColors;
		updateBar();
		return newBarEmptyColors;
	}
	
	private function get_barEmptyColors():Array<FlxColor> { return barEmptyColors; }
	
	/*******************************************************************************************************/
	
	private function set_barFillColors(newBarFillColors:Array<FlxColor>):Array<FlxColor>
	{
		barFillColors = newBarFillColors;
		updateBar();
		return newBarFillColors;
	}
	
	private function get_barFillColors():Array<FlxColor> { return barFillColors; }
	
	/*******************************************************************************************************/
	
	private function set_barHeight(newBarHeight:Float):Float
	{
		barHeight = newBarHeight;
		resizeHudBox(width, height);
		return newBarHeight;
	}
	
	private function get_barHeight():Float { return barHeight; }
	
	/*******************************************************************************************************/
	
	private function set_barPadding(newBarPadding:Int):Int
	{
		barPadding = newBarPadding;
		resizeHudBox(width, height);
		return newBarPadding;
	}
	
	private function get_barPadding():Int { return barPadding; }
	
	/*******************************************************************************************************/
	
	private function set_bgColor(newBgColor:FlxColor):FlxColor
	{
		bgColor = newBgColor;
		resizeHudBox(width, height);
		return newBgColor;
	}
	
	private function get_bgColor():FlxColor { return bgColor; }
	
	/*******************************************************************************************************/
	
	private function set_bgCornerRadius(newBgCornerRadius:Int):Int
	{
		bgCornerRadius = newBgCornerRadius;
		resizeHudBox(width, height);
		return newBgCornerRadius;
	}
	
	private function get_bgCornerRadius():Int { return bgCornerRadius; }
	
	/*******************************************************************************************************/
	
	private function set_enabled(newEnabled:Bool):Bool
	{
		enabled = newEnabled;
		
		if (enabled)
			alpha = 1;
		else
			alpha = 0.5;
		
		return newEnabled;
	}
	
	private function get_enabled():Bool { return enabled; }
	
	/*******************************************************************************************************/
	
	private function set_enableOnNotEmpty(newEnableOnNotEmpty:Bool):Bool
	{
		enableOnNotEmpty = newEnableOnNotEmpty;
		setEnable();
		return newEnableOnNotEmpty;
	}
	
	private function get_enableOnNotEmpty():Bool { return enableOnNotEmpty; }
	
	/*******************************************************************************************************/
	
	private function set_disableOnEmpty(newDisableOnEmpty:Bool):Bool
	{
		disableOnEmpty = newDisableOnEmpty;
		setEnable();
		return newDisableOnEmpty;
	}
	
	private function get_disableOnEmpty():Bool { return disableOnEmpty; }
	
	/*******************************************************************************************************/
	
	private function set_showOnNotEmpty(newShowOnNotEmpty:Bool):Bool
	{
		showOnNotEmpty = newShowOnNotEmpty;
		setVisible();
		return newShowOnNotEmpty;
	}
	
	private function get_showOnNotEmpty():Bool { return showOnNotEmpty; }
	
	/*******************************************************************************************************/
	
	private function set_hideOnEmpty(newHideOnEmpty:Bool):Bool
	{
		hideOnEmpty = newHideOnEmpty;
		setVisible();
		return newHideOnEmpty;
	}
	
	private function get_hideOnEmpty():Bool { return hideOnEmpty; }
	
	/*******************************************************************************************************/
	
	private function set_hidePowerWhenZero(newHidePowerWhenZero:Bool):Bool
	{
		hidePowerWhenZero = newHidePowerWhenZero;
		return newHidePowerWhenZero;
	}
	
	private function get_hidePowerWhenZero():Bool { return hidePowerWhenZero; }
	
	/*******************************************************************************************************/
	
	private function set_hideValueWhenZero(newHideValueWhenZero:Bool):Bool
	{
		hideValueWhenZero = newHideValueWhenZero;
		return newHideValueWhenZero;
	}
	
	private function get_hideValueWhenZero():Bool { return hideValueWhenZero; }
	
	/*******************************************************************************************************/
	
	private function set_iconFrames(newIconFrames:Array<Int>):Array<Int>
	{
		iconFrames = newIconFrames;
		updateIcon();
		return newIconFrames;
	}
	
	private function get_iconFrames():Array<Int> { return iconFrames; }
	
	/*******************************************************************************************************/
	
	private function set_iconFrameRate(newIconFrameRate:Int):Int
	{
		iconFrameRate = newIconFrameRate;
		updateIcon();
		return newIconFrameRate;
	}
	
	private function get_iconFrameRate():Int { return iconFrameRate; }
	
	/*******************************************************************************************************/
	
	private function set_iconIdleFrame(newIconIdleFrame:Int):Int
	{
		iconIdleFrame = newIconIdleFrame;
		updateIcon();
		return newIconIdleFrame;
	}
	
	private function get_iconIdleFrame():Int { return iconIdleFrame; }
	
	/*******************************************************************************************************/
	
	private function set_iconPath(newIconPath:String):String
	{
		iconPath = newIconPath;
		updateIcon();
		return newIconPath;
	}
	
	private function get_iconPath():String { return iconPath; }
	
	/*******************************************************************************************************/
	
	private function set_isPercent(newIsPercent:Bool):Bool
	{
		isPercent = newIsPercent;
		updateValueText();
		return newIsPercent;
	}
	
	private function get_isPercent():Bool { return isPercent; }
	
	/*******************************************************************************************************/
	
	private function set_label(newLabel:String):String
	{
		label = newLabel;
		txtLabel.text = label;
		return newLabel;
	}
	
	private function get_label():String { return label; }
	
	/*******************************************************************************************************/
	
	private function set_labelColor(newLabelColor:FlxColor):FlxColor
	{
		labelColor = newLabelColor;
		updateTextFormat();
		return newLabelColor;
	}
	
	private function get_labelColor():FlxColor { return labelColor; }
	
	/*******************************************************************************************************/
	
	private function set_maxPower(newMaxPower:Int):Int
	{
		maxPower = newMaxPower;
		return newMaxPower;
	}
	
	private function get_maxPower():Int { return maxPower; }
	
	/*******************************************************************************************************/
	
	private function set_power(newPower:Int):Int
	{
		power = newPower;
			
		if (showPower)
		{
			if (Reg._gunHudBoxDisplayMaximumText == true)
				txtPower.visible = false;
			else
				txtPower.visible = true;
		}
		
		txtPower.text = Std.string((newPower));
		
		return newPower;
	}
	
	private function get_power():Int { return power; }
	
	/*******************************************************************************************************/
	
	private function set_powerColor(newPowerColor:FlxColor):FlxColor
	{
		powerColor = newPowerColor;
		updateTextFormat();
		return newPowerColor;
	}
	
	private function get_powerColor():FlxColor { return powerColor; }
	
	/*******************************************************************************************************/
	
	private function set_showBarBorder(newShowBarBorder:Bool):Bool
	{
		showBarBorder = newShowBarBorder;
		updateBar();
		return newShowBarBorder;
	}
	
	private function get_showBarBorder():Bool { return showBarBorder; }
	
	/*******************************************************************************************************/
	
	private function set_showIcon(newShowIcon:Bool):Bool
	{
		showIcon = newShowIcon;
		
		if (sprIcon != null)
		{
			if (showIcon)
				resizeHudBox(width, height + sprIcon.height);
			else	
				resizeHudBox(width, height);
				
			sprIcon.visible = showIcon;
		}
		
		return newShowIcon;
	}
	
	private function get_showIcon():Bool { return showIcon; }
	
	/*******************************************************************************************************/
	
	private function set_showPower(newShowPower:Bool):Bool
	{
		showPower = newShowPower;
		txtPower.visible = newShowPower;
		return newShowPower;
	}
	
	private function get_showPower():Bool { return showPower; }
	
	/*******************************************************************************************************/
	
	private function set_showValue(newShowValue:Bool):Bool
	{
		showValue = newShowValue;
		txtValue.visible = showValue;
		return newShowValue;
	}
	
	private function get_showValue():Bool { return showValue; }
	
	/*******************************************************************************************************/
	
	private function set_showValueOnWarning(newShowValueOnWarning:Bool):Bool
	{
		showValueOnWarning = newShowValueOnWarning;
		txtValue.visible = showValueOnWarning;
		return newShowValueOnWarning;
	}
	
	private function get_showValueOnWarning():Bool { return showValueOnWarning; }
	
	/*******************************************************************************************************/
	
	private function set_textSize(newTextSize:Int):Int
	{
		textSize = newTextSize;
		updateTextFormat();
		return newTextSize;
	}
	
	private function get_textSize():Int { return textSize; }
	
	/*******************************************************************************************************/
	
	private function set_value(newValue:Float):Float
	{
		value = Math.max(min, Math.min(newValue, max));
		
		updateValueText();
		
		if (changeCallback != null)
			changeCallback();
		
		if (value <= warningValue && value > min + 0.3 && !(autoPowerUp && power > 0) && !warning && warningStyle != WarningStyle.NONE)
		{
			if (warningCallback != null)
				warningCallback();
				
			warning = true;
		}
		else if (value == min && warning || (value > warningValue) && warningStyle != WarningStyle.NONE)
		{
			warning = false;
		}
			
		if (value == max && filledCallback != null)
			filledCallback();
		
		if (value == min && emptyCallback != null)
			emptyCallback();
		
		if (!(autoPowerUp && power > 0) && warningStyle != WarningStyle.NONE && (value <= warningValue && value > min) && !FlxSpriteUtil.isFlickering(barValue))
			flash(true);
		
		if (value == min && disableOnEmpty && enabled)
			setEnable();
		
		if (value > min && enableOnNotEmpty && !enabled)
			setEnable();
		
		if (value == min && hideOnEmpty)
			setVisible();
		
		if (value > min && showOnNotEmpty && !(warningStyle != WarningStyle.NONE && value <= warningValue))
			setVisible();
		
		if (sprIcon != null && getAnimation() != "")
			sprIcon.animation.play(getAnimation());
		
		if (value <= min && FlxSpriteUtil.isFlickering(barValue))
			flash(false);
		
		return newValue;
	}
	
	private function get_value():Float { return value; }
	
	/*******************************************************************************************************/
	
	private function set_valueColor(newValueColor:FlxColor):FlxColor
	{
		valueColor = newValueColor;
		updateTextFormat();
		return newValueColor;
	}
	
	private function get_valueColor():FlxColor { return valueColor; }
	
	/*******************************************************************************************************/
	
	private function set_valuePrefix(newValuePrefix:String):String
	{
		valuePrefix = newValuePrefix;
		updateValueText();
		return newValuePrefix;
	}
	
	private function get_valuePrefix():String { return valuePrefix; }
	
	/*******************************************************************************************************/
	
	private function set_valueSuffix(newValueSuffix:String):String
	{
		valueSuffix = newValueSuffix;
		updateValueText();
		return newValueSuffix;
	}
	
	private function get_valueSuffix():String { return valueSuffix; }
	
	/*******************************************************************************************************/
	
	private function set_warningRate(newWarningRate:Float):Float
	{
		warningRate = newWarningRate;
		return newWarningRate;
	}
	
	private function get_warningRate():Float { return warningRate; }
	
	/*******************************************************************************************************/
	
	private function set_warningStyle(newWarningStyle:WarningStyle):WarningStyle
	{
		warningStyle = newWarningStyle;
		return newWarningStyle;
	}
	
	private function get_warningStyle():WarningStyle { return warningStyle; }
	
	/*******************************************************************************************************/
	
	private function set_warningValue(newWarningValue:Float):Float
	{
		warningValue = newWarningValue;
		return newWarningValue;
	}
	
	private function get_warningValue():Float { return warningValue; }
	
	/*******************************************************************************************************/
	
}

enum AnimationStyle
{
	NONE;             // Animation never plays.
	LOOP;             // Animation always loops.
	PLAY_ON_CHANGE;   // Animation plays once each time the value changes.
	LOOP_ON_FULL;     // Animation loops when the value reaches max.
	PLAY_AND_LOOP;    // Animation plays once when the value changes and loops when value reaches max.
	CUSTOM;           // Animation is ignored in this class so you can use it in a custom way in your hud class.
}

enum WarningStyle
{
	NONE;             // No warning flash. You can use warningCallback for custom warning behaviour.
	FLASH_ALL;        // Will flash the entire HudBox when warningValue is reached.
	FLASH_BAR;        // Will flash only the FlxBar and value text when warningValue is reached.
}
