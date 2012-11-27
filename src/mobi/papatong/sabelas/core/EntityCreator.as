package mobi.papatong.sabelas.core
{
	import away3d.containers.ObjectContainer3D;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import mobi.papatong.sabelas.components.Collision;
	import mobi.papatong.sabelas.components.Display3D;
	import mobi.papatong.sabelas.components.GameState;
	import mobi.papatong.sabelas.components.HeroClone;
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.MotionControl;
	import mobi.papatong.sabelas.components.MouseControl;
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.components.Display;
	import mobi.papatong.sabelas.components.SpinningMotion;
	import mobi.papatong.sabelas.graphics.AssetManager;
	import mobi.papatong.sabelas.graphics.BlockyPeople;
	import mobi.papatong.sabelas.graphics.DummyQuadView;
	import mobi.papatong.sabelas.graphics.DummySphere;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	
	/**
	 * Creator or destroyer entites during game play
	 *
	 * @author Abiyasa
	 */
	public class EntityCreator extends EventDispatcher
	{
		private var _game:Game;
		
		// list of enemies
		private var _enemyGroup:Array = [];
	
		// for loading 3D assets
		private var _assetManager:AssetManager;
		
		// flag to indicate assets has been loaded
		private var _assetsLoaded:Boolean;
		public function get assetsLoaded():Boolean { return _assetsLoaded; }
		
		public static const PEOPLE_DUMMY:int = 0;
		public static const PEOPLE_ENEMY:int = 10;
		public static const PEOPLE_HERO:int = 20;
		public static const PEOPLE_HERO_LEADER:int = 21;
		
		public function EntityCreator(game:Game)
		{
			_game = game;
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
		}
		
		public function destroyEntity(entity:Entity):void
		{
			_game.removeEntity(entity);
		}
		
		/**
		 * Create game state entity
		 * @return
		 */
		public function createGameState():Entity
		{
			var gameEntity:Entity = new Entity()
				.add(new GameState());
			_game.addEntity(gameEntity);
			
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
			_game.addEntity(dummyQuad);
			
			return dummyQuad;
		}
		
		/**
		 * Creates a dummy 3D sphere to test if the game system works
		 *
		 * @param	size sphere radius
		 * @param	x cube position
		 * @param	y cube position
		 * @return
		 */
		public function createDummySphere(size:int, x:int, y:int):Entity
		{
			var dummyQuad:Entity = new Entity()
				.add(new Position(x, y, 0))
				.add(new Collision(size))
				.add(new SpinningMotion(Math.PI * 0.5))
				.add(new Motion(0, 0, 10))
				.add(new MotionControl(Keyboard.W, Keyboard.A, Keyboard.D, Keyboard.S))
				.add(new Display3D(new DummySphere(size, 0x009EEF)));
			_game.addEntity(dummyQuad);
			
			return dummyQuad;
		}

		/**
		 * Creates a block people, controllable by player
		 *
		 * @param	x position
		 * @param	y position
		 * @param	peopleCode Determine enemy or hero
		 * @return
		 */
		public function createBlockyPeople(x:int, y:int, peopleCode:int):Entity
		{
			var blockyPeople:Entity = new Entity()
				.add(new Position(x, y, 0));
				
			switch (peopleCode)
			{
			case PEOPLE_HERO:
			case PEOPLE_HERO_LEADER:
				var isLeader:Boolean = peopleCode == PEOPLE_HERO_LEADER;
				blockyPeople
					.add(new HeroClone(isLeader))
					.add(new MotionControl(Keyboard.W, Keyboard.A, Keyboard.D, Keyboard.S))
					.add(new MouseControl())
					.add(new Motion(0, 0, 200))
					.add(new Collision(50))
					.add(new Display3D(_assetManager.createBlockyPeople({
						type : isLeader ? 0 : 1
					})));
				break;
			
			case PEOPLE_ENEMY:
			default:
				blockyPeople
					.add(new Motion(0, 0, 200))
					.add(new Collision(50))
					.add(new Display3D(_assetManager.createBlockyPeople({ type : 2 })));
					
				_enemyGroup.push(blockyPeople);
				break;
			}
			
			_game.addEntity(blockyPeople);
			
			return blockyPeople;
		}
		
	}
}
