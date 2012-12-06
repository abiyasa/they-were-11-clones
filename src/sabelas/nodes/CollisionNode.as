package sabelas.nodes
{
	import sabelas.components.Collision;
	import sabelas.components.Motion;
	import sabelas.components.Position;
	import ash.core.Node;
	
	/**
	 * Node for collision component
	 * @author Abiyasa
	 */
	public class CollisionNode extends Node
	{
		public var motion:Motion;
		public var collision:Collision;
		public var position:Position;
	}

}
