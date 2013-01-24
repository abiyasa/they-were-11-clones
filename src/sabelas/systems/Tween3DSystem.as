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
			var propertyName:String;
			var tweenValue:Number;
			for(node = nodes.head; node; node = node.next)
			{
				tween3D = node.tween3D;
				
				// calculate tween
				var percentage:Number = tween3D.progressPercentage;
				if (percentage >= 1.0)
				{
					// tween is completed!
					tweenValue = tween3D.toValue;
					
					// stop tweening
					node.entity.remove(Tween3D);
				}
				else  // still tweening
				{
					tweenValue = tween3D.calculateTween();
					tween3D.updateTime(time);
				}

				// TODO check what property to tween
				// Note: right now, it's only scaling
				
				// apply tween value to the object
				object3D = node.display3D.object3D;
				object3D.scaleX = tweenValue;
				object3D.scaleX = tweenValue;
				object3D.scaleZ = tweenValue;
					
				//trace('tweening', 'from=' + tween3D.fromValue + 'to=' + tween3D.toValue, 'scale=' + scale, 'time=' + tween3D.lastUpdateTime);
			}
		}
	}
}
