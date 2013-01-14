package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.Entity;
	import ash.core.Node;
	import ash.core.NodeList;
	import ash.core.System;
	import ash.tools.ListIteratingSystem;
	import sabelas.components.GameState;
	import sabelas.components.Position;
	import sabelas.core.EntityCreator;
	import sabelas.input.KeyPoll;
	import sabelas.nodes.CloneLeaderNode;
	import sabelas.nodes.GameStateNode;
	
	
	/**
	 * System for controlling clone (adding or removing clones).
	 * Clone added automatically when energy is enough
	 *
	 * @author Abiyasa
	 */
	public class CloneControlSystem extends System
	{
		public static const DEBUG_TAG:String = '[CloneControlSystem]';
		
		public static const MAX_NUM_OF_CLONES:int = 11;
		
		protected var _keyPoll:KeyPoll;
		protected var _entityCreator:EntityCreator;
		protected var _gameStateNodes:NodeList;
		private var _gameState:GameState;
		private var _heroes:NodeList;
		private var _hero:CloneLeaderNode;
		
		public function CloneControlSystem(creator:EntityCreator, keypoll:KeyPoll)
		{
			super();
			_keyPoll = keypoll;
			_entityCreator = creator;
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
			if (_hero == null)
			{
				return;
			}
			
			super.update(time);
			
			// create clone from the leader
			if ((_hero.energy.value > 1) && (_gameState.numOfClones < MAX_NUM_OF_CLONES))
			{
				trace(DEBUG_TAG, 'cloning an item');
				
				// TODO create clone behind the leader (use leader's moving direction)
				var leaderPosition:Position = _hero.position;
				_entityCreator.createHero(leaderPosition.position.x, leaderPosition.position.y - 300, true);
				
				_hero.energy.value--;
			}
		}
	}

}
