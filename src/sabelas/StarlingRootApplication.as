package sabelas
{
	import sabelas.configs.ScreenConfig
	import sabelas.ScreenManager;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	/**
	 * The main Starling root application
	 */
	public class StarlingRootApplication extends Sprite
	{
		private var _screenManager:ScreenManager;
		
		public function StarlingRootApplication()
		{
			addEventListener(Event.ADDED_TO_STAGE, start);
		}
		
		private function start(event:Event):void
		{
			_screenManager = new ScreenManager(this, ScreenConfig.getScreenMapping());
			_screenManager.start(ScreenConfig.SCREEN_MAIN_MENU);
		}
	}
}
