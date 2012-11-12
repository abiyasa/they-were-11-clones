package mobi.papatong.sabelas.systems
{
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.nodes.MotionNode;
	import net.richardlord.ash.tools.ListIteratingSystem;
	
	/**
	 * System for updating object position based on its motion data
	 *
	 * @author Abiyasa
	 */
	public class MotionSystem extends ListIteratingSystem
	{
		
		public function MotionSystem()
		{
			super(MotionNode, updateNode);
		}
		
		private function updateNode(node:MotionNode, time:Number):void
		{
			// calculate spped
			var angle:Number = node.motion.angle;
			var speed:Number = node.motion.speed * time;
			var position:Position = node.position;
			position.position.x += Math.sin(angle) * speed;
			position.position.y += Math.cos(angle) * speed;
		}
	}

}
