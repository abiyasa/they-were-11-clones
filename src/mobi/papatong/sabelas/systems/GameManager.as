package mobi.papatong.sabelas.systems
{
	import flash.events.Event;
	import mobi.papatong.sabelas.configs.GameConfig;
	import mobi.papatong.sabelas.core.EntityCreator;
	import mobi.papatong.sabelas.nodes.DummyObjectNode;
	import mobi.papatong.sabelas.nodes.GameStateNode;
	import mobi.papatong.sabelas.components.GameState;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;

	/**
	 * Managing game states and adding/removing entities
	 */
	public class GameManager extends System
	{
		private var _config:GameConfig;
		private var _entityCreator:EntityCreator;
		
		private var _gameStateNodes:NodeList;
		private var _gameObjects:NodeList;
		
		public function GameManager(creator:EntityCreator, config:GameConfig)
		{
			_entityCreator = creator;
			_config = config;
		}

		override public function addToGame(game:Game):void
		{
			_gameStateNodes = game.getNodeList(GameStateNode);
			_gameObjects = game.getNodeList(DummyObjectNode);
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
					
					// TODO check if we're done loading
					if (_entityCreator.assetsLoaded)
					{
						trace('assets has been loaded');
						
						// TODO load game characters
						_entityCreator.createBlockyPeople(0, -200, EntityCreator.PEOPLE_HERO);
						_entityCreator.createBlockyPeople(400, -200, EntityCreator.PEOPLE_HERO);
						_entityCreator.createBlockyPeople(0, -400, EntityCreator.PEOPLE_HERO);
						_entityCreator.createBlockyPeople(200, -400, EntityCreator.PEOPLE_HERO);
						_entityCreator.createBlockyPeople(400, -400, EntityCreator.PEOPLE_HERO);
						
						// add enemies
						_entityCreator.createBlockyPeople(200, 200, EntityCreator.PEOPLE_ENEMY);
						_entityCreator.createBlockyPeople(200, 400, EntityCreator.PEOPLE_ENEMY);
						_entityCreator.createBlockyPeople(200, 600, EntityCreator.PEOPLE_ENEMY);
						
						// TODO entityCreator stops loading animation
						
						// start the games
						gameState.state = GameState.STATE_PLAY;
					}
					break;
				}
			}
		}
		
		override public function removeFromGame(game:Game):void
		{
			_gameStateNodes = null;
			_gameObjects = null;
		}
	}
}
