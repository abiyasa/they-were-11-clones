package mobi.papatong.sabelas.screens
{
	import flash.geom.Rectangle;
	import mobi.papatong.sabelas.screens.ScreenWithDummyButtonBase;
	import mobi.papatong.sabelas.screens.ScreenUtils;
	import mobi.papatong.sabelas.configs.ScreenConfig;
	import starling.display.Button;
	import starling.events.Event;
	
	/**
	 * The main menu screen/View/Scene
	 * @author Abiyasa
	 */
	public class MainMenuScreen extends ScreenWithDummyButtonBase
	{
		public static const DEBUG_TAG:String = 'MainMenuScreen';
		
		public function MainMenuScreen()
		{
			super();
			
			createDummyButtons([
				{ label: 'start', name: 'start', screenEvent: ScreenConfig.SCREEN_PLAY_GAME },
				{ label: 'config', name: 'config', screenEvent: ScreenConfig.SCREEN_CONFIG }
			]);
		}
		
		override protected function init(event:Event):void
		{
			super.init(event);
			
			trace(DEBUG_TAG, 'init()');
			
			ScreenUtils.layoutButtons(_dummyButtons, new Rectangle(0, 100,
				this.stage.stageWidth, this.stage.stageHeight - 100), 5, 5, 'top', 'center');
		}
	
		override protected function destroy(e:Event):void
		{
			trace(DEBUG_TAG, 'destroy()');
			
			super.destroy(e);
		}
	}
}
