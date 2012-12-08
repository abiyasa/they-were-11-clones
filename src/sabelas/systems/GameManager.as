package sabelas.systems
{
	import flash.events.Event;
	import sabelas.configs.GameConfig;
	import sabelas.core.EntityCreator;
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
		
		public function GameManager(creator:EntityCreator, config:GameConfig)
		{
			_entityCreator = creator;
			_config = config;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_gameStateNodes = engine.getNodeList(GameStateNode);
		}
		
		override public function update(time:Number):void
		{
			var node:GameStateNode;
			var gameState:GameState;
			for (node = _gameStateNodes.head; node; node = node.next)
			{
				gameState = node.gameState;
				switch (gameState.state)
				{
				case GameState.STATE_INIT:
					trace('GameState.STATE_INIT');
					
					// create dummy HUD item on the top middle
					_entityCreator.createDummyQuad(30, _config.width / 2, 30);
					
					// TODO entityCreator adds loading animation
					
					// starts assets loading
					// TODO not sure with the event dispatcher chains. Have to rethink about this
					gameState.state = GameState.STATE_LOADING;
					_entityCreator.initAssets();
					break;
					
				case GameState.STATE_LOADING:
					trace('GameState.STATE_LOADING');
					
					// check if we're done loading
					if (_entityCreator.assetsLoaded)
					{
						trace('assets has been loaded');
						
						// add game characters
						_entityCreator.createHero(0, -200);
						
						// TODO add enemies
						/*
						_entityCreator.createBlockyPeople(200, 200, EntityCreator.PEOPLE_ENEMY);
						_entityCreator.createBlockyPeople(200, 400, EntityCreator.PEOPLE_ENEMY);
						_entityCreator.createBlockyPeople(200, 600, EntityCreator.PEOPLE_ENEMY);
						*/
						
						// TODO entityCreator stops loading animation
						
						// start the games
						gameState.state = GameState.STATE_PLAY;
					}
					break;
				}
			}
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_gameStateNodes = null;
		}
	}
}
