package sabelas.nodes
{
	import ash.core.Node;
	import sabelas.components.Chaser;
	import sabelas.components.Motion;
	import sabelas.components.Position;
	
	/**
	 * Node for chaser enemy which will update its position
	 * based on prey postion
	 *
	 * @author Abiyasa
	 */
	public class ChaserNode extends Node
	{
		public var chaser:Chaser;
		public var position:Position;
		public var motion:Motion;
	}

}
