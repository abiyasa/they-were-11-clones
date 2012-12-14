package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import flash.geom.Point;
	import sabelas.components.Bullet;
	import sabelas.components.Shootable;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.BulletNode;
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
		
		public function BulletSystem(creator:EntityCreator)
		{
			super();
			_entityCreator = creator;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_bullets = engine.getNodeList(BulletNode);
			_shootables = engine.getNodeList(ShootableNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
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
							_entityCreator.destroyEntity(shootableNode.entity);
							_entityCreator.destroyEntity(bulletNode.entity);
							
							// no need to check other shootable
							break;
						}
					}
				}
			}
			
		}
	}

}
