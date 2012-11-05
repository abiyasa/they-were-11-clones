package mobi.papatong.sabelas.screens
{
	import flash.utils.Dictionary;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * Base for screen classes
	 * @author Abiyasa
	 */
	public class ScreenBase extends Sprite
	{
		public static const DEBUG_TAG:String = 'ScreenBase';
		
		public function ScreenBase()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Initialize when added to stage
		 * @param	event
		 */
		protected function init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		/**
		 * Destroy when removed from stage
		 * @param	e
		 */
		protected function destroy(e:Event):void
		{
			this.removeEventListeners();
		}
	}
}
