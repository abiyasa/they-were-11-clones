package sabelas.systems
{
	import away3d.containers.View3D;
	import away3d.tools.utils.Drag3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import sabelas.components.Gun;
	import sabelas.components.Position;
	import sabelas.components.MouseControl;
	import sabelas.nodes.MouseControlNode;
	import ash.core.Engine;
	import ash.tools.ListIteratingSystem;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * System for updating object rotation and action based on mouse position/button click
	 *
	 * @author Abiyasa
	 */
	public class MouseControlSystem extends ListIteratingSystem
	{
		private var _container:DisplayObjectContainer;
		private var _lastPosX:Number;
		private var _lastPosY:Number;
		private var _isTriggered:Boolean;
		private var _drag3D:Drag3D;
		
		public function MouseControlSystem(container:DisplayObjectContainer, view3D:View3D)
		{
			super(MouseControlNode, updateNode);
			
			_container = container;
			_container.addEventListener(TouchEvent.TOUCH, onTouch);
			_drag3D = new Drag3D(view3D, null, Drag3D.PLANE_XZ);
			_lastPosX = _container.stage.stageWidth / 2;
			_lastPosY = 0;
			_isTriggered = false;
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			
			_container.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_container);
			if (touch == null)
			{
				return;
			}
			
			switch (touch.phase)
			{
			case TouchPhase.BEGAN:
				_isTriggered = true;
				break;
				
			case TouchPhase.HOVER:
				_lastPosX = touch.globalX;
				_lastPosY = touch.globalY;
				break;
			
			case TouchPhase.ENDED:
				_lastPosX = touch.globalX;
				_lastPosY = touch.globalY;
				_isTriggered = false;
				break;
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
				
			// handle gun
			var gun:Gun = node.gun;
			gun.shooting = _isTriggered;
			gun.timeSinceLastShot += time;
			if (_isTriggered && gun.timeSinceLastShot >= gun.minimumShotInterval)
			{
				// TODO shoot the bullet
				//creator.createUserBullet( gun, position );
				trace('BANG! Don\'t shoot me bro!');
				gun.timeSinceLastShot = 0;
			}
		}
	}

}
