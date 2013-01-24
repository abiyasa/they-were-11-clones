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
		public var enemyStock:int;
		public var spawnRate:Number;
		protected var _lastSpawnTime:Number;
		public var spawnRadius:int;
		public var spawnDelay:Number;
		public var spawnNumber:int;
		
		private var _delaying:Boolean;
		
		/**
		 * Constructor
		 *
		 * @param	enemyStock NUmber of enemy stock on this generator.
		 * Empty stock, means generator will be removed
		 * @param	spawnRate How often we spawn? in seconds
		 * @param	radius spawn radius
		 * @param	delay delay before spawn the first enemy, in seconds
		 * @param	spawnNumber the num of enemies spawn
		 */
		public function EnemyGenerator(enemyStock:int, spawnRate:Number, radius:int,
			delay:Number = 0, spawnNumber:int = 1)
		{
			this.enemyStock = enemyStock;
			this.spawnRate = spawnRate;
			this.spawnRadius = radius;
			this.spawnDelay = delay;
			this.spawnNumber = spawnNumber;
			
			_lastSpawnTime = 0;
			_delaying = true;
		}
		
		public function updateTime(time:Number):Number
		{
			_lastSpawnTime += time;
			
			if (_delaying)
			{
				_delaying = _lastSpawnTime < spawnDelay;
			}
			return _lastSpawnTime;
		}
		
		public function isSpawnTime():Boolean
		{
			return (_lastSpawnTime >= this.spawnRate) && (!_delaying);
		}
		
		public function resetTime():void
		{
			_lastSpawnTime = 0;
		}
		
	}

}
