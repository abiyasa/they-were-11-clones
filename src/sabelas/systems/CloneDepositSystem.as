package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import flash.geom.Point;
	import sabelas.components.Position;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.CloneDepositNode;
	
	/**
	 * System which process each clone deposit.
	 * If hero hits the clone deposit, check the number of clones & deposit clones.
	 * Also remove and add clone deposit randomly
	 *
	 * @author Abiyasa
	 */
	public class CloneDepositSystem extends System
	{
		private var _entityCreator:EntityCreator;
		private var _deposits:NodeList;
		
		public function CloneDepositSystem(creator:EntityCreator)
		{
			super();
			_entityCreator = creator;
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_deposits = engine.getNodeList(CloneDepositNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_deposits = null;
		}
		
		override public function update(time:Number):void
		{
			// only check head
			var enemySpawnNode:CloneDepositNode = _deposits.head;
			if (enemySpawnNode == null)
			{
				// TODO need delay before next deposit generation
				
				// TODO no more deposit, generate more deposit arena,
				//OR generate win condition
				//_entityCreator.createCloneDeposit();
			}
			else
			{
				// TODO loop through the clones, check if they are inside the arena
			}
		}
		
	}

}
