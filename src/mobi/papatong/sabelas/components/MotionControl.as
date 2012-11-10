package mobi.papatong.sabelas.components
{
	/**
	 * Component for controlling motion via keyboard
	 *
	 * @author Abiyasa
	 */
	public class MotionControl
	{
		public var keyMoveUp:uint;
		public var keyMoveLeft:uint;
		public var keyMoveRight:uint;
		public var keyMoveDown:uint;
		public var speed:int;
		
		public function MotionControl(keyMoveUp:uint, keyMoveLeft:uint, keyMoveRight:uint,
			keyMoveDown:uint, speed:int)
		{
			this.keyMoveUp = keyMoveUp;
			this.keyMoveLeft = keyMoveLeft;
			this.keyMoveRight = keyMoveRight;
			this.keyMoveDown = keyMoveDown;
			this.speed = speed;
		}
		
	}
}
