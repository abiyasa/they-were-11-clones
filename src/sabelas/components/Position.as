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
		
		// special variable for 'z' coordinate (for shadow or jumping enemies)
		private var _height:Number = 0;
		public function get height():Number
		{
			return _height;
		}
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			_height = value;
			if (!_hasHeight)
			{
				_hasHeight = true;
			}
		}
		
		// check if position have height value
		private var _hasHeight:Boolean = false;
		public function get hasHeight():Boolean
		{
			return _hasHeight;
		}
		
		public function Position(x:int, y:int, rotation:Number)
		{
			position = new Point(x, y);
			this.rotation = rotation;
		}
		
	}

}
