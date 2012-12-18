package sabelas.components
{
	/**
	 * Component for realtime Game status
	 *
	 * @author Abiyasa
	 */
	public class GameState
	{
		public static var STATE_INIT:int = 0;
		public static var STATE_LOADING:int = 10;
		public static var STATE_PLAY:int = 20;
		public static var STATE_GAME_OVER:int = 30;
		
		public var state:int = STATE_INIT;
		
		public var energy:int = 4;
		public var score:int = 0;
		public var numOfClones:int = 0;
		public var numOfSpawnedEnemies:int = 0;
		public var numOfDeadEnemies:int = 0;
	}
}
