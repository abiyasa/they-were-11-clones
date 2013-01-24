package sabelas.components
{
	import away3d.containers.ObjectContainer3D;
	
	/**
	 * Simple component for tweening Display3D component
	 *
	 * @author Abiyasa
	 */
	public class Tween3D
	{
		public static const TYPE_SCALE:int = 0;
		
		private var _type:int;
		
		/**
		 * Tweening type, define which parameter to tween
		 */
		public function get type():int { return _type; }
		
		private var _fromValue:Number;
		public function get fromValue():Number { return _fromValue; }
		
		private var _toValue:Number;
		public function get toValue():Number { return _toValue; }
		
		private var _duration:Number;
		
		/**
		 * Tween duration, in seconds!
		 */
		public function get duration():Number { return _duration; }
		
		// store 1 / _duration, changing division into multiplication
		private var _duration_1:Number;
		
		/**
		 * To track the tweeing progress, in seconds!
		 */
		private var _lastUpdateTime:Number;
		
		private var _progressPercentage:Number;
		
		/**
		 * The tween progress in percentage, based on
		 * the duration & last updated time
		 *
		 * 1.0 means tween is completed
		 */
		public function get progressPercentage():Number { return _progressPercentage; }
		
		// distance between toValue & fromValue
		private var _distance:Number;
		
		/**
		 *
		 * @param	config An object with following properties:
		 * - type
		 * - fromValue
		 * - toValue
		 * - duration
		 */
		public function Tween3D(config:Object)
		{
			_type = config.hasOwnProperty('type') ? config['type'] : TYPE_SCALE;
			
			_fromValue = config.hasOwnProperty('fromValue') ? config['fromValue'] : 0.0;
			_toValue = config.hasOwnProperty('toValue') ? config['toValue'] : 0.0;
			
			_duration = config.hasOwnProperty('duration') ? config['duration'] : 0.25;
			if (_duration < 0.0)
			{
				_duration = 0.25;
			}
			
			_distance = _toValue - _fromValue;
			_duration_1 = 1 / _duration;
			_lastUpdateTime = 0.0;
			_progressPercentage = 0.0;
		}
		
		/**
		 * Update the Tween time, for tracking the Tween progress
		 *
		 * @param	deltaTime in seconds
		 */
		public function updateTime(deltaTime:Number):void
		{
			_lastUpdateTime += deltaTime;
			_progressPercentage = _lastUpdateTime * _duration_1;
		}
		
		/**
		 * Calculate the Tween value based on the current last update time &
		 * progress
		 * @return
		 */
		public function calculateTween():Number
		{
			return _fromValue + (_progressPercentage * _distance);
		}
	}
}
