package mobi.papatong.sabelas.systems
{
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.MotionControl;
	import mobi.papatong.sabelas.nodes.MotionControlNode;
	import mobi.papatong.sabelas.input.KeyPoll;
	import ash.tools.ListIteratingSystem;
	
	/**
	 * System for updating object motion data based on
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
			var motion:Motion = node.motion;

			// horizontal movement
			var angle:Number;
			if (_keyPoll.isDown(control.keyMoveLeft))
			{
				// vertical movement
				if (_keyPoll.isDown(control.keyMoveUp))
				{
					angle = -Math.PI * 0.25;
				}
				else if (_keyPoll.isDown(control.keyMoveDown))
				{
					angle = -Math.PI * 0.75;
				}
				else
				{
					angle = -Math.PI * 0.5;
				}
				
				// TODO rotate object facing the direction
				motion.angle = angle;
				motion.speed = motion.maxSpeed;
			}
			else if (_keyPoll.isDown(control.keyMoveRight))
			{
				// vertical movement
				if (_keyPoll.isDown(control.keyMoveUp))
				{
					angle = Math.PI * 0.25;
				}
				else if (_keyPoll.isDown(control.keyMoveDown))
				{
					angle = Math.PI * 0.75;
				}
				else
				{
					angle = Math.PI * 0.5;
				}
				
				// TODO rotate object facing the direction
				motion.angle = angle;
				motion.speed = motion.maxSpeed;
			}
			else
			{
				// vertical movement
				if (_keyPoll.isDown(control.keyMoveUp))
				{
					// TODO rotate object facing the direction
					motion.angle = 0;
					motion.speed = motion.maxSpeed;
				}
				else if (_keyPoll.isDown(control.keyMoveDown))
				{
					// TODO rotate object facing the direction
					motion.angle = Math.PI;
					motion.speed = motion.maxSpeed;
				}
				else  // no movement
				{
					motion.speed = 0;
				}
			}
		}
	}

}
