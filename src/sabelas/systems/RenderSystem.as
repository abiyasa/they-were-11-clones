package sabelas.systems
{
	import sabelas.components.Display;
	import sabelas.components.Position;
	import sabelas.nodes.RenderNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	/**
	 * Render system for Starling
	 *
	 * @author Abiyasa
	 */
	public class RenderSystem extends System
	{
		private var _container:DisplayObjectContainer;
		private var nodes:NodeList;
		
		public function RenderSystem(container:DisplayObjectContainer)
		{
			_container = container;
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			nodes = engine.getNodeList(RenderNode);
			for(var node:RenderNode = nodes.head; node; node = node.next)
			{
				addToDisplay(node);
			}
			nodes.nodeAdded.add(addToDisplay);
			nodes.nodeRemoved.add(removeFromDisplay);
		}
		
		private function addToDisplay(node:RenderNode):void
		{
			_container.addChild(node.display.displayObject);
		}
		
		private function removeFromDisplay(node:RenderNode):void
		{
			_container.removeChild(node.display.displayObject);
		}
		
		override public function update(time:Number):void
		{
			var node:RenderNode;
			var position:Position;
			var display:Display;
			var displayObject:DisplayObject;
			
			for(node = nodes.head; node; node = node.next)
			{
				display = node.display;
				displayObject = display.displayObject;
				position = node.position;
				
				displayObject.x = position.position.x;
				displayObject.y = position.position.y;
				displayObject.rotation = position.rotation;
			}
		}

		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			nodes = null;
		}
	}
}
