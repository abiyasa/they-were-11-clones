package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import flash.geom.Point;
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
				// TODO need delay before next wave
				
				// no more spawn, generate more waves
				_entityCreator.generateEnemyWaves();
			}
			else
			{
				var enemySpawn:EnemyGenerator = enemySpawnNode.enemyGenerator;
				enemySpawn.updateTime(time);
				if (enemySpawn.isSpawnTime())
				{
					spawnEnemy(enemySpawnNode);
				}
			}
		}
		
		/**
		 * Spawn enemies based on the node
		 */
		private function spawnEnemy(spawnNode:EnemyGeneratorNode):void
		{
			var enemySpawn:EnemyGenerator = spawnNode.enemyGenerator;
			var numOfSpawns:int = enemySpawn.spawnNumber;
			for (var i:int = 0; i < numOfSpawns; i++)
			{
				// spawn enemy randomly inside the spawn radius
				var spawnPos:Point = spawnNode.position.position.clone();
				generateRandomSpawnPosition(spawnPos.x, spawnPos.y,
					spawnNode.enemyGenerator.spawnRadius, spawnPos);
				_entityCreator.createEnemy(spawnPos.x, spawnPos.y);
				
				enemySpawn.enemyStock--;
				if (enemySpawn.enemyStock <= 0)
				{
					// no more enemy to spawn, remove from game
					_entityCreator.destroyEntity(spawnNode.entity);
					
					// no more spawn
					break;
				}
				else  // still enemy to spawn
				{
					enemySpawn.resetTime();
				}
			}
		}
		
		/**
		 * Generates random spawn position inside the given radius
		 *
		 * @param	centerX radius center
		 * @param	centerY radius center
		 * @param	radius spawn radius, generated point should be inside the radius
		 * @param	output allocated point where the result will be assigned to
		 */
		private function generateRandomSpawnPosition(centerX:int, centerY:int,
			radius:int, output:Point):void
		{
			output.x = centerX + (radius - (Math.random() * radius * 2));
			output.y = centerY + (radius - (Math.random() * radius * 2));
		}
	}

}
