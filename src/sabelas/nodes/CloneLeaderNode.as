package sabelas.nodes
{
	import sabelas.components.CloneLeader;
	import sabelas.components.CloneMember;
	import sabelas.components.Collision;
	import sabelas.components.Energy;
	import sabelas.components.Motion;
	import sabelas.components.Position;
	import ash.core.Node;
	
	/**
	 * Node for clones component
	 * @author Abiyasa
	 */
	public class CloneLeaderNode extends Node
	{
		public var cloneLeader:CloneLeader;
		public var collision:Collision;
		public var position:Position;
		public var motion:Motion;
		public var energy:Energy;
	}

}
