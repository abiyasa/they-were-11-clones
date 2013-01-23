package sabelas.components
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	/**
	 * Component for a pinpoint on map.
	 * Will be shown on the compass
	 *
	 * @author Abiyasa
	 */
	public class MapPoint
	{
		public static const TYPE_CLONE_DEPOSIT:int = 10;
		
		public var type:int;
		
		// TODO should separate this into different component
		public var mapPin:DisplayObject;
		
		public function MapPoint(type:int)
		{
			this.type = type;
		}
		
	}

}
