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
		 * Tweening type
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
		
		/**
		 * To track the tweeing progress, in seconds!
		 */
		public var lastUpdateTime:Number;
		
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
			
			lastUpdateTime = 0.0;
		}
	}
}
