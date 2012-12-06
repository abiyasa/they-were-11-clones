package mobi.papatong.sabelas.screens
{
	import flash.geom.Rectangle;
	import mobi.papatong.sabelas.configs.ScreenConfig;
	import mobi.papatong.sabelas.screens.ScreenWithDummyButtonBase;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * Configuration/option screen
	 *
	 * @author Abiyasa
	 */
	public class ConfigScreen extends ScreenWithDummyButtonBase
	{
		public static const DEBUG_TAG:String = 'ConfigScreen';
		
		protected var _title:TextField;
		
		/**
		 * Constructor
		 */
		public function ConfigScreen()
		{
			super();
			
			createDummyButtons([
				{ label: 'back to menu', name: 'back', screenEvent: ScreenConfig.SCREEN_MAIN_MENU }
			]);
			
			_title = new TextField(200, 100, 'Config Screen', 'Tahoma, Geneva, sans-serif', 14, 0xcccccc, true);
			_title.hAlign = 'center';
			_title.vAlign = 'top';
			_title.touchable = false;
			this.addChild(_title);
		}
		
		override protected function init(e:Event):void
		{
			super.init(e);
			
			trace(DEBUG_TAG, 'init()');
			
			// re-position buttons
			ScreenUtils.layoutButtons(_dummyButtons, new Rectangle(0, 0,
				this.stage.stageWidth, this.stage.stageHeight), 5, 5, 'top', 'right');
				
			// repositions label
			_title.y = 5;
			_title.x = (stage.stageWidth - _title.width) / 2;
		}
	}
}
