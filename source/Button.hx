package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText.FlxTextAlign;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxSpriteUtil.LineStyle;

class Button extends FlxButton
{
	/*******************************************************************************************************
	 *  Changed FlxGraphicAsset; to FlxGraphicAsset = "assets/images/buttonMenu.png"; Normal, hover and click are the 3 frames in the image.
	 */
	private var _graphicAsset:FlxGraphicAsset;	

	/*******************************************************************************************************
	 * Thickness of the buttons border
	 */
	private var _border:Int = 3;
	
	/*******************************************************************************************************
	 * This is the color of the border when the mouse is overtop of the button.
	 */
	private var _borderColorHighlight:FlxColor = 0xFFCCFFFF;
	
	/*******************************************************************************************************
	 * This is the color of the border when the mouse is not overtop of the button.
	 */
	private var _borderColor:FlxColor = 0xFF008888;
	
	/** 
	 * @param	x				The x location of the button on the screen?
	 * @param	y				The y location of the button on the screen?
	 * @param	text			The button's text?
	 * @param	buttonWidth		Width of the button?
	 * @param	buttonHeight	Height of the button?	
	 * @param	graphicAsset	If this param is set then this is the image of the button. Normal, hover and click are the 3 frames in the image.
	 * @param	textSize		Font size of the text?
	 * @param	textColor		The color of the text?
	 * @param	textPadding		The padding between the button and the text?
	 * @param	onClick			When button is clicked this is the function to go to. The function name without the ()?
	 * @param	_innerColor		The color behind the text? Eg, 0x330000AA
	 */
	public function new(x:Float = 0, y:Float = 0, ?text:String, buttonWidth:Int = 80, buttonHeight:Int = 40, ?graphicAsset:FlxGraphicAsset, textSize:Int = 12, textColor:FlxColor = 0xFFFFFFFF, textPadding:Int = 0, ?onClick:Void->Void, _innerColor:FlxColor = 0x330000AA)	
	{	
		super(x, y, text, onClick);

		if (graphicAsset != null)
		{
			_graphicAsset = graphicAsset;
			loadGraphic(_graphicAsset, true, buttonWidth, buttonHeight);
		}
		else
		{
			var buttonGraphic:FlxSprite = makeGraphic(buttonWidth * 3, buttonHeight, FlxColor.TRANSPARENT); // * 3
			var lineStyle:LineStyle = { thickness: _border, color: _borderColor };
			
			for (i in 0...3)
			{
				var btnY:Float = (_border / 2);
				
				if (i == 2)
					btnY += 1;
				
				if (i > 0)
					lineStyle = { thickness: _border, color: _borderColorHighlight };
				
				FlxSpriteUtil.drawRoundRect(this, (i * buttonWidth) + (_border / 2), btnY, buttonWidth - _border, buttonHeight - _border - 1, 16, 16, _innerColor, lineStyle);
			}
			
			loadGraphic(graphic.bitmap, true, buttonWidth, buttonHeight);
		}
		
		
		if (label != null)
		{
			label.setFormat(null, textSize, textColor, FlxTextAlign.CENTER);
			// Center the labels horizontally and vertically. Works if word wrap line breaks the text.
			label.fieldWidth = buttonWidth - (textPadding * 2);
			label.text = text;
			label.x = textPadding;
			label.y = ((buttonHeight - label.textField.textHeight) - (label.height - label.textField.textHeight)) / 2;
	#if (flash || html5)
			label.y += 1;
	#end
			labelOffsets = [new FlxPoint(label.x, label.y - 1), new FlxPoint(label.x, label.y - 1), new FlxPoint(label.x, label.y)];
			label.alpha = 1;
			labelAlphas = [1, 1, 1];
		}
	}
	

}
