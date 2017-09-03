package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText.FlxTextAlign;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxSpriteUtil.LineStyle;

class MouseClickThisButton extends FlxButton
{
	public var down:Bool; // flag to prevent double fire of justPressed and justReleased events.
	
	private var _graphicAsset:FlxGraphicAsset; // = "assets/images/button_menu.png"; normal, hover, click for the 3 frames.
	private var _buttonHeight:Float = 40;
	private var _buttonWidth:Float = 80;
	private var _textPadding:Float = 0;
	
	private var _border:Int = 3;
	private var _borderColorHighlight:FlxColor = 0xFFFFFFFF;
	private var _borderColor:FlxColor = 0xFF0000FF;
	private var _innerColor:FlxColor =  0x330000AA; // FlxColor.TRANSPARENT;
	
	public function new(x:Float = 0, y:Float = 0, ?text:String, buttonWidth:Int = 80, buttonHeight:Int = 40, ?graphicAsset:FlxGraphicAsset, textSize:Int = 12, textColor:FlxColor = 0xFFFFFFFF, textPadding:Int = 0, ?onClick:Void->Void, _innerColor:FlxColor = 0x330000AA)	
	{	
		super(x, y, text, onClick);
		
		_buttonWidth = buttonWidth;
		_buttonHeight = buttonHeight;
		_textPadding = textPadding;
		
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
	
	public function positionLabel():Void
	{
		if (label != null)
		{
			label.fieldWidth = width - (_textPadding * 2);
			label.x = x + _textPadding;
			label.y = y + ((height - label.textField.textHeight) / 2);
			
			labelOffsets = [new FlxPoint(label.x, label.y - 1), new FlxPoint(label.x, label.y - 1), new FlxPoint(label.x, label.y)];
			label.alpha = 1;
			labelAlphas = [1, 1, 1];
		}
		
	}
}
