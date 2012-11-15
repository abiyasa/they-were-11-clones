package mobi.papatong.sabelas.systems
{
	import flash.geom.Point;
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.components.MouseControl;
	import mobi.papatong.sabelas.nodes.MouseControlNode;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.tools.ListIteratingSystem;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * System for updating object rotation and action based on mouse position/button click
	 *
	 * @author Abiyasa
	 */
	public class MouseMotionControlSystem extends ListIteratingSystem
	{
		private var _container:DisplayObjectContainer;
		private var _lastPosX:int;
		private var _lastPosY:int;
		
		public function MouseMotionControlSystem(container:DisplayObjectContainer)
		{
			super(MouseControlNode, updateNode);
			
			_container = container;
			_container.addEventListener(TouchEvent.TOUCH, onTouch);
			_lastPosX = _container.stage.stageWidth / 2;
			_lastPosY = 0;
		}
		
		override public function removeFromGame(game:Game):void
		{
			super.removeFromGame(game);
			
			_container.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_container);
			if (touch == null)
			{
				return;
			}
			
			if (touch.phase == TouchPhase.HOVER)
			{
				_lastPosX = touch.globalX;
				_lastPosY = touch.globalY;
				
				// TODO unset action to fire
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				_lastPosX = touch.globalX;
				_lastPosY = touch.globalY;
				
				// TODO set action to fire
			}
		}
		
		private function updateNode(node:MouseControlNode, time:Number):void
		{
			// facing the last stored mouse position
			// TODO node position is 3D position, convert between 3d n 2d
			var position:Position = node.position;
			var distX:Number = _lastPosX - position.position.x;
			var distY:Number = _lastPosY - position.position.y;
			position.rotation = Math.atan2(distY, distX);
			
			//trace('facing to ' + position.rotation);
		}
	}

}
