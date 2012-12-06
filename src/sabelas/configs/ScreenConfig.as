package sabelas.configs
{
	import flash.utils.Dictionary;
	import sabelas.screens.*;
	
	/**
	 * A static class which provide config and mappings
	 * @author Abiyasa
	 */
	public class ScreenConfig
	{
		public static const SCREEN_MAIN_MENU:String = 'mainMenu';
		public static const SCREEN_PLAY_GAME:String = 'playGame';
		public static const SCREEN_CONFIG:String = 'config';
		
		/**
		 * Gets dictionary which is a mapping between screen name and screen class
		 *
		 * @return Object with key=screenName and value=screenClass
		 */
		public static function getScreenMapping():Dictionary
		{
			var tempObject:Dictionary = new Dictionary();
			tempObject[SCREEN_MAIN_MENU] = MainMenuScreen;
			tempObject[SCREEN_CONFIG] = ConfigScreen;
			tempObject[SCREEN_PLAY_GAME] = PlayScreen;
			
			return tempObject;
		}
	}

}
