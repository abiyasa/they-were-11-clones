package sabelas.components
{
	import ash.core.Entity;
	
	/**
	 * Component for entity which chase an entity
	 *
	 * @author Abiyasa
	 */
	public class DelayedEntityRemoval
	{
		private var _delayRemaining:Number;
		
		/**
		 *
		 * @param	time delayed removal in seconds!
		 */
		public function DelayedEntityRemoval(time:Number)
		{
			_delayRemaining = time;
		}
		
		/**
		 * Check if it's time to remove
		 * @return
		 */
		public function canRemove():Boolean
		{
			return _delayRemaining <= 0;
		}
		
		/**
		 * Update the delay remaining time
		 * @param	time
		 */
		public function updateTime(time:Number):void
		{
			_delayRemaining -= time;
		}
	}

}
