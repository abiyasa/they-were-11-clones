package mobi.papatong.sabelas.components
{
	import flash.geom.Point;
	
	/**
	 * Component for movement/motion data during game
	 * @author Abiyasa
	 */
	public class Motion
	{
		public var velocity:Point = new Point();
		public var maxSpeed:Number;
		
		public function Motion(speedX:Number, speedY:Number, maxSpeed:Number)
		{
			velocity.x = speedX;
			velocity.y = speedY;
			this.maxSpeed = maxSpeed;
		}
	}

}
