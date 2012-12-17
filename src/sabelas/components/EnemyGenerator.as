package sabelas.components
{
	/**
	 * Component for an entity which can generate enemy.
	 * For enemy spawn point. Best combined with position component!
	 *
	 * @author Abiyasa
	 */
	public class EnemyGenerator
	{
		public var numOfEnemyToGenerate:int;
		public var spawnRate:int;
		protected var _lastSpawnTime:Number;
		// TODO var for initial delay before first spawn
		// TODO num of emeies when spawn at a time
		
		public function EnemyGenerator(numOfEnemyToGenerate:int, spawnRate:int)
		{
			this.numOfEnemyToGenerate = numOfEnemyToGenerate;
			this.spawnRate = spawnRate;
			_lastSpawnTime = 0;
		}
		
		public function updateTime(time:Number):Number
		{
			_lastSpawnTime += time;
			return _lastSpawnTime;
		}
		
		public function isSpawnTime():Boolean
		{
			return (_lastSpawnTime >= this.spawnRate);
		}
		
		public function resetTime():void
		{
			_lastSpawnTime = 0;
		}
		
	}

}
