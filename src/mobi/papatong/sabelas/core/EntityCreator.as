package mobi.papatong.sabelas.core
{
	import mobi.papatong.sabelas.components.DummyObject;
	import mobi.papatong.sabelas.components.GameState;
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.components.Display;
	import mobi.papatong.sabelas.graphics.DummyQuadView;
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
				.add(new Display(new DummyQuadView(size)));
			_game.addEntity(dummyQuad);
			
			return dummyQuad;
		}
	}
}
