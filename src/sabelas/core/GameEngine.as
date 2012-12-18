package sabelas.core
{
	import away3d.core.managers.Stage3DProxy;
	import flash.events.EventDispatcher;
	import sabelas.core.EntityCreator;
	import sabelas.components.GameState;
	import sabelas.configs.GameConfig;
	import sabelas.graphics.SimpleHUD;
	import sabelas.input.KeyPoll;
	import sabelas.systems.BulletSystem;
	import sabelas.systems.CloneCountingSystem;
	import sabelas.systems.CollisionSystem;
	import sabelas.systems.EnemyGeneratorSystem;
	import sabelas.systems.GameManager;
	import sabelas.systems.ChaserSystem;
	import sabelas.systems.CloneControlSystem;
	import sabelas.systems.ClonePositioningSystem;
	import sabelas.systems.MotionControlSystem;
	import sabelas.systems.MotionSystem;
	import sabelas.systems.MouseControlSystem;
	import sabelas.systems.RenderSystem;
	import sabelas.systems.RenderSystem3D;
	import sabelas.systems.StalkingCameraSystem;
	import sabelas.systems.SystemPriorities;
	import sabelas.utils.Stage3DUtils;
	import ash.core.Entity;
	import ash.core.Engine;
	import ash.integration.starling.StarlingFrameTickProvider;
	import ash.tick.ITickProvider;
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
		
		private var _engine:Engine;
		private var _container:DisplayObjectContainer;
		private var _config:GameConfig;
		private var _entityCreator:EntityCreator;
		private var _tickProvider:ITickProvider;
		private var _gameState:GameState;
		private var _keyPoll:KeyPoll;
		private var _hud:SimpleHUD;
		
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
			_engine = new Engine();
			
			_config = new GameConfig();
			_config.width = _container.stage.stageWidth;
			_config.height = _container.stage.stageHeight;
			
			// set arena
			var arenaWidth:int = 10000;
			var arenaHeight:int = 20000;
			var arenaPosX:int = 0;
			var arenaPosY:int = 0;
			_config.setArena(arenaWidth, arenaHeight, arenaPosX, arenaPosY);
			
			_entityCreator = new EntityCreator(_engine, _config);
			
			// init inputs
			_keyPoll = new KeyPoll(_container.stage);
			
			var stage3DUtils:Stage3DUtils = Stage3DUtils.getInstance();
			
			// add systems
			_engine.addSystem(new GameManager(_entityCreator, _config), SystemPriorities.PRE_UPDATE);
			_engine.addSystem(new EnemyGeneratorSystem(_entityCreator), SystemPriorities.PRE_UPDATE);
			_engine.addSystem(new MotionControlSystem(_keyPoll), SystemPriorities.UPDATE);
			_engine.addSystem(new ClonePositioningSystem(_entityCreator), SystemPriorities.UPDATE);
			_engine.addSystem(new CloneControlSystem(_entityCreator, _keyPoll), SystemPriorities.UPDATE);
			_engine.addSystem(new MouseControlSystem(_container.stage, stage3DUtils.currentView3D,
				_entityCreator), SystemPriorities.UPDATE);
			_engine.addSystem(new ChaserSystem(), SystemPriorities.UPDATE);
			_engine.addSystem(new CloneCountingSystem(), SystemPriorities.UPDATE);
			_engine.addSystem(new CollisionSystem(_entityCreator), SystemPriorities.MOVE);
			_engine.addSystem(new MotionSystem(_config.arenaRect), SystemPriorities.MOVE);
			_engine.addSystem(new BulletSystem(_entityCreator, _config), SystemPriorities.RESOLVE_COLLISIONS);
			_engine.addSystem(new StalkingCameraSystem(stage3DUtils.currentView3D.camera), SystemPriorities.MOVE);
			//_engine.addSystem(new RenderSystem(_container), SystemPriorities.RENDER);
			_engine.addSystem(new RenderSystem3D(stage3DUtils.currentView3D), SystemPriorities.RENDER);
		
			// get the active game state
			var gameStateEntity:Entity = _entityCreator.createGameState();
			_gameState = gameStateEntity.get(GameState) as GameState;
			
			initHUD();
		}
		
		private function initHUD():void
		{
			_hud = new SimpleHUD(_gameState);
			_container.addChild(_hud);
			
			// TODO reposition HUD using _container.stage
			_hud.x = 60;
			
		}
		
		private function destroyHUD():void
		{
			_container.removeChild(_hud, false);
			_hud = null;
		}
		
		
		private function destroy():void
		{
			_engine.removeAllEntities();
			_engine.removeAllSystems();
			
			_keyPoll.destroy();
			
			_entityCreator.destroy();
		}
		
		public function start():void
		{
			_keyPoll.reset();
			
			_tickProvider = new StarlingFrameTickProvider(Starling.current.juggler);
			_tickProvider.add(_engine.update);
			_tickProvider.add(_hud.update);
			_tickProvider.start();
		}
		
		public function stop():void
		{
			destroyHUD();
			
			_tickProvider.stop();
			_tickProvider.remove(_hud.update);
			_tickProvider.remove(_engine.update);

			destroy();
		}
	}

}
