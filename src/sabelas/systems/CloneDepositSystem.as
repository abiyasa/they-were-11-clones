package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.Entity;
	import ash.core.NodeList;
	import ash.core.System;
	import flash.geom.Point;
	import sabelas.components.GameState;
	import sabelas.components.Position;
	import sabelas.components.StateMachine;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.CloneDepositNode;
	import sabelas.nodes.CloneLeaderNode;
	import sabelas.nodes.ClonesNode;
	import sabelas.nodes.GameStateNode;
	
	/**
	 * System which process each clone deposit.
	 * If hero hits the clone deposit, check the number of clones & deposit clones.
	 * Also remove and add clone deposit randomly
	 *
	 * @author Abiyasa
	 */
	public class CloneDepositSystem extends System
	{
		private var _entityCreator:EntityCreator;
		private var _deposits:NodeList;
		private var _clones:NodeList;
		protected var _gameStateNodes:NodeList;
		private var _gameState:GameState;
		private var _heroes:NodeList;
		private var _hero:CloneLeaderNode;
		
		public function CloneDepositSystem(creator:EntityCreator)
		{
			super();
			_entityCreator = creator;
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			_deposits = engine.getNodeList(CloneDepositNode);
			
			_clones = engine.getNodeList(ClonesNode);
			
			_gameStateNodes = engine.getNodeList(GameStateNode);
			_gameStateNodes.nodeAdded.add(onGameStateAdded);
			_gameStateNodes.nodeRemoved.add(onGameStateRemoved);
			
			_heroes = engine.getNodeList(CloneLeaderNode);
			_heroes.nodeAdded.add(onHeroAdded);
			_heroes.nodeRemoved.add(onHeroRemoved);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			_heroes.nodeAdded.remove(onHeroAdded);
			_heroes.nodeRemoved.remove(onHeroRemoved);
			_heroes = null;
			_hero = null;
			
			_gameStateNodes.nodeAdded.remove(onGameStateAdded);
			_gameStateNodes.nodeRemoved.remove(onGameStateRemoved);
			_gameStateNodes = null;
			
			_deposits = null;
			
			super.removeFromEngine(engine);
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
		
		override public function update(time:Number):void
		{
			// only check head
			var cloneDeposit:CloneDepositNode = _deposits.head;
			if (cloneDeposit == null)
			{
				// TODO need delay before next deposit generation
				
				// no more deposit, generate more deposit arena,
				//TODO OR generate win condition
				_entityCreator.generateCloneDepositPoints();
				return;
			}
			
			// loop through the clone deposits
			while (cloneDeposit != null)
			{
				var depositRadius:Number = cloneDeposit.collision.radius;
				var depositPos:Point = cloneDeposit.position.position;
				
				// loop through the clones, check if they are inside the arena
				for (var cloneNode:ClonesNode = _clones.head; cloneNode; cloneNode = cloneNode.next)
				{
					if (Point.distance(depositPos, cloneNode.position.position) <=
						(depositRadius + cloneNode.collision.radius))
					{
						trace('a clone is inside deposit arena!');
					
						var cloneEntity:Entity = cloneNode.entity;
						var stateMachine:StateMachine = cloneEntity.get(StateMachine);
						if (stateMachine != null)
						{
							stateMachine.stateMachine.changeState('deposit');
						}
						else
						{
							trace('Error! cannot get the stateMachine! Just move the entity anyway');
							_entityCreator.destroyEntity(cloneEntity);
						}
						
						// scoring
						_gameState.score += 10;
						
						// deposit clone
						cloneDeposit.cloneDeposit.clonesRequired--;
						if (cloneDeposit.cloneDeposit.clonesRequired <= 0)
						{
							// scoring
							_gameState.score += 100;

							// remove deposit place
							_entityCreator.destroyEntity(cloneDeposit.entity);
							
							// trigger damageProof to the hero
							if (_hero != null)
							{
								var heroStateMachine:StateMachine = _hero.entity.get(StateMachine);
								if (heroStateMachine != null)
								{
									heroStateMachine.stateMachine.changeState('damageProof');
								}
							}
							break;
						}
						
						// update the entity state based on cloneDeposit.cloneDeposit.clonesRequired
						stateMachine = cloneDeposit.entity.get(StateMachine);
						if (stateMachine != null)
						{
							stateMachine.stateMachine.changeState(cloneDeposit.cloneDeposit.getStateString());
						}

					}
				}
				
				// next clone deposit
				cloneDeposit = cloneDeposit.next;
			}
		}
		
	}

}
