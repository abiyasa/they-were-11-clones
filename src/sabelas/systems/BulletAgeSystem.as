package sabelas.systems
{
	import ash.tools.ListIteratingSystem;
	import sabelas.components.Bullet;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.BulletAgeNode;
	
	/**
	 * System to remove bullets when their life time is over.
	 *
	 * @author Abiyasa
	 */
	public class BulletAgeSystem extends ListIteratingSystem
	{
		private var _entityCreator:EntityCreator;
		
		public function BulletAgeSystem(creator:EntityCreator)
		{
			super(BulletAgeNode, updateNode);
			_entityCreator = creator;
		}
		
		private function updateNode(node:BulletAgeNode, time:Number):void
		{
			var bullet:Bullet = node.bullet;
			bullet.lifeRemaining -= time;
			if (bullet.lifeRemaining <= 0)
			{
				_entityCreator.destroyEntity(node.entity);
			}
		}
	}

}
