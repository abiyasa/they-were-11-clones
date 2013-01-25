package sabelas.systems
{
	import sabelas.components.Ascension;
	import sabelas.components.Position;
	import sabelas.nodes.AscensionNode;
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;

	/**
	 * System which process ascending (flying up) entity.
	 *
	 * @author Abiyasa
	 */
	public class AscensionSystem extends System
	{
		private var nodes:NodeList;
		
		public function AscensionSystem()
		{
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			nodes = engine.getNodeList(AscensionNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			nodes = null;
		}
		
		override public function update(time:Number):void
		{
			var position:Position;
			var ascension:Ascension;
			for(var node:AscensionNode = nodes.head; node; node = node.next)
			{
				// update ascension speed, accelerate
				ascension = node.ascension;
				if (ascension.ascendingSpeed < ascension.ascendingMaxSpeed)
				{
					ascension.ascendingSpeed += ascension.ascendingAcceleration;
				}
				
				// update position based on ascension speed
				node.position.height += ascension.ascendingSpeed;
				
			}
		}

	}
}
