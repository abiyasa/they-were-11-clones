package sabelas.nodes
{
	import sabelas.components.Collision;
	import sabelas.components.HeroClone;
	import sabelas.components.Motion;
	import sabelas.components.Position;
	import ash.core.Node;
	
	/**
	 * Node for hero clones component
	 * @author Abiyasa
	 */
	public class HeroClonesNode extends Node
	{
		public var heroClone:HeroClone;
		public var collision:Collision;
		public var position:Position;
		public var motion:Motion;
	}

}
