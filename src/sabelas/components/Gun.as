package sabelas.components
{
	import flash.geom.Point;
	
	/**
	 * Component for entity which can shoot
	 *
	 * @author Abiyasa
	 */
	public class Gun
	{
		protected var _shootTriggered:Boolean = false;
		protected var _timeSinceLastShot:Number = 0;
		protected var _minimumShotInterval:Number = 0;
		public var offsetFromParent:Point;
		public var bulletLifetime:Number = 0;
		
		public function Gun(offset:Point, minimumShotInterval:Number, bulletLifetime:Number)
		{
			offsetFromParent = offset.clone();
			this._minimumShotInterval = minimumShotInterval;
			this.bulletLifetime = bulletLifetime;
		}
		
		/**
		 * Trigger or untrigger shoot
		 *
		 * @param	trigger true means trigger shoot, while false means stop shooting
		 * @param	time frame time
		 */
		public function triggerShoot(triggered:Boolean, time:Number):void
		{
			// check if trigger status has changed
			if ((_shootTriggered != triggered))
			{
				_shootTriggered = triggered;
				
				if (triggered)
				{
					// immediately can shoot
					_timeSinceLastShot = _minimumShotInterval;
				}
				else
				{
					// release trigger will reset time
					resetTime();
				}
			}
			else if (triggered) // no changes in value
			{
				// have gap between shoot
				_timeSinceLastShot += time;
			}
		}
		
		/**
		 * Check if the gun is about time to shoot bullet
		 */
		public function isAllowedToShootBullet():Boolean
		{
			return _shootTriggered && (_timeSinceLastShot >= _minimumShotInterval);
		}
		
		/**
		 * Reset time, when bullet has been shoot
		 */
		public function resetTime():void
		{
			_timeSinceLastShot = 0;
		}
	}

}
