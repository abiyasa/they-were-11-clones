package sabelas.core
{
	import away3d.containers.ObjectContainer3D;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import sabelas.components.Arena;
	import sabelas.components.Bullet;
	import sabelas.components.Chaser;
	import sabelas.components.CloneDeposit;
	import sabelas.components.Enemy;
	import sabelas.components.EnemyGenerator;
	import sabelas.components.Energy;
	import sabelas.components.StalkingCamera;
	import sabelas.components.CloneLeader;
	import sabelas.components.CloneMember;
	import sabelas.components.CollidingObject;
	import sabelas.components.Collision;
	import sabelas.components.Display3D;
	import sabelas.components.GameState;
	import sabelas.components.Gun;
	import sabelas.components.Motion;
	import sabelas.components.MotionControl;
	import sabelas.components.MouseControl;
	import sabelas.components.Position;
	import sabelas.components.Display;
	import sabelas.components.Shootable;
	import sabelas.configs.GameConfig;
	import sabelas.graphics.AssetManager;
	import sabelas.graphics.BlockyPeople;
	import sabelas.graphics.DummyQuadView;
	import sabelas.graphics.DummySphere;
	import ash.core.Entity;
	import ash.core.Engine;
	
	/**
	 * Creator or destroyer entites during game play
	 *
	 * @author Abiyasa
	 */
	public class EntityCreator extends EventDispatcher
	{
		private var _engine:Engine;
		
		private var _config:GameConfig;
		
		private var _gameState:GameState;
		
		// for loading 3D assets
		private var _assetManager:AssetManager;
		
		// our main hero
		private var _mainHero:Entity;
		private var _mainHeroPosition:Position;
		
		// flag to indicate assets has been loaded
		private var _assetsLoaded:Boolean;
		public function get assetsLoaded():Boolean { return _assetsLoaded; }
		
		public static const PEOPLE_DUMMY:int = 0;
		public static const PEOPLE_ENEMY:int = 10;
		public static const PEOPLE_HERO:int = 20;
		public static const PEOPLE_HERO_LEADER:int = 21;
		
		public function EntityCreator(engine:Engine, config:GameConfig)
		{
			_engine = engine;
			_config = config;
			_mainHero = null;
		}
		
		/**
		 * Init entity creator before use.
		 * Will dispatch event Event.COMPLETE
		 */
		public function initAssets():void
		{
			_assetsLoaded = false;
			_assetManager = new AssetManager();
			_assetManager.addEventListener(Event.COMPLETE, onCompleteAssets, false, 0, true);
			_assetManager.init();
		}
		
		protected function onCompleteAssets(event:Event):void
		{
			_assetManager.removeEventListener(Event.COMPLETE, onCompleteAssets);
			_assetsLoaded = true;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function destroy():void
		{
			if (_assetManager != null)
			{
				_assetManager.destroy();
			}
			_mainHero = null;
		}
		
		public function destroyEntity(entity:Entity):void
		{
			_engine.removeEntity(entity);
		}
		
		/**
		 * Create game state entity
		 * @return
		 */
		public function createGameState():Entity
		{
			_gameState = new GameState();
			var gameEntity:Entity = new Entity()
				.add(_gameState);
			_engine.addEntity(gameEntity);
			
			return gameEntity;
		}
		
		/**
		 * Internal function to create blocky people
		 *
		 * @param	x position
		 * @param	y position
		 * @param	peopleCode enemy or hero
		 * @return
		 */
		protected function createBlockyPeople(x:int, y:int, peopleCode:int):Entity
		{
			var blockyPeople:Entity = new Entity();
				
			switch (peopleCode)
			{
			case PEOPLE_HERO_LEADER:
				if (_mainHero != null)
				{
					return null;
				}
				_mainHero = blockyPeople;
				_mainHeroPosition = new Position(x, y, 0);

				blockyPeople
					.add(_mainHeroPosition)
					.add(new Energy(_gameState.energy))
					.add(new CloneLeader())
					.add(new MotionControl(Keyboard.W, Keyboard.A, Keyboard.D, Keyboard.S))
					.add(new Motion(0, 0, 200))
					.add(new Collision(50))
					.add(new CollidingObject(CollidingObject.TYPE_MAIN_HERO))
					.add(new Display3D(_assetManager.createBlockyPeople( { type : 0 } )))
					.add(new MouseControl())
					.add(new Gun(new Point(8, 0), 0.3, 3));
				break;
				
			case PEOPLE_HERO:
				blockyPeople
					.add(new Energy(1))
					.add(new Position(x, y, 0))
					.add(new CloneMember(_mainHero))
					.add(new Motion(0, 0, 200))
					.add(new Collision(50))
					.add(new CollidingObject(CollidingObject.TYPE_HERO_CLONES))
					.add(new Display3D(_assetManager.createBlockyPeople({ type : 1 })));
				break;
			
			case PEOPLE_ENEMY:
			default:
				blockyPeople
					.add(new Enemy())
					.add(new Energy(1))
					.add(new Position(x, y, 0))
					.add(new Motion(0, 0, 100))
					.add(new Collision(50))
					.add(new CollidingObject(CollidingObject.TYPE_ENEMY))
					.add(new Shootable(Bullet.BULLET_TYPE_HERO))
					.add(new Chaser(_mainHeroPosition))
					.add(new Display3D(_assetManager.createBlockyPeople({ type : 2 })));
				break;
			}
			
			_engine.addEntity(blockyPeople);
			
			return blockyPeople;
		}
		
		/**
		 * Create the main hero or its clone
		 * @param	x position
		 * @param	y position
		 */
		public function createHero(x:int, y:int, isClone:Boolean = false):void
		{
			createBlockyPeople(x, y, isClone ? PEOPLE_HERO : PEOPLE_HERO_LEADER);
		}
		
		/**
		 * Create enemy
		 * @param	x position
		 * @param	y position
		 */
		public function createEnemy(x:int, y:int, enemyType:int = 0):void
		{
			createBlockyPeople(x, y, PEOPLE_ENEMY);
		}
		
		/**
		 * Create a bullet
		 *
		 * @param	gun
		 * @param	parentPosition
		 */
		public function createBullet(gun:Gun, parentPosition:Position, shooter:int):Entity
		{
			var parentRotation:Number = parentPosition.rotation;
			var bulletType:int = (shooter == PEOPLE_ENEMY) ? 2 : 0;
			
			var bullet:Entity = new Entity()
				.add(new Bullet(shooter == PEOPLE_ENEMY ? Bullet.BULLET_TYPE_ENEMY : Bullet.BULLET_TYPE_HERO,
					gun.bulletLifetime))
				.add(new Position(parentPosition.position.x, parentPosition.position.y, parentRotation))
				.add(new Collision(10))
				.add(new Motion(parentRotation, 800, 800))
				.add(new Display3D(_assetManager.createBullet({ type : bulletType })));
				
			_engine.addEntity(bullet);
			return bullet;
		}
		
		/**
		 * Creates basic stage/arena
		 * @return
		 */
		public function createArena():Entity
		{
			// special position
			var arenaPosition:Position = new Position(_config.arenePosX, _config.arenaPosY, 0);
			arenaPosition.height = -1;
			
			// create
			var arena:Entity = new Entity()
				.add(new Arena(_config.arenaWidth, _config.arenaHeight,
					_config.arenePosX, _config.arenaPosY))
				.add(arenaPosition)
				.add(new Display3D(_assetManager.createArenaPlane({
					width: _config.arenaWidth,
					height: _config.arenaHeight
				})));
				
			_engine.addEntity(arena);
			return arena;
		}
		
		/**
		 * Create camera entity.
		 * Make sure that hero entity has been created before
		 *
		 * @param followHero if true, camera will look at hero's position
		 * @return
		 */
		public function createStalkingCamera():Entity
		{
			// make sure main hero is created
			if (_mainHero == null)
			{
				throw new Error('Stalking camera needs main hero to be created first!');
				return null;
			}
			
			// prepare camera
			var camera:Entity = new Entity()
				.add(new StalkingCamera(0, 1000, -1000, _mainHeroPosition));
				
			_engine.addEntity(camera);
			return camera;
		}
		
		public static const SPAWN_RADIUS:int = 600;
		public static const ARENA_SPAWN_PADDING:int = 200;
		
		/**
		 * WIll generate several enemy spawn areas based on wave level
		 */
		public function generateEnemyWaves():void
		{
			var arenaRect:Rectangle = _config.arenaRect;
			
			var waveLevel:int = _gameState.waveLevel;
			var numOfSpawns:int = 3 + (2 * waveLevel);
			
			// add enemy spawners
			while (numOfSpawns >= 0)
			{
				numOfSpawns--;
				
				// generate random area
				var randX:int = arenaRect.left + ARENA_SPAWN_PADDING +
					(Math.random() * (arenaRect.width - SPAWN_RADIUS - ARENA_SPAWN_PADDING - ARENA_SPAWN_PADDING));
				var randY:int = arenaRect.top + ARENA_SPAWN_PADDING +
					(Math.random() * (arenaRect.height - SPAWN_RADIUS - ARENA_SPAWN_PADDING - ARENA_SPAWN_PADDING));
				
				// enemy stock increase along with the level
				var enemyStock:int = 4 + (waveLevel / 3);
				if (spawnNumber > 20)
				{
					spawnNumber = 20;
				}
				
				// generate spawn rate, the higher level, the faster
				var spawnRate:Number = 1.0 - (0.15 * waveLevel);
				if (spawnRate < 0.2)
				{
					spawnRate = 0.2;
				}
				
				// generate random spawn rate num, the higher level, the larger
				var spawnNumber:int = 1 + (waveLevel / 3);
				if (spawnNumber > 5)
				{
					spawnNumber = 5;
				}
				
				trace('generating enemy spawn at ' + randX + ',' + randY);
				createEnemySpawn(randX, randY, enemyStock, spawnRate, 0.0, spawnNumber);
			}
				
			// increase level, so it will be harder next time
			_gameState.waveLevel++;
		}
		
		/**
		 * Creates an enemy generator
		 * @param	x
		 * @param	y
		 * @param	numOfEnemies
		 * @param	spawnRate
		 * @return
		 */
		protected function createEnemySpawn(x:int, y:int, numOfEnemies:int, spawnRate:Number, spawnDelay:Number, spawnNum:int):Entity
		{
			var spawn:Entity = new Entity()
				.add(new EnemyGenerator(numOfEnemies, spawnRate, 400, spawnDelay, spawnNum))
				.add(new Position(x, y, 0))
				.add(new Display3D(_assetManager.createSpawnPlane({
					width: SPAWN_RADIUS * 2,
					height: SPAWN_RADIUS * 2,
					color: 0xcccccc
				})));
			
			_engine.addEntity(spawn);
			return spawn;
		}
		
		/**
		 * Creates a clone deposit
		 * @param	x position
		 * @param	y position
		 * @param	clonesRequired NUmber of clones required to deposit
		 * @return
		 */
		public function createCloneDeposit(x:int, y:int, clonesRequired:int):Entity
		{
			var deposit:Entity = new Entity()
				.add(new CloneDeposit(clonesRequired))
				.add(new Position(x, y, 0))
				.add(new Collision(SPAWN_RADIUS))
				.add(new Display3D(_assetManager.createArenaPlane({
					width: SPAWN_RADIUS * 2,
					height: SPAWN_RADIUS * 2,
					color: 0x009eef
				})));
			
			_engine.addEntity(deposit);
			return deposit;
		}
	}
	
}
