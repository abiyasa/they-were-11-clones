package mobi.papatong.sabelas.core
{
	import flash.ui.Keyboard;
	import mobi.papatong.sabelas.components.Display3D;
	import mobi.papatong.sabelas.components.DummyObject;
	import mobi.papatong.sabelas.components.GameState;
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.MotionControl;
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.components.Display;
	import mobi.papatong.sabelas.components.SpinningMotion;
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
	public class EntityCreator
	{
		private var _game:Game;
		
		public function EntityCreator(game:Game)
		{
			_game = game;
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
				.add(new DummyObject())
				.add(new Position(x, y, 0, size))
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
				.add(new DummyObject())
				.add(new Position(x, y, 0, size))
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
		 * @return
		 */
		public function createBlockyPeople(x:int, y:int):Entity
		{
			var blockyPeople:Entity = new Entity()
				.add(new DummyObject())
				.add(new Position(x, y, 0, 50))
				.add(new Motion(0, 0, 200))
				.add(new MotionControl(Keyboard.W, Keyboard.A, Keyboard.D, Keyboard.S))
				.add(new Display3D(new BlockyPeople(100, 200, 80, 0x009EEF)));
			_game.addEntity(blockyPeople);
			
			return blockyPeople;
		}
		
	}
}
