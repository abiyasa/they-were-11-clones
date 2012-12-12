package sabelas.nodes
{
	import sabelas.components.Gun;
	import sabelas.components.Position;
	import sabelas.components.MouseControl;
	import ash.core.Node;
	
	/**
	 * Node for motion control, able to update object
	 * motion data based on the current input control data
	 *
	 * @author Abiyasa
	 */
	public class MouseControlNode extends Node
	{
		public var position:Position;
		public var mouseControl:MouseControl;
		public var gun:Gun;
	}

}
