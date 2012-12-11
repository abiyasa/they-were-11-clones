package sabelas.nodes
{
	import sabelas.components.HeroCloneControl;
	import ash.core.Node;
	import sabelas.components.Position;
	
	/**
	 * Node for controlling hero clones (adding or removing clones)
	 * @author Abiyasa
	 */
	public class HeroCloneControlNode extends Node
	{
		public var heroCloneControl:HeroCloneControl;
		public var position:Position;
	}

}
