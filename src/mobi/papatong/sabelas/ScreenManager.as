package mobi.papatong.sabelas
{
	import flash.utils.Dictionary;
	import starling.display.DisplayObjectContainer;
	import mobi.papatong.sabelas.events.ShowScreenEvent;
	import mobi.papatong.sabelas.screens.ScreenBase;
	
	/**
	 * For managing screens, including the game screen.
	 *
	 * @author Abiyasa
	 */
	public class ScreenManager
	{
		public static const DEBUG_TAG:String = 'ScreenManager';
		
		/** The main container, where we insert/remove screens */
		protected var _container:DisplayObjectContainer;
		
		/** screen name -> screen Class */
		protected var _screenMap:Dictionary;
		
		public function ScreenManager(container:DisplayObjectContainer, mapping:Dictionary = null)
		{
			super();
			_container = container;
			
			_screenMap = mapping;
		}
		
		/**
		 * Starts the screen manager, will immediately show the first screen
		 *
		 * @param	screenName the first screen
		 */
		public function start(screenName:String):void
		{
			showScreen(screenName);
		}
		
		/**
		 * Shows a specific screen
		 *
		 * @param	screenName
		 */
		protected function showScreen(screenName:String):void
		{
			if (canShowScreen(screenName))
			{
				// get the class
				var screenClass:Class = _screenMap[screenName] as Class;
				if (screenClass == null)
				{
					trace(DEBUG_TAG, 'Screen map for ' + screenName + ' is not a class');
					return;
				}
				
				// create the screen and show
				trace(DEBUG_TAG, 'creating screen for ' + screenName);
				var theScreen:ScreenBase = new screenClass();
				_container.addChild(theScreen);
				theScreen.addEventListener(ShowScreenEvent.SHOW_SCREEN, onChangeScreen);
			}
		}
		
		/**
		 * Checks if the screen details is available
		 * @param	screenName The screen name
		 * @param	returns true if screen is available
		 */
		protected function canShowScreen(screenName:String):Boolean
		{
			var tempResult:Boolean = false;
			if (_screenMap == null)
			{
				trace(DEBUG_TAG, 'Screen map is undefined. nothing to do');
			}
			else if (_screenMap.hasOwnProperty(screenName))
			{
				tempResult = true;
			}
			else
			{
				trace(DEBUG_TAG, 'no screenMap for ' + screenName);
			}
			
			return tempResult;
		}
		
		/**
		 * Handles the event generated from the current screen. Will trigger screen changes
		 *
		 * @param	e
		 */
		protected function onChangeScreen(e:ShowScreenEvent):void
		{
			var theScreen:ScreenBase = e.currentTarget as ScreenBase;
			if (theScreen == null)
			{
				trace(DEBUG_TAG, 'Error! no screen on onChangeScreen()');
				return;
			}
			
			// remove the screen and show the new one
			var newScreen:String = String(e.data);
			if (canShowScreen(newScreen))
			{
				// remove screen from container
				theScreen.removeEventListener(ShowScreenEvent.SHOW_SCREEN, onChangeScreen);
				_container.removeChild(theScreen);
				
				// show the next screen
				showScreen(newScreen);
			}
		}
	}

}
