package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import sabelas.components.Bullet;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.BulletNode;
	
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
			for (bulletNode = _bullets.head; bulletNode; bulletNode = bulletNode.next)
			{
				bullet = bulletNode.bullet;
				bullet.lifeRemaining -= time;
				if (bullet.lifeRemaining <= 0)
				{
					_entityCreator.destroyEntity(bulletNode.entity);
				}
				else
				{
					// TODO check collision with shootable entities
				}
			}
			
		}
	}

}
