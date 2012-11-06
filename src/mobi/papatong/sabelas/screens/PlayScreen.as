package mobi.papatong.sabelas.screens
{
	import flash.geom.Rectangle;
	import mobi.papatong.sabelas.configs.ScreenConfig;
	import mobi.papatong.sabelas.core.GameEngine;
	import mobi.papatong.sabelas.screens.ScreenWithDummyButtonBase;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	
	/**
	 * Where the magic happens
	 *
	 * @author Abiyasa
	 */
	public class PlayScreen extends ScreenWithDummyButtonBase
	{
		public static const DEBUG_TAG:String = 'PlayScreen';
		
		// The main game engine
		private var _gameEngine:GameEngine;
		
		/**
		 * Constructor
		 */
		public function PlayScreen()
		{
			super();
			
			createDummyButtons([
				{ label: 'quit', name: 'quit', screenEvent: ScreenConfig.SCREEN_MAIN_MENU }
			]);
		}
		
		override protected function init(e:Event):void
		{
			super.init(e);
			
			trace(DEBUG_TAG, 'init()');
			
			// re-position buttons
			ScreenUtils.layoutButtons(_dummyButtons, new Rectangle(0, 0,
				this.stage.stageWidth, this.stage.stageHeight), 5, 5, 'top', 'right');
				
			// init game engine
			_gameEngine = new GameEngine(this);
			_gameEngine.init();
			
			_gameEngine.start();
		}
		
		override protected function destroy(e:Event):void
		{
			trace(DEBUG_TAG, 'destroy()');
			
			// destroy game
			_gameEngine.stop();
			_gameEngine = null;
			
			super.destroy(e);
		}
	}
}
