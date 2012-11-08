package mobi.papatong.sabelas.systems
{
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.components.SpinningMotion;
	import mobi.papatong.sabelas.nodes.SpinningMotionNode;
	import net.richardlord.ash.tools.ListIteratingSystem;
	
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
