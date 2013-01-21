package sabelas.components
{
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
		
		public function MapPoint(type:int)
		{
			this.type = type;
		}
		
	}

}
