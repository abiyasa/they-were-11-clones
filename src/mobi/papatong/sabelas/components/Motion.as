package mobi.papatong.sabelas.components
{
	import flash.geom.Point;
	
	/**
	 * Component for movement/motion data during game
	 * @author Abiyasa
	 */
	public class Motion
	{
		// movement angle, in radian. 0 means moving 'up'
		public var angle:Number;
		
		// current speed, moving towards the direction defined in angle
		public var speed:Number;
		
		public var maxSpeed:Number;
		
		// Additional force which will affect final speed
		public var forceX:Number;
		
		// Additional force which will affect final speed
		public var forceY:Number;
		
		public function Motion(angle:Number, speed:Number, maxSpeed:Number)
		{
			this.angle = angle;
			this.speed = speed;
			this.maxSpeed = maxSpeed;
			
			resetForce();
		}
		
		/**
		 * Reset force
		 */
		public function resetForce():void
		{
			forceX = 0.0;
			forceY = 0.0;
		}
		
		/**
		 * Calculate distance changes based on current speed, force, and given time
		 *
		 * @param	time
		 * @return The distance changes
		 */
		public function calculateDeltaX(time:Number):Number
		{
			return (Math.sin(angle) * speed * time) + forceX;
		}
		
		/**
		 * Calculate distance changes based on current speed, force, and given time
		 *
		 * @param	time
		 * @return The distance changes
		 */
		public function calculateDeltaY(time:Number):Number
		{
			return (Math.cos(angle) * speed * time) + forceY;
		}
	}

}
