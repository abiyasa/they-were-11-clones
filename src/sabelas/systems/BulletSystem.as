package sabelas.systems
{
	import ash.tools.ListIteratingSystem;
	import sabelas.components.Bullet;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.BulletNode;
	
	/**
	 * System to remove bullets when their life time is over and also
	 * handles the bullet collision with others
	 *
	 * @author Abiyasa
	 */
	public class BulletSystem extends ListIteratingSystem
	{
		private var _entityCreator:EntityCreator;
		
		public function BulletSystem(creator:EntityCreator)
		{
			super(BulletNode, updateNode);
			_entityCreator = creator;
			
			// TODO get shootable list
		}
		
		private function updateNode(node:BulletNode, time:Number):void
		{
			var bullet:Bullet = node.bullet;
			bullet.lifeRemaining -= time;
			if (bullet.lifeRemaining <= 0)
			{
				_entityCreator.destroyEntity(node.entity);
			}
			else
			{
				// TODO check collision with shootable entities
			}
		}
	}

}
