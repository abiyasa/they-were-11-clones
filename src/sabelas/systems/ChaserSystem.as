package sabelas.systems
{
	import ash.tools.ListIteratingSystem;
	import sabelas.components.Motion;
	import sabelas.components.Position;
	import sabelas.nodes.ChaserNode;
	
	/**
	 * System which update chaser position & motion based on their prey postion
	 * Chasers will move towards prey and hitting themselve to their prey
	 *
	 * @author Abiyasa
	 */
	public class ChaserSystem extends ListIteratingSystem
	{
		
		public function ChaserSystem()
		{
			super(ChaserNode, updateNode);
		}
		
		private function updateNode(node:ChaserNode, time:Number):void
		{
			var motion:Motion = node.motion;
			var position:Position = node.position;
			var predatorPosition:Position = node.chaser.preyPosition;
			
			// rotate facing the prey
			var rotation:Number = Math.atan2(predatorPosition.position.x - position.position.x,
				predatorPosition.position.y  - position.position.y);
			position.rotation = rotation;
			motion.angle = rotation;
			motion.speed = motion.maxSpeed;
		}

	}

}
