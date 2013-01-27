package sabelas.components
{
	
	/**
	 * Component to make an entity damage proof
	 * @author Abiyasa
	 */
	public class DamageProof
	{
		private var _duration:Number;
		private var _timeElapsed:Number = 0.0;
		
		// TODO make as a separated component
		private var _blinkingRate:Number = 0.0;
		private var _blinkingTimer:Number = 0.0;
		
		/**
		 * Create damage proof component
		 * @param	duration in seconds
		 * @param	blinkingRate frequency/number of blinking rates in seconds
		 */
		public function DamageProof(duration:Number, blinkingRate:Number = 4)
		{
			_duration = duration;
			
			blinkingRate = _blinkingRate > 0 ? blinkingRate : 4;
			_blinkingRate = 1 / blinkingRate;
		}
		
		/**
		 * Update the time
		 *
		 * @param	time in seconds
		 */
		public function update(time:Number):void
		{
			_timeElapsed += time;
			_blinkingTimer += time;
		}
		
		/**
		 * Check if the lifetime of this component is over
		 * @return
		 */
		public function isTimeOver():Boolean
		{
			return (_timeElapsed >= _duration);
		}
		
		/**
		 * Check if it's time to blink
		 *
		 * @return
		 */
		public function isTimeToBlink():Boolean
		{
			return _blinkingTimer >= _blinkingRate;
		}
		
		/**
		 * Reset blinking time after blinking. Do this after
		 * isTimeToBlink() returns true
		 */
		public function resetBlinkingTime():void
		{
			_blinkingTimer = 0.0;
		}
	}

}
