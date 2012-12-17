package sabelas.systems
{
	import ash.core.NodeList;
	import ash.core.System;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.EnemyGeneratorNode;
	
	/**
	 * System which process each enemy generator.
	 * Generates enemy based on ndoe data
	 * Will trigger game over when all enemy generator is done.
	 *
	 * @author Abiyasa
	 */
	public class EnemyGeneratorSystem extends System
	{
		private var _entityCreator:EntityCreator;
		private var _spawns:NodeList;
		
		public function EnemyGeneratorSystem(creator:EntityCreator)
		{
			super();
			_entityCreator = creator;
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_spawns = engine.getNodeList(EnemyGeneratorNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_spawns = null;
		}
		
		override public function update(time:Number):void
		{
			// TODO check head
				// TODO if head is null, generate game over
			// TODO update head time, check if it's time to generate enemy
			// TODO if so, generate enemy
			// TODO reduce spawn num of enemy to generate
			// TODO if spawn run out enemy, remove the node.entity
			
			// Note: no need to iterate the list. Just process the top most list (head)
		}
	}

}
