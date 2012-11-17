package mobi.papatong.sabelas.systems
{
	import away3d.containers.View3D;
	import away3d.tools.utils.Drag3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
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
		private var _lastPosX:Number;
		private var _lastPosY:Number;
		private var _drag3D:Drag3D;
		
		public function MouseMotionControlSystem(container:DisplayObjectContainer, view3D:View3D)
		{
			super(MouseControlNode, updateNode);
			
			_container = container;
			_container.addEventListener(TouchEvent.TOUCH, onTouch);
			_drag3D = new Drag3D(view3D, null, Drag3D.PLANE_XZ);
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
			// project mouse pos to plane XZ
			var pos3d:Vector3D = _drag3D.getIntersect(_lastPosX, _lastPosY);
			
			// rotate position, make it facing the last stored mouse position
			var position:Position = node.position;
			var positionPoint:Point = position.position;
			position.rotation = Math.atan2(pos3d.x - positionPoint.x,
				pos3d.z - positionPoint.y);
		}
	}

}
