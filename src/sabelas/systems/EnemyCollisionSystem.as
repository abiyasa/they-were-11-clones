package sabelas.systems
{
	import ash.core.Entity;
	import flash.geom.Point;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.ClonesNode;
	import sabelas.nodes.EnemyNode;
	import sabelas.nodes.CloneLeaderNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	
	/**
	 * System for detecting collision between clones/hero & the enemies.
	 * When collision happens, will update energy & remove entities
	 *
	 * @author Abiyasa
	 */
	public class EnemyCollisionSystem extends System
	{
		private var _entityCreator:EntityCreator;
		private var _clones:NodeList;
		private var _heroes:NodeList;
		private var _enemies:NodeList;
		private var _hero:CloneLeaderNode;
		
		public function EnemyCollisionSystem(creator:EntityCreator)
		{
			_entityCreator = creator;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_clones = engine.getNodeList(ClonesNode);
			_enemies = engine.getNodeList(EnemyNode);
			_heroes = engine.getNodeList(CloneLeaderNode);
			_heroes.nodeAdded.add(onHeroAdded);
			_heroes.nodeRemoved.add(onHeroRemoved);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			
			_heroes.nodeRemoved.remove(onHeroRemoved);
			_heroes.nodeAdded.remove(onHeroAdded);
			_heroes = null;
			_clones = null;
			_enemies = null;
		}
		
		private function onHeroAdded(node:CloneLeaderNode):void
		{
			// only handle 1 hero at the time
			_hero = node;
		}
		
		private function onHeroRemoved(node:CloneLeaderNode):void
		{
			_hero = null;
		}

		override public function update(time:Number):void
		{
			// get hero data
			var heroPosition:Point;
			var heroRadius:Number;
			if (_hero != null)
			{
				heroPosition = _hero.position.position;
				heroRadius = _hero.collision.radius;
			}
			
			// handle collision enemy with clone or main hero
			var enemyRadius:Number;
			var enemyPosition:Point;
			var enemyIsExist:Boolean;
			var cloneNode:ClonesNode;
			for (var enemyNode:EnemyNode = _enemies.head; enemyNode; enemyNode = enemyNode.next)
			{
				enemyRadius = enemyNode.collision.radius;
				enemyPosition = enemyNode.position.position;
				enemyIsExist = true;
				
				// handle collision with clones
				for (cloneNode = _clones.head; cloneNode; cloneNode = cloneNode.next)
				{
					if (Point.distance(enemyPosition, cloneNode.position.position) <=
						(enemyRadius + cloneNode.collision.radius))
					{
						// reduce enemy energy
						enemyNode.energy.value--;
						if (enemyNode.energy.value <= 0)
						{
							// enemy is dead
							_entityCreator.destroyEntity(enemyNode.entity);
							enemyIsExist = false;
						}
						
						handleCloneGetHit(cloneNode);
					}
				}
				
				// handle collision with main hero
				if (enemyIsExist && (_hero != null))
				{
					if (Point.distance(enemyPosition, heroPosition) <= (enemyRadius + heroRadius))
					{
						// reduce enemy energy
						enemyNode.energy.value--;
						if (enemyNode.energy.value <= 0)
						{
							// enemy is dead
							_entityCreator.destroyEntity(enemyNode.entity);
						}
						
						// reduce main hero energy
						if (_hero.energy.value > 0)
						{
							_hero.energy.value--;
						}
						else
						{
							// then reduce the clones!
							cloneNode = _clones.head;
							if (cloneNode != null)
							{
								handleCloneGetHit(cloneNode);
							}
						}
					}
					
				}
			}
			
		}
		
		/**
		 * Handles clone get hit.
		 * When clone's energy is empty, remove the clone
		 * @param	cloneNode
		 * @return true if clone is dead or will be removed. Otherwise, clone only
		 * got its energy reduced
		 */
		private function handleCloneGetHit(cloneNode:ClonesNode):Boolean
		{
			// reduce clone energy
			var cloneIsDead:Boolean = false;
			
			cloneNode.energy.value--;
			if (cloneNode.energy.value <= 0)
			{
				// clone is dead
				_entityCreator.destroyEntity(cloneNode.entity);
				cloneIsDead = true;
			}
			
			return cloneIsDead;
		}

	}

}
