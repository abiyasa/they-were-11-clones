package mobi.papatong.sabelas.nodes
{
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.components.MouseControl;
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
	}

}
