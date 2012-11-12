package mobi.papatong.sabelas.nodes
{
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.MotionControl;
	import mobi.papatong.sabelas.components.Position;
	import net.richardlord.ash.core.Node;
	
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
