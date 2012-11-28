package mobi.papatong.sabelas.core
{
	import away3d.core.managers.Stage3DProxy;
	import flash.events.EventDispatcher;
	import mobi.papatong.sabelas.core.EntityCreator;
	import mobi.papatong.sabelas.components.GameState;
	import mobi.papatong.sabelas.configs.GameConfig;
	import mobi.papatong.sabelas.input.KeyPoll;
	import mobi.papatong.sabelas.systems.CollisionSystem;
	import mobi.papatong.sabelas.systems.GameManager;
	import mobi.papatong.sabelas.systems.HeroClonePositioningSystem;
	import mobi.papatong.sabelas.systems.MotionControlSystem;
	import mobi.papatong.sabelas.systems.MotionSystem;
	import mobi.papatong.sabelas.systems.MouseMotionControlSystem;
	import mobi.papatong.sabelas.systems.RenderSystem;
	import mobi.papatong.sabelas.systems.RenderSystem3D;
	import mobi.papatong.sabelas.systems.SpinningMotionSystem;
	import mobi.papatong.sabelas.systems.SystemPriorities;
	import mobi.papatong.sabelas.utils.Stage3DUtils;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.integration.starling.StarlingFrameTickProvider;
	import net.richardlord.ash.tick.TickProvider;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * The main game engine which will control the main game context.
	 * Will dispatch game events
	 *
	 * @author Abiyasa
	 */
	public class GameEngine extends EventDispatcher
	{
		public static const DEBUG_TAG:String = "GameEngine";
		
		private var _game:Game;
		private var _container:DisplayObjectContainer;
		private var _config:GameConfig;
		private var _entityCreator:EntityCreator;
		private var _tickProvider:TickProvider;
		private var _gameState:GameState;
		private var _keyPoll:KeyPoll;
		
		/**
		 * The shared Stage3D context
		 */
		private var _stage3dProxy:Stage3DProxy;
		
		
		public function GameEngine(container:DisplayObjectContainer)
		{
			super();
			
			_container = container;
		}
		
		public function init():void
		{
			_game = new Game();
			_entityCreator = new EntityCreator(_game);
			
			_config = new GameConfig();
			_config.width = _container.stage.stageWidth;
			_config.height = _container.stage.stageHeight;
			
			// init inputs
			_keyPoll = new KeyPoll(_container.stage);
			
			// add systems
			_game.addSystem(new GameManager(_entityCreator, _config), SystemPriorities.PRE_UPDATE);
			_game.addSystem(new RenderSystem(_container), SystemPriorities.RENDER);
			var stage3DUtils:Stage3DUtils = Stage3DUtils.getInstance();
			_game.addSystem(new RenderSystem3D(stage3DUtils.currentView3D,
				stage3DUtils.currentStage3DProxy), SystemPriorities.RENDER);
			_game.addSystem(new SpinningMotionSystem(), SystemPriorities.UPDATE);
			_game.addSystem(new MotionControlSystem(_keyPoll), SystemPriorities.UPDATE);
			_game.addSystem(new HeroClonePositioningSystem(_entityCreator), SystemPriorities.UPDATE);
			_game.addSystem(new CollisionSystem(_entityCreator), SystemPriorities.UPDATE);
			_game.addSystem(new MotionSystem(), SystemPriorities.UPDATE);
			_game.addSystem(new MouseMotionControlSystem(_container.stage, stage3DUtils.currentView3D),
				SystemPriorities.UPDATE);
		
			// get the active game state
			var gameStateEntity:Entity = _entityCreator.createGameState();
			_gameState = gameStateEntity.get(GameState) as GameState;
		}
		
		private function destroy():void
		{
			_game.removeAllEntities();
			_game.removeAllSystems();
			
			_keyPoll.destroy();
			
			_entityCreator.destroy();
		}
		
		public function start():void
		{
			_keyPoll.reset();
			
			_tickProvider = new StarlingFrameTickProvider(Starling.current.juggler);
			_tickProvider.add(_game.update);
			_tickProvider.start();
		}
		
		public function stop():void
		{
			_tickProvider.stop();
			_tickProvider.remove(_game.update);

			destroy();
		}
	}

}
