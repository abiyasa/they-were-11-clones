package sabelas.nodes
{
	import sabelas.components.HeroClone;
	import sabelas.components.HeroCloneControl;
	import ash.core.Node;
	
	/**
	 * Node for controlling hero clones (adding or removing clones)
	 * @author Abiyasa
	 */
	public class HeroCloneControlNode extends Node
	{
		public var heroCloneControl:HeroCloneControl;
		public var heroClone:HeroClone;
	}

}
