package sabelas.screens
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import sabelas.configs.ScreenConfig;
	import sabelas.screens.ScreenWithButtonBase;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	/**
	 * Configuration/option screen
	 *
	 * @author Abiyasa
	 */
	public class ConfigScreen extends ScreenWithButtonBase
	{
		public static const DEBUG_TAG:String = 'ConfigScreen';
		
		[Embed(source="../../../assets/ubuntu-bold-48_0.png")]
		private static const MainBitmapFont:Class;
		
		[Embed(source="../../../assets/ubuntu-bold-48.fnt", mimeType="application/octet-stream")]
		private static const MainBitmapFontXML:Class;
		
		protected var _title:TextField;
		
		/**
		 * Constructor
		 */
		public function ConfigScreen()
		{
			super();
			
			prepareBitmapFonts();
			
			createButtons([
				{
					name: 'back',
					textureName: 'button_back',
					x: 640 - 5 - 41,
					y: 5,
					screenEvent: ScreenConfig.SCREEN_MAIN_MENU
				}
				
			]);
			
			_title = new TextField(400, 400, 'They were 11 Clones', 'Ubuntu', 32, 0x534741, true);
			_title.fontSize = BitmapFont.NATIVE_SIZE;  // use defined bitmap font size
			//_title.color = Color.WHITE;  // use real color (white)
			_title.text = 'They were 11 Clones\nby Abiyasa (Papatong Mobi)\n2012'
			_title.hAlign = 'center';
			_title.vAlign = 'top';
			_title.touchable = false;
			this.addChild(_title);
		}
		
		/**
		 * Prepares the bitmap fonts for Starling text field
		 */
		protected function prepareBitmapFonts():void
		{
			var fontBitmap:Bitmap = new MainBitmapFont() as Bitmap;
			var fontTexture:Texture = Texture.fromBitmap(fontBitmap);
			var fontXMLdata:XML = XML(new MainBitmapFontXML());
			
			TextField.registerBitmapFont(new BitmapFont(fontTexture, fontXMLdata));
		}
		
		override protected function init(e:Event):void
		{
			super.init(e);
			
			trace(DEBUG_TAG, 'init()');
			
			// repositions label
			_title.y = 200;
			_title.x = (stage.stageWidth - _title.width) / 2;
		}
	}
}
