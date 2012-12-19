package sabelas.events
{
	import starling.events.Event;

	/**
	 * Event when the game is over
	 */
	public class GameOverEvent extends Event
	{
		public static const GAME_OVER:String = "gameOver";
		
		public function GameOverEvent(type:String)
		{
			super(type, false, null);
		}
	}
}
