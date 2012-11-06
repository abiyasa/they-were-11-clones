package mobi.papatong.sabelas.systems
{
	import mobi.papatong.sabelas.components.Display;
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.nodes.RenderNode;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
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
		
		override public function addToGame(game:Game):void
		{
			nodes = game.getNodeList(RenderNode);
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

		override public function removeFromGame(game:Game):void
		{
			nodes = null;
		}
	}
}
