package sabelas.nodes
{
	import sabelas.components.CloneDeposit;
	import sabelas.components.Collision;
	import sabelas.components.Position;
	import ash.core.Node;
	
	/**
	 * Node for clone deposit area
	 * @author Abiyasa
	 */
	public class CloneDepositNode extends Node
	{
		public var cloneDeposit:CloneDeposit;
		public var position:Position;
		public var collision:Collision;
	}

}
