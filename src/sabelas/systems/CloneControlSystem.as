package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.Entity;
	import ash.core.Node;
	import ash.core.NodeList;
	import ash.core.System;
	import ash.tools.ListIteratingSystem;
	import sabelas.components.CloneControl;
	import sabelas.components.Position;
	import sabelas.core.EntityCreator;
	import sabelas.input.KeyPoll;
	import sabelas.nodes.CloneControlNode;
	import sabelas.nodes.ClonesNode;
	
	/**
	 * System for controlling clone (adding or removing clones)
	 * @author Abiyasa
	 */
	public class CloneControlSystem extends System
	{
		public static const DEBUG_TAG:String = '[CloneControlSystem]';
		
		public static const MAX_NUM_OF_CLONES:int = 11;
		
		protected var _keyPoll:KeyPoll;
		protected var _entityCreator:EntityCreator;
		protected var _cloneControlNodes:NodeList;
		protected var _cloneNodes:NodeList;
		
		public function CloneControlSystem(creator:EntityCreator, keypoll:KeyPoll)
		{
			super();
			_keyPoll = keypoll;
			_entityCreator = creator;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			_cloneControlNodes = engine.getNodeList(CloneControlNode);
			_cloneNodes = engine.getNodeList(ClonesNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_cloneControlNodes = null;
			_cloneNodes = null;
		}
		
		override public function update(time:Number):void
		{
			super.update(time);
		
			var cloneControlNode:CloneControlNode;
			var cloneControl:CloneControl;
			for (cloneControlNode = _cloneControlNodes.head; cloneControlNode; cloneControlNode = cloneControlNode.next)
			{
				// detect click button
				cloneControl = cloneControlNode.cloneControl;
				if (cloneControl.cloneTriggered)
				{
					if (_keyPoll.isUp(cloneControl.keyAddClone))
					{
						// key clicked is detected
						cloneControl.cloneTriggered = false;
						
						doClone(cloneControlNode);
					}
				}
				else if (_keyPoll.isDown(cloneControl.keyAddClone))
				{
					// not yet trigger, wait for key release
					cloneControl.cloneTriggered = true;
				}
			}
		}
		
		/**
		 * Make a clone
		 */
		protected function doClone(cloneControlNode:CloneControlNode):void
		{
			trace(DEBUG_TAG, 'cloning an item');
			
			// loop clones to count total clones
			// TODO use signal nodeAdded & nodeRemoved
			var clones:ClonesNode;
			var numOfClones:int = 0;
			for (clones = _cloneNodes.head; clones; clones = clones.next)
			{
				numOfClones++;
			}
			
			// create clone from the leader
			if (numOfClones < MAX_NUM_OF_CLONES)
			{
				trace(DEBUG_TAG, 'cloning from the leader. NUm of clones before cloning=' + numOfClones);
				
				// TODO create clone behind the leader (use leader's moving direction)
				var leaderPosition:Position = cloneControlNode.position;
				_entityCreator.createHero(leaderPosition.position.x, leaderPosition.position.y - 300, true);
			}
			else
			{
				trace(DEBUG_TAG, 'CANNOT clone anymore, too much clones=' + numOfClones);
			}
		}
	}

}
