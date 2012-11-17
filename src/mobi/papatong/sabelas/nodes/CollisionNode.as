package mobi.papatong.sabelas.nodes
{
	import mobi.papatong.sabelas.components.Collision;
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.Position;
	import net.richardlord.ash.core.Node;
	
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
