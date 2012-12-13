package sabelas.components
{
	/**
	 * Component for controlling cloning actions via keyboard
	 *
	 * @author Abiyasa
	 */
	public class CloneControl
	{
		public var keyAddClone:uint;
		public var cloneTriggered:Boolean;
		
		public function CloneControl(keyAddClone:uint)
		{
			this.keyAddClone = keyAddClone;
			cloneTriggered = false;
		}
		
	}
}
