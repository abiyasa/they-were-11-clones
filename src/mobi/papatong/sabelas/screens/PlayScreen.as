package mobi.papatong.sabelas.screens
{
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import mobi.papatong.sabelas.configs.ScreenConfig;
	import mobi.papatong.sabelas.core.GameEngine;
	import mobi.papatong.sabelas.screens.ScreenWithButtonBase;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	/**
	 * Where the magic happens
	 *
	 * @author Abiyasa
	 */
	public class PlayScreen extends ScreenWithButtonBase
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
				{
					name: 'quit',
					label: 'quit',
					x: 600,
					y: 10,
					screenEvent: ScreenConfig.SCREEN_MAIN_MENU
				}
			]);
		}
		
		override protected function init(e:Event):void
		{
			super.init(e);
			
			trace(DEBUG_TAG, 'init()');
			
			// TODO re-position buttons dynamically
				
			// init game engine
			_gameEngine = new GameEngine(this);
			_gameEngine.init();
			
			_gameEngine.start();
			
			// add keyboard shortcut
			this.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyboard);
		}
		
		override protected function destroy(e:Event):void
		{
			trace(DEBUG_TAG, 'destroy()');
			
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyboard);
			
			// destroy game
			_gameEngine.stop();
			_gameEngine = null;
			
			super.destroy(e);
		}
		
		// Handles keyboard shortcut
		protected function handleKeyboard(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
			case Keyboard.ESCAPE:
				triggerButton('quit');
				break;
			}
		}
	}
}
