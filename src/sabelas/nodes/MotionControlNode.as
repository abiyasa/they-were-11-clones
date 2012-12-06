package sabelas.nodes
{
	import sabelas.components.Motion;
	import sabelas.components.MotionControl;
	import sabelas.components.Position;
	import ash.core.Node;
	
	/**
	 * Node for motion control, able to update object
	 * motion data based on the current input control data
	 *
	 * @author Abiyasa
	 */
	public class MotionControlNode extends Node
	{
		public var control:MotionControl;
		public var motion:Motion;
	}

}
