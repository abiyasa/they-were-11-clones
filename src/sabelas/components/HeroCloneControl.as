package sabelas.components
{
	/**
	 * Component for controlling cloning actions via keyboard
	 *
	 * @author Abiyasa
	 */
	public class HeroCloneControl
	{
		public var keyAddClone:uint;
		public var cloneTriggered:Boolean;
		
		public function HeroCloneControl(keyAddClone:uint)
		{
			this.keyAddClone = keyAddClone;
			cloneTriggered = false;
		}
		
	}
}
