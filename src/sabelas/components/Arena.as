package sabelas.components
{
	import flash.geom.Rectangle;
	
	/**
	 * Component for the arena
	 * @author Abiyasa
	 */
	public class Arena
	{
		public var width:int;
		public var height:int;
		public var posX:int;
		public var posY:int;
		public var arenaRect:Rectangle;
		
		public function Arena(width:int, height:int, posX:int = 0, posY:int = 0)
		{
			this.width = width;
			this.height = height;
			arenaRect = new Rectangle(posX - (width / 2), posY - (height / 2),
				width, height);
		}
		
	}

}