package sabelas.systems
{
	import ash.core.Entity;
	import flash.geom.Point;
	import sabelas.components.CloneMember;
	import sabelas.components.Collision;
	import sabelas.components.GameState;
	import sabelas.components.Position;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.ClonesNode;
	import sabelas.nodes.GameStateNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	/**
	 * System for keeps count of clones on the game
	 *
	 * @author Abiyasa
	 */
	public class CloneCountingSystem extends System
	{
		private var _clones:NodeList;
		private var _gameStateNodes:NodeList;
		
		private var _numOfClones:int;
		private var _gameState:GameState;
		
		public function CloneCountingSystem()
		{
			_numOfClones = 0;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_clones = engine.getNodeList(ClonesNode);
			_clones.nodeAdded.add(onCloneAdded);
			_clones.nodeRemoved.add(onCloneRemoved);
			
			_gameStateNodes = engine.getNodeList(GameStateNode);
			_gameStateNodes.nodeAdded.addOnce(onGameStateAdded);
			_gameStateNodes.nodeRemoved.addOnce(onGameStateRemoved);
		}

		/**
		 * Keeps track the number of clones
		 * @param	node
		 */
		protected function onCloneAdded(node:*):void
		{
			_numOfClones++;
			updateGameState();
		}
		
		/**
		 * Keeps track the number of clones
		 * @param	node
		 */
		protected function onCloneRemoved(node:*):void
		{
			_numOfClones--;
			updateGameState();
		}
		
		/**
		 * Gets the active game state.
		 * Only handle the first game state.
		 *
		 * @param	node
		 */
		protected function onGameStateAdded(node:GameStateNode):void
		{
			_gameState = node.gameState;
			updateGameState();
		}
		
		/**
		 * The only active game state is removed
		 *
		 * @param	node
		 */
		protected function onGameStateRemoved(node:GameStateNode):void
		{
			_gameState = null;
		}
		
		protected function updateGameState():void
		{
			if (_gameState != null)
			{
				_gameState.numOfClones = _numOfClones;
				trace('num of clones is ', _numOfClones);
			}
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_clones.nodeAdded.remove(onCloneAdded);
			_clones.nodeRemoved.remove(onCloneRemoved);
			_clones = null;
			
			_gameStateNodes.nodeAdded.remove(onGameStateAdded);
			_gameStateNodes.nodeRemoved.remove(onGameStateRemoved);
			_gameStateNodes = null;
		}
		
	}

}
