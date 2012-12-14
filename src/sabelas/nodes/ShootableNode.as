package sabelas.nodes
{
	import ash.core.Node;
	import sabelas.components.Collision;
	import sabelas.components.Position;
	import sabelas.components.Shootable;
	
	/**
	 * Node for shootable entity
	 * @author Abiyasa
	 */
	public class ShootableNode extends Node
	{
		public var shootable:Shootable;
		public var collision:Collision;
		public var position:Position;
	}

}
