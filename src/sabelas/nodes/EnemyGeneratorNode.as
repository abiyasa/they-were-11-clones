package sabelas.nodes
{
	import ash.core.Node;
	import sabelas.components.EnemyGenerator;
	import sabelas.components.Position;
	
	/**
	 * Node for enemy generator/spawn
	 * @author Abiyasa
	 */
	public class EnemyGeneratorNode extends Node
	{
		public var enemyGenerator:EnemyGenerator;
		public var position:Position;
	}

}
