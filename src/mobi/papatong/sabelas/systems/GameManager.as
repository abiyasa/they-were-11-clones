package mobi.papatong.sabelas.systems
{
	import mobi.papatong.sabelas.configs.GameConfig;
	import mobi.papatong.sabelas.core.EntityCreator;
	import mobi.papatong.sabelas.nodes.DummyObjectNode;
	import mobi.papatong.sabelas.nodes.GameStateNode;
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
			for (node = _gameStateNodes.head; node; node = node.next)
			{
				// TODO check game state
				
				if (_gameObjects.empty)
				{
					// create dummy HUD item on the top middle
					_entityCreator.createDummyQuad(30, _config.width / 2, 30);
					
					// TODO load game characters
					_entityCreator.createDummySphere(50, _config.width / 2, _config.height / 2);
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
