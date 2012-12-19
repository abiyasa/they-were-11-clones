package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import sabelas.components.Bullet;
	import sabelas.components.GameState;
	import sabelas.components.Shootable;
	import sabelas.configs.GameConfig;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.BulletNode;
	import sabelas.nodes.CloneLeaderNode;
	import sabelas.nodes.GameStateNode;
	import sabelas.nodes.ShootableNode;
	
	/**
	 * System to remove bullets when their life time is over and also
	 * handles the bullet collision with others
	 *
	 * @author Abiyasa
	 */
	public class BulletSystem extends System
	{
		public static const DEBUG_TAG:String = '[BulletSystem]';
		
		private var _entityCreator:EntityCreator;
		private var _bullets:NodeList;
		private var _shootables:NodeList;
		private var _arenaRect:Rectangle;
		protected var _gameStateNodes:NodeList;
		private var _gameState:GameState;
		private var _heroes:NodeList;
		private var _hero:CloneLeaderNode;
		
		// TODO make this a separate system
		private const ENEMIES_FOR_BONUS:int = 4;
		private var _numOfShootEnemies:int = 0;
		private var _bonusTracker:int = ENEMIES_FOR_BONUS;
		
		public function BulletSystem(creator:EntityCreator, config:GameConfig)
		{
			super();
			_entityCreator = creator;
			_arenaRect = config.arenaRect;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			_bullets = engine.getNodeList(BulletNode);
			_shootables = engine.getNodeList(ShootableNode);
			
			_gameStateNodes = engine.getNodeList(GameStateNode);
			_gameStateNodes.nodeAdded.add(onGameStateAdded);
			_gameStateNodes.nodeRemoved.add(onGameStateRemoved);
			
			_heroes = engine.getNodeList(CloneLeaderNode);
			_heroes.nodeAdded.add(onHeroAdded);
			_heroes.nodeRemoved.add(onHeroRemoved);
			
			// reset bonus tracker
			_numOfShootEnemies = 0;
			_bonusTracker = ENEMIES_FOR_BONUS;
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
			
			_bullets = null;
			_shootables = null;
			_entityCreator = null;
		}
		
		override public function update(time:Number):void
		{
			var bulletNode:BulletNode;
			var bullet:Bullet;
			var bulletType:int;
			var bulletRadius:Number;
			var bulletPosition:Point;
			for (bulletNode = _bullets.head; bulletNode; bulletNode = bulletNode.next)
			{
				bullet = bulletNode.bullet;
				bullet.lifeRemaining -= time;
				if (bullet.lifeRemaining <= 0)
				{
					_entityCreator.destroyEntity(bulletNode.entity);
				}
				else  // bullet still active
				{
					bulletType = bullet.type;
					bulletRadius = bulletNode.collision.radius;
					bulletPosition = bulletNode.position.position;
					
					// check if bullet still in area
					if (!_arenaRect.containsPoint(bulletPosition))
					{
						// bullet outside area
						_entityCreator.destroyEntity(bulletNode.entity);
					}
					else
					{
						// check collision with shootable entities
						var shootableNode:ShootableNode;
						var shootable:Shootable;
						for (shootableNode = _shootables.head; shootableNode; shootableNode = shootableNode.next)
						{
							// check bullet type
							shootable = shootableNode.shootable;
							if (shootable.bulletType != bulletType)
							{
								continue;
							}
							
							// check if collide
							if (Point.distance(bulletPosition, shootableNode.position.position) <=
								(bulletRadius + shootableNode.collision.radius))
							{
								// bullet hits item
								// TODO reduce energy
								_entityCreator.destroyEntity(shootableNode.entity);
								_entityCreator.destroyEntity(bulletNode.entity);
								
								// no need to check other shootable
								
								// TODO check bullet type to know who's shooting
								if (bulletType == Bullet.BULLET_TYPE_HERO)
								{
									// add score!
									_numOfShootEnemies++;
									_gameState.numOfShootEnemies = _numOfShootEnemies;
									
									// check bonus based on shoot enemies
									_bonusTracker--;
									if (_bonusTracker <= 0)
									{
										_bonusTracker = ENEMIES_FOR_BONUS;
										
										// add energy to hero
										_hero.energy.value++;
									}
								}
								break;
							}
						}
					}
				}
			}
			
		}
	}

}
