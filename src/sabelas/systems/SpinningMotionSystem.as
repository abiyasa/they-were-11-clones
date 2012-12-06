package sabelas.systems
{
	import sabelas.components.Position;
	import sabelas.components.SpinningMotion;
	import sabelas.nodes.SpinningMotionNode;
	import ash.tools.ListIteratingSystem;
	
	/**
	 * System for spinning the object.
	 * Just for testing control-less motion system
	 *
	 * @author Abiyasa
	 */
	public class SpinningMotionSystem extends ListIteratingSystem
	{
		
		public function SpinningMotionSystem()
		{
			super(SpinningMotionNode, updateNode);
		}
		
		private function updateNode(node:SpinningMotionNode, time:Number):void
		{
			var position:Position = node.position;
			var spinningMotion:SpinningMotion = node.spinningMotion;
			
			position.rotation += spinningMotion.angularVelocity * time;
		}
	}

}
