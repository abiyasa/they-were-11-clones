package sabelas.events
{
	import starling.events.Event;

	/**
	 * Event for trigger changing screen
	 */
	public class ShowScreenEvent extends Event
	{
		public static const SHOW_SCREEN:String = "showScreen";
		
		public function ShowScreenEvent(type:String, screenName:String = null)
		{
			super(type, false, screenName);
		}
	}
}
