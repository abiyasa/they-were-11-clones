package mobi.papatong.sabelas.screens
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import starling.display.Button;
	import starling.textures.Texture;
	
	/**
	 * Utils and helper class for screen
	 * @author Abiyasa
	 */
	public class ScreenUtils
	{
		/** Common texture for button */
		private static var _commonButtonTexture:Texture;
		
		/**
		 * Create a dummy button
		 * @return a dummy button
		 */
		public static function createDummyButton(name:String = 'button', label:String = 'button'):Button
		{
			// create dummy texture from bitmap data
			if (_commonButtonTexture == null)
			{
				var bitmap:BitmapData = new BitmapData(100, 20, false, 0xCCCCCC);
				_commonButtonTexture = Texture.fromBitmapData(bitmap);
			}
			var theButton:Button = new Button(_commonButtonTexture, label);
			theButton.name = name;
			theButton.fontName = 'Tahoma, Geneva, sans-serif';
			theButton.fontBold = true;
			theButton.fontColor = 0xFFFFFF;
			
			return theButton;
		}
		
		/**
		 * Align dummy buttons on a specific area
		 *
		 * @param	buttons Array of button. All button should be children
		 * @param	area The area where the buttons will be aligned in
		 * @param	padding
		 * @param	gap
		 * @param	valign 'top', 'middle', or 'bottom'
		 * @param	halign 'left', 'center', or 'right'
		 */
		public static function layoutButtons(buttons:Array, area:Rectangle, padding:int = 5, gap:int = 5,
			valign:String = 'top', halign:String = 'left'):void
		{
			// centerized buttons
			var areaWidth:int = area.width;
			var areaHeight:int = area.height;
			var buttonX:int = area.x + padding;
			// TODO calculate buttonY based on valign
			var buttonY:int = area.y + padding;
			var posX:int;
			for each (var dummyButton:Button in buttons)
			{
				switch (halign)
				{
				case 'center':
					posX = buttonX + (areaWidth - dummyButton.width) / 2;
					break;
				
				case 'right':
					posX = areaWidth - dummyButton.width - padding;
					break;
					
				case 'left':
				default:
					posX = buttonX;
					break;
				}
				
				dummyButton.x = posX;
				dummyButton.y = buttonY;
				
				buttonY += dummyButton.height + gap;
			}
		}
	}
}
