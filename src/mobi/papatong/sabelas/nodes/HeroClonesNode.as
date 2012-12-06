package mobi.papatong.sabelas.nodes
{
	import mobi.papatong.sabelas.components.Collision;
	import mobi.papatong.sabelas.components.HeroClone;
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.Position;
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
