package sabelas.nodes
{
	import sabelas.components.CloneMember;
	import sabelas.components.Collision;
	import sabelas.components.Enemy;
	import sabelas.components.Energy;
	import sabelas.components.Motion;
	import sabelas.components.Position;
	import ash.core.Node;
	
	/**
	 * Node for enemy component
	 * @author Abiyasa
	 */
	public class EnemyNode extends Node
	{
		public var enemy:Enemy;
		public var collision:Collision;
		public var position:Position;
		public var motion:Motion;
		public var energy:Energy;
	}

}
