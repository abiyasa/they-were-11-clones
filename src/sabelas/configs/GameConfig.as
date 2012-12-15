package sabelas.configs
{
	import flash.geom.Rectangle;
	
	/**
	 * The game configuration
	 */
	public class GameConfig
	{
		public var width:Number;
		public var height:Number;
	
		public var arenaWidth:int;
		public var arenaHeight:int;
		public var arenePosX:int;
		public var arenaPosY:int;
		public var arenaRect:Rectangle;
		
		public function setArena(width:int, height:int, posX:int = 0, posY:int = 0):void
		{
			this.arenaWidth = width;
			this.arenaHeight = height;
			this.arenaRect = new Rectangle(posX - (width / 2), posY - (height / 2),
				width, height);
		}
	}
}
