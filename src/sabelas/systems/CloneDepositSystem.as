package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.NodeList;
	import ash.core.System;
	import flash.geom.Point;
	import sabelas.components.Position;
	import sabelas.core.EntityCreator;
	import sabelas.nodes.CloneDepositNode;
	import sabelas.nodes.ClonesNode;
	
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
		private var _clones:NodeList;
		
		public function CloneDepositSystem(creator:EntityCreator)
		{
			super();
			_entityCreator = creator;
		}
		
		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			_deposits = engine.getNodeList(CloneDepositNode);
			_clones = engine.getNodeList(ClonesNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_deposits = null;
		}
		
		override public function update(time:Number):void
		{
			// only check head
			var cloneDeposit:CloneDepositNode = _deposits.head;
			if (cloneDeposit == null)
			{
				// TODO need delay before next deposit generation
				
				// TODO no more deposit, generate more deposit arena,
				//OR generate win condition
				//_entityCreator.createCloneDeposit();
			}
			else
			{
				var depositRadius:Number = cloneDeposit.collision.radius;
				var depositPos:Point = cloneDeposit.position.position;
				
				// loop through the clones, check if they are inside the arena
				for (var cloneNode:ClonesNode = _clones.head; cloneNode; cloneNode = cloneNode.next)
				{
					if (Point.distance(depositPos, cloneNode.position.position) <=
						(depositRadius + cloneNode.collision.radius))
					{
						trace('a clone is inside deposit arena!');
					
						// TODO remove clone's component clone
						// TODO add component for leviation to clone
						_entityCreator.destroyEntity(cloneNode.entity);
						
						// TODO add score to game status
						
						// deposit clone
						cloneDeposit.cloneDeposit.clonesRequired--;
						if (cloneDeposit.cloneDeposit.clonesRequired <= 0)
						{
							// remove deposit place
							_entityCreator.destroyEntity(cloneDeposit.entity);
							break;
						}
					}
				}
			}
		}
		
	}

}
