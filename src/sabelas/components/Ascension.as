package sabelas.components
{
	/**
	 * Component for ascending entity.
	 * @author Abiyasa
	 */
	public class Ascension
	{
		public var ascendingMaxSpeed:Number;
		public var ascendingSpeed:Number;
		public var ascendingAcceleration:Number;
		
		public function Ascension(maxSpeed:Number, acceleration:Number)
		{
			this.ascendingMaxSpeed = maxSpeed;
			this.ascendingAcceleration = acceleration;
			
			this.ascendingSpeed = 0.0;
		}
		
	}

}
