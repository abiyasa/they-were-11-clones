package sabelas.systems
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import flash.geom.Vector3D;
	import sabelas.components.Display3D;
	import sabelas.components.Position;
	import sabelas.nodes.RenderNode3D;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;

	public class RenderSystem3D extends System
	{
		private var nodes:NodeList;
		public var _view3D:View3D;
		private var _scene:Scene3D;
		
		public function RenderSystem3D(view3D:View3D)
		{
			_view3D = view3D;
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_scene = _view3D.scene;
			
			nodes = engine.getNodeList(RenderNode3D);
			for(var node:RenderNode3D = nodes.head; node; node = node.next)
			{
				addToDisplay(node);
			}
			nodes.nodeAdded.add(addToDisplay);
			nodes.nodeRemoved.add(removeFromDisplay);
		}
		
		private function addToDisplay(node:RenderNode3D):void
		{
			_scene.addChild(node.display3D.object3D);
		}
		
		private function removeFromDisplay(node:RenderNode3D):void
		{
			_scene.removeChild(node.display3D.object3D);
		}
		
		override public function update(time:Number):void
		{
			var node:RenderNode3D;
			var position:Position;
			var display3D:Display3D;
			var object3D:ObjectContainer3D;
			for(node = nodes.head; node; node = node.next)
			{
				display3D = node.display3D;
				object3D = display3D.object3D;
				position = node.position;
				
				object3D.x = position.position.x;
				object3D.z = position.position.y;
				if (position.hasHeight)
				{
					object3D.y = position.height;
				}
				object3D.rotationY = position.rotation * 180 / Math.PI;
			}
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			nodes = null;
			
			_view3D = null;
			_scene = null;
		}
	}
}
