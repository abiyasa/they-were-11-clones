package sabelas.systems
{
	import ash.tools.ListIteratingSystem;
	import sabelas.components.DelayedEntityRemoval;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.DelayedEntityRemovalNode;
	
	/**
	 * System which handles the delayed entity-removal.
	 *
	 * @author Abiyasa
	 */
	public class DelayedEntityRemovalSystem extends ListIteratingSystem
	{
		private var _creator:EntityCreator;
		
		public function DelayedEntityRemovalSystem(creator:EntityCreator)
		{
			super(DelayedEntityRemovalNode, updateNode);
			_creator = creator;
		}
		
		private function updateNode(node:DelayedEntityRemovalNode, time:Number):void
		{
			// check if it's about time to remove
			var delayedEntityRemoval:DelayedEntityRemoval = node.delayedEntityRemoval;
			if (delayedEntityRemoval.canRemove())
			{
				// remove the enityt from the game
				_creator.destroyEntity(node.entity);
			}
			else  // not yet removed
			{
				delayedEntityRemoval.updateTime(time);
			}
		}

	}

}
