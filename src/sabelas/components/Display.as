package mobi.papatong.sabelas.components
{
	import starling.display.DisplayObject;
	
	/**
	 * Component for displayable object
	 *
	 * @author Abiyasa
	 */
	public class Display
	{
		public var displayObject:DisplayObject = null;
		
		public function Display(displayObject:DisplayObject)
		{
			this.displayObject = displayObject;
		}
	}
}
