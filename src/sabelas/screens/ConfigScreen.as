package sabelas.screens
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import sabelas.configs.ScreenConfig;
	import sabelas.screens.ScreenWithButtonBase;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	
	/**
	 * Configuration/option screen
	 *
	 * @author Abiyasa
	 */
	public class ConfigScreen extends ScreenWithButtonBase
	{
		public static const DEBUG_TAG:String = 'ConfigScreen';
		
		protected var _mainTitle:TextField;
		protected var _subTitle:TextField;
		
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
			
			_mainTitle = new TextField(600, 50, 'They were 11 Clones', 'Ubuntu', 32, 0x534741, true);
			_mainTitle.fontSize = BitmapFont.NATIVE_SIZE;  // use defined bitmap font size
			//_mainTitle.color = Color.WHITE;  // use real color (white)
			_mainTitle.hAlign = 'center';
			_mainTitle.vAlign = 'top';
			_mainTitle.touchable = false;
			this.addChild(_mainTitle);
			
			// prepare sub title
			_subTitle = new TextField(600, 100, 'by\nAbiyasa (Papatong Mobi)\n2013', 'Ubuntu', 28, 0x534741, true);
			_subTitle.hAlign = 'center';
			_subTitle.vAlign = 'top';
			_subTitle.touchable = true;
			_subTitle.addEventListener(TouchEvent.TOUCH, onClickSubTitle);
			this.addChild(_subTitle);
		}
		
		override protected function init(e:Event):void
		{
			super.init(e);
			
			trace(DEBUG_TAG, 'init()');
			
			// repositions label
			_mainTitle.y = 100;
			_mainTitle.x = (stage.stageWidth - _mainTitle.width) / 2;
			_subTitle.y = _mainTitle.y + _mainTitle.height + 10;
			_subTitle.x = (stage.stageWidth - _subTitle.width) / 2;
		}
		
		protected function onClickSubTitle(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_subTitle, TouchPhase.ENDED);
			if (touch)
			{
				navigateToURL(new URLRequest('http://abiyasa.com/blog/'), '_blank');
			}
		}
	}
}
