package sabelas.components
{
	import flash.geom.Point;
	
	/**
	 * Position and rotation
	 * @author Abiyasa
	 */
	public class Position
	{
		public var position:Point;
		public var rotation:Number = 0;
		
		public function Position(x:int, y:int, rotation:Number)
		{
			position = new Point(x, y);
			this.rotation = rotation;
		}
	}

}
