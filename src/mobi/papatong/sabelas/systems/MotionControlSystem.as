package mobi.papatong.sabelas.systems
{
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.MotionControl;
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.nodes.MotionControlNode;
	import mobi.papatong.sabelas.input.KeyPoll;
	import net.richardlord.ash.tools.ListIteratingSystem;
	
	/**
	 * System for updating object position based on its motion data and
	 * motion control (keyboard/input controlled)
	 *
	 * @author Abiyasa
	 */
	public class MotionControlSystem extends ListIteratingSystem
	{
		private var _keyPoll:KeyPoll;
		
		public function MotionControlSystem(keyPoll:KeyPoll)
		{
			super(MotionControlNode, updateNode);
			_keyPoll = keyPoll;
		}
		
		private function updateNode(node:MotionControlNode, time:Number):void
		{
			var control:MotionControl = node.control;
			var position:Position = node.position;
			var motion:Motion = node.motion;

			// horizontal movement
			if (_keyPoll.isDown(control.keyMoveLeft))
			{
				// TODO rotate object facing left
				motion.velocity.x = -motion.maxSpeed * time;
			}
			else if (_keyPoll.isDown(control.keyMoveRight))
			{
				// TODO rotate object facing right
				motion.velocity.x = motion.maxSpeed * time;
			}
			else
			{
				motion.velocity.x = 0;
			}

			// vertical movement
			if (_keyPoll.isDown(control.keyMoveUp))
			{
				// TODO rotate object facing up
				motion.velocity.y = motion.maxSpeed * time;
			}
			else if (_keyPoll.isDown(control.keyMoveDown))
			{
				// TODO rotate object facing down
				motion.velocity.y = -motion.maxSpeed * time;
			}
			else
			{
				motion.velocity.y = 0;
			}
			
			// update position
			// TODO move this to separate system (movementsystem)
			position.position.x += motion.velocity.x;
			position.position.y += motion.velocity.y;
		}
	}

}
