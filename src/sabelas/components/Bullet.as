package sabelas.components
{
	/**
	 * Marker component for a bullet
	 * @author Abiyasa
	 */
	public class Bullet
	{
		public static const BULLET_TYPE_ANY:int = 0;
		public static const BULLET_TYPE_HERO:int = 10;
		public static const BULLET_TYPE_ENEMY:int = 10;
		
		public var lifeRemaining:Number;
		public var type:int;
		
		public function Bullet(type:int, lifeTime:Number)
		{
			lifeRemaining = lifeTime;
			this.type = type;
		}
		
	}

}
