package sabelas.systems
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import sabelas.components.Motion;
	import sabelas.components.Position;
	import sabelas.nodes.MotionNode;
	import ash.tools.ListIteratingSystem;
	
	/**
	 * System for updating object position based on its motion data
	 *
	 * @author Abiyasa
	 */
	public class MotionSystem extends ListIteratingSystem
	{
		protected var _arena:Rectangle;
		protected var _hasArena:Boolean;
		protected var _tempPoint:Point = new Point();
		
		public function MotionSystem(arena:Rectangle = null)
		{
			super(MotionNode, updateNode);
			_arena = arena;
			_hasArena = (_arena != null);
		}
		
		private function updateNode(node:MotionNode, time:Number):void
		{
			var motion:Motion = node.motion;
			
			// calculate speed
			var position:Point = node.position.position;
			_tempPoint.setTo(position.x + motion.calculateDeltaX(time),
				position.y + motion.calculateDeltaY(time));
			
			// make sure new position is inside the arena
			if (_hasArena)
			{
				if (_arena.containsPoint(_tempPoint))
				{
					position.copyFrom(_tempPoint);
				}
			}
			else
			{
				position.copyFrom(_tempPoint);
			}
			motion.resetForce();
		}
	}

}
