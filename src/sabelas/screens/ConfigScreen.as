package sabelas.screens
{
	import flash.geom.Rectangle;
	import sabelas.configs.ScreenConfig;
	import sabelas.screens.ScreenWithButtonBase;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * Configuration/option screen
	 *
	 * @author Abiyasa
	 */
	public class ConfigScreen extends ScreenWithButtonBase
	{
		public static const DEBUG_TAG:String = 'ConfigScreen';
		
		protected var _title:TextField;
		
		/**
		 * Constructor
		 */
		public function ConfigScreen()
		{
			super();
			
			createButtons([
				{
					name: 'back',
					textureName: 'button_back',
					x: 640 - 5 - 41,
					y: 5,
					screenEvent: ScreenConfig.SCREEN_MAIN_MENU
				}
				
			]);
			
			_title = new TextField(400, 400, 'They were 11 Clones', 'Tahoma, Geneva, sans-serif', 18, 0x534741, true);
			_title.text = 'They were 11 Clones\nby Abiyasa (Papatong Mobi)\n2012'
			_title.hAlign = 'center';
			_title.vAlign = 'top';
			_title.touchable = false;
			this.addChild(_title);
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
