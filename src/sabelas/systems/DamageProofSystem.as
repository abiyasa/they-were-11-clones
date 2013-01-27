package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.Node;
	import ash.core.NodeList;
	import ash.core.System;
	import sabelas.components.DamageProof;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.DamageProofNode;
	
	/**
	 * System for handling damage proof entities.
	 * Will remove damage proof from entity when it's done
	 *
	 * @author Abiyasa
	 */
	public class DamageProofSystem extends System
	{
		public static const DEBUG_TAG:String = '[DamageProofSystem]';
		
		protected var _entityCreator:EntityCreator;
		private var _damageProofNodes:NodeList;
		
		public function DamageProofSystem(creator:EntityCreator)
		{
			super();
			_entityCreator = creator;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			_damageProofNodes = engine.getNodeList(DamageProofNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			
			_damageProofNodes = null;
		}
		
		override public function update(time:Number):void
		{
			super.update(time);
			
			var node:DamageProofNode;
			var damageProof:DamageProof;
			for (node = _damageProofNodes.head; node; node = node.next)
			{
				damageProof = node.damageProof;
				if (damageProof.isTimeOver())
				{
					// remove damage proof
					node.entity.remove(DamageProof);
					
					// reset blink
					node.display3D.object3D.visible = true;
				}
				else
				{
					damageProof.update(time);
					
					if (damageProof.isTimeToBlink())
					{
						// blink
						node.display3D.object3D.visible = !node.display3D.object3D.visible;
						damageProof.resetBlinkingTime();
					}
				}
			}
		}
	}

}
