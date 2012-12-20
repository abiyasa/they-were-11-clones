package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import sabelas.components.EnemyGenerator;
	import sabelas.components.Position;
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
			// only check head
			var enemySpawnNode:EnemyGeneratorNode = _spawns.head;
			if (enemySpawnNode == null)
			{
				// TODO need delay?
				
				// no more spawn, generate more waves
				_entityCreator.generateEnemyWaves();
			}
			else
			{
				var enemySpawn:EnemyGenerator = enemySpawnNode.enemyGenerator;
				enemySpawn.updateTime(time);
				if (enemySpawn.isSpawnTime())
				{
					// TODO handle spawn number
					// TODO generate random pos inside the spawn radius
					// spawn enemy
					var spawnPos:Position = enemySpawnNode.position;
					_entityCreator.createEnemy(spawnPos.position.x, spawnPos.position.y);
					
					enemySpawn.enemyStock--;
					if (enemySpawn.enemyStock <= 0)
					{
						// no more enemy to spawn, remove from game
						_entityCreator.destroyEntity(enemySpawnNode.entity);
					}
					else  // still enemy to spawn
					{
						enemySpawn.resetTime();
					}
				}
			}
		}
	}

}
