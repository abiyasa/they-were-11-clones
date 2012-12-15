package sabelas.core
{
	import away3d.containers.ObjectContainer3D;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import sabelas.components.Arena;
	import sabelas.components.Bullet;
	import sabelas.components.CloneLeader;
	import sabelas.components.CloneMember;
	import sabelas.components.CollidingObject;
	import sabelas.components.Collision;
	import sabelas.components.Display3D;
	import sabelas.components.GameState;
	import sabelas.components.Gun;
	import sabelas.components.CloneControl;
	import sabelas.components.Motion;
	import sabelas.components.MotionControl;
	import sabelas.components.MouseControl;
	import sabelas.components.Position;
	import sabelas.components.Display;
	import sabelas.components.Shootable;
	import sabelas.components.SpinningMotion;
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
		
		// for loading 3D assets
		private var _assetManager:AssetManager;
		
		// our main hero
		private var _mainHero:Entity;
		
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
			var gameEntity:Entity = new Entity()
				.add(new GameState());
			_engine.addEntity(gameEntity);
			
			return gameEntity;
		}
		
		/**
		 * Creates a dummy quad to test if the game system works
		 *
		 * @param	size Quad size
		 * @param	x Quad position
		 * @param	y Quad position
		 * @return
		 */
		public function createDummyQuad(size:int, x:int, y:int):Entity
		{
			var dummyQuad:Entity = new Entity()
				.add(new Position(x, y, 0))
				.add(new SpinningMotion(Math.PI * 0.5))
				.add(new Display(new DummyQuadView(size)));
			_engine.addEntity(dummyQuad);
			
			return dummyQuad;
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

				blockyPeople
					.add(new Position(x, y, 0))
					.add(new CloneLeader())
					.add(new MotionControl(Keyboard.W, Keyboard.A, Keyboard.D, Keyboard.S))
					.add(new Motion(0, 0, 200))
					.add(new Collision(50))
					.add(new CollidingObject())
					.add(new Display3D(_assetManager.createBlockyPeople( { type : 0 } )))
					.add(new CloneControl(Keyboard.SPACE))
					.add(new MouseControl())
					.add(new Gun(new Point(8, 0), 0.3, 3));
				break;
				
			case PEOPLE_HERO:
				blockyPeople
					.add(new Position(x, y, 0))
					.add(new CloneMember(_mainHero))
					.add(new Motion(0, 0, 200))
					.add(new Collision(50))
					.add(new CollidingObject())
					.add(new Display3D(_assetManager.createBlockyPeople({ type : 1 })));
				break;
			
			case PEOPLE_ENEMY:
			default:
				blockyPeople
					.add(new Position(x, y, 0))
					.add(new Motion(0, 0, 200))
					.add(new Collision(50))
					.add(new CollidingObject())
					.add(new Shootable(Bullet.BULLET_TYPE_HERO))
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
			// create
			var arena:Entity = new Entity()
				.add(new Arena(_config.arenaWidth, _config.arenaHeight,
					_config.arenePosX, _config.arenaPosY))
				.add(new Position(_config.arenePosX, _config.arenaPosY, 0))
				.add(new Display3D(_assetManager.createArenaPlane({
					width: _config.arenaWidth,
					height: _config.arenaHeight,
					color: 0xfefefe
				})));
				
			_engine.addEntity(arena);
			return arena;
		}
	}
	
}
