package sabelas.components
{
	/**
	 * A marker component for an object which will collide with other entity while moving.
	 *
	 * @author Abiyasa
	 */
	public class CollidingObject
	{
		public var type:int;
		public static const TYPE_NON_MOVING_OBJECT:int = 0;
		public static const TYPE_MAIN_HERO:int = 10;
		public static const TYPE_HERO_CLONES:int = 20;
		public static const TYPE_ENEMY:int = 30;
		
		
		public function CollidingObject(type:int)
		{
			this.type = type;
		}
		
	}

}
