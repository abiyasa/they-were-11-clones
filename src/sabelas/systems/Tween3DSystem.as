package sabelas.systems
{
	import away3d.containers.ObjectContainer3D;
	import sabelas.components.Display3D;
	import sabelas.components.Tween3D;
	import sabelas.nodes.Tween3DNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;

	public class Tween3DSystem extends System
	{
		private var nodes:NodeList;
		
		public function Tween3DSystem()
		{
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			nodes = engine.getNodeList(Tween3DNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			nodes = null;
		}
		
		override public function update(time:Number):void
		{
			var node:Tween3DNode;
			var tween3D:Tween3D;
			var object3D:ObjectContainer3D;
			var tweenCompleted:Boolean;
			var propertyName:String;
			for(node = nodes.head; node; node = node.next)
			{
				tweenCompleted = false;
				tween3D = node.tween3D;
				object3D = node.display3D.object3D;
				
				// TODO check what property to tween
				// Note: right now, it's only scaling
				
				// calculate tween
				var completion:Number = tween3D.lastUpdateTime / tween3D.duration;
				if (completion >= 1.0)
				{
					// if keyframe is larger than duration, noted completed!
					tweenCompleted = true;
				}
				else
				{
					// do the tween
					var scale:Number = tween3D.fromValue + (completion * (tween3D.toValue - tween3D.fromValue));
					object3D.scaleX = scale;
					object3D.scaleX = scale;
					object3D.scaleZ = scale;
					
					//trace('tweening', 'from=' + tween3D.fromValue + 'to=' + tween3D.toValue, 'scale=' + scale, 'time=' + tween3D.lastUpdateTime);
					
					// update time
					tween3D.lastUpdateTime += time;
				}
					
				// if completed, remove component from entity
				if (tweenCompleted)
				{
					scale = tween3D.toValue;
					
					object3D.scaleX = scale;
					object3D.scaleX = scale;
					object3D.scaleZ = scale;
					
					node.entity.remove(Tween3D);
				}
			}
		}
	}
}
