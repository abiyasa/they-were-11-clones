package mobi.papatong.sabelas
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	/**
	 * The main Starling root application
	 */
	public class StarlingRootApplication extends Sprite
	{
		//private var _screenManager:ScreenManager;
		
		public function StarlingRootApplication()
		{
			addEventListener(Event.ADDED_TO_STAGE, start);
		}
		
		private function start(event:Event):void
		{
			/*
			_screenManager = new ScreenManager(this, ScreenConfig.getScreenMapping());
			_screenManager.start(ScreenConfig.SCREEN_MAIN_MENU);
			*/
			var text:TextField = new TextField(this.stage.stageWidth, this.stage.stageHeight,
				'Ohai :3', 'Tahoma, Geneva, sans-serif', 14, 0xcccccc, true);
			text.hAlign = 'center';
			this.addChild(text);
		}
	}
}
