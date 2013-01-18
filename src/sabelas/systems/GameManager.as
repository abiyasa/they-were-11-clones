package sabelas.systems
{
	import flash.events.Event;
	import sabelas.configs.GameConfig;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.CloneLeaderNode;
	import sabelas.nodes.GameStateNode;
	import sabelas.components.GameState;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;

	/**
	 * Managing game states and adding/removing entities
	 */
	public class GameManager extends System
	{
		private var _config:GameConfig;
		private var _entityCreator:EntityCreator;
		
		private var _gameStateNodes:NodeList;
		private var _gameState:GameState;
		private var _heroes:NodeList;
		private var _hero:CloneLeaderNode;
		
		public function GameManager(creator:EntityCreator, config:GameConfig)
		{
			_entityCreator = creator;
			_config = config;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			_gameStateNodes = engine.getNodeList(GameStateNode);
			_gameStateNodes.nodeAdded.add(onGameStateAdded);
			_gameStateNodes.nodeRemoved.add(onGameStateRemoved);
			
			_heroes = engine.getNodeList(CloneLeaderNode);
			_heroes.nodeAdded.add(onHeroAdded);
			_heroes.nodeRemoved.add(onHeroRemoved);
		}
		
		private function onGameStateAdded(node:GameStateNode):void
		{
			_gameState = node.gameState;
		}
		
		private function onGameStateRemoved(node:GameStateNode):void
		{
			_gameState = null;
		}
		
		private function onHeroAdded(node:CloneLeaderNode):void
		{
			_hero = node;
		}
		
		private function onHeroRemoved(node:CloneLeaderNode):void
		{
			_hero = null;
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			
			_gameStateNodes.nodeAdded.remove(onGameStateAdded);
			_gameStateNodes.nodeRemoved.remove(onGameStateRemoved);
			_gameStateNodes = null;
			
			_heroes.nodeAdded.remove(onHeroAdded);
			_heroes.nodeRemoved.remove(onHeroRemoved);
			_heroes = null;
		}
		
		override public function update(time:Number):void
		{
			// only handle 1 game state
			if (_gameState == null)
			{
				return;
			}
			
			switch (_gameState.state)
			{
			case GameState.STATE_INIT:
				trace('GameState.STATE_INIT');
				
				// TODO entityCreator adds loading animation
				
				// starts assets loading
				// TODO not sure with the event dispatcher chains. Have to rethink about this
				_gameState.state = GameState.STATE_LOADING;
				_entityCreator.initAssets();
				break;
				
			case GameState.STATE_LOADING:
				trace('GameState.STATE_LOADING');
				
				// check if we're done loading
				if (_entityCreator.assetsLoaded)
				{
					trace('assets has been loaded');

					// stage
					_entityCreator.createArena();
					
					// add game characters
					_entityCreator.createHero(0, -200);
					_entityCreator.createStalkingCamera();
					
					_entityCreator.generateEnemyWaves();
					_entityCreator.generateCloneDepositPoints();
					
					// TODO entityCreator stops loading animation
					
					// start the games
					_gameState.state = GameState.STATE_PLAY;
				}
				break;
				
			case GameState.STATE_PLAY:
				if (_heroes != null)
				{
					// update hero energy
					var heroEnergy:int = _hero.energy.value;
					_gameState.energy = heroEnergy;
					if (heroEnergy <= 0)
					{
						_gameState.state = GameState.STATE_GAME_OVER;
					}
				}
				break;
			}
		}
	}
}
