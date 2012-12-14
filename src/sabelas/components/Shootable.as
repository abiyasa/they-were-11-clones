package sabelas.components
{
	/**
	 * A component to mark this entity is shootable by a certain type of bullet
	 * @author Abiyasa
	 */
	public class Shootable
	{
		public var bulletType:int;
		
		public function Shootable(bulletType:int)
		{
			this.bulletType = bulletType;
		}
		
	}

}
