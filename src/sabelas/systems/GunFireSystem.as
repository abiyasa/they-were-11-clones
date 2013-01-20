package sabelas.systems
{
	import ash.core.Entity;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import sabelas.components.Gun;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.GunNode;
	
	/**
	 * System for keeps count of clones on the game
	 *
	 * @author Abiyasa
	 */
	public class GunFireSystem extends System
	{
		private var _creator:EntityCreator;
		private var _guns:NodeList;
		
		public function GunFireSystem(creator:EntityCreator)
		{
			_creator = creator;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_guns = engine.getNodeList(GunNode);
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_guns = null;
		}
		
		override public function update(time:Number):void
		{
			var gun:Gun;
			for (var gunNode:GunNode = _guns.head; gunNode; gunNode = gunNode.next)
			{
				gun = gunNode.gun;
				if (gun.isAllowedToShootBullet())
				{
					// shoot the bullet
					_creator.createBullet(gun, gunNode.position, EntityCreator.PEOPLE_HERO);
					
					gun.resetTime();
				}
			}
		}
	}

}
