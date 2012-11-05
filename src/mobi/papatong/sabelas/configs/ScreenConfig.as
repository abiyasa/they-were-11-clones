package mobi.papatong.sabelas.configs
{
	import flash.utils.Dictionary;
	import mobi.papatong.sabelas.screens.*;
	
	/**
	 * A static class which provide config and mappings
	 * @author Abiyasa
	 */
	public class ScreenConfig
	{
		public static const SCREEN_MAIN_MENU:String = 'mainMenu';
		
		/**
		 * Gets dictionary which is a mapping between screen name and screen class
		 *
		 * @return Object with key=screenName and value=screenClass
		 */
		public static function getScreenMapping():Dictionary
		{
			var tempObject:Dictionary = new Dictionary();
			tempObject[SCREEN_MAIN_MENU] = MainMenuScreen;
			/*
			tempObject[SCREEN_PLAY_GAME] = PlayScreen;
			tempObject[SCREEN_CONFIG] = ConfigScreen;
			*/
			
			return tempObject;
		}
	}

}
