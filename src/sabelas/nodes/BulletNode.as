package sabelas.nodes
{
	import ash.core.Node;
	import sabelas.components.Bullet;
	import sabelas.components.Collision;
	import sabelas.components.Position;
	
	/**
	 * Node for processing bullet component
	 * @author Abiyasa
	 */
	public class BulletNode extends Node
	{
		public var bullet:Bullet;
		public var collision:Collision;
		public var position:Position;
	}

}
