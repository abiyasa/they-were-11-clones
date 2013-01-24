package sabelas.systems
{
	import ash.tools.ListIteratingSystem;
	import sabelas.nodes.DelayedEntityRemovalNode;
	
	/**
	 * System which handles the delayed entity-removal.
	 *
	 * @author Abiyasa
	 */
	public class DelayedEntityRemovalSystem extends ListIteratingSystem
	{
		// TODO add entity creator
		
		public function DelayedEntityRemovalSystem()
		{
			super(DelayedEntityRemovalNode, updateNode);
		}
		
		private function updateNode(node:DelayedEntityRemovalNode, time:Number):void
		{
			// TODO check if it's about time to remove
			
			// TODO if not, update time
		}

	}

}
