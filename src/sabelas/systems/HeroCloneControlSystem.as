package sabelas.systems
{
	import ash.core.Engine;
	import ash.core.Node;
	import ash.core.NodeList;
	import ash.core.System;
	import ash.tools.ListIteratingSystem;
	import sabelas.components.HeroClone;
	import sabelas.components.HeroCloneControl;
	import sabelas.core.EntityCreator;
	import sabelas.input.KeyPoll;
	import sabelas.nodes.HeroCloneControlNode;
	import sabelas.nodes.HeroClonesNode;
	
	/**
	 * System for controlling hero clone (adding or removing clones)
	 * @author Abiyasa
	 */
	public class HeroCloneControlSystem extends System
	{
		public static const DEBUG_TAG:String = '[HeroCloneControlSystem]';
		
		public static const MAX_NUM_OF_CLONES:int = 11;
		
		protected var _keyPoll:KeyPoll;
		protected var _entityCreator:EntityCreator;
		protected var _heroCloneControlNodes:NodeList;
		protected var _heroCloneNodes:NodeList;
		
		public function HeroCloneControlSystem(creator:EntityCreator, keypoll:KeyPoll)
		{
			super();
			_keyPoll = keypoll;
			_entityCreator = creator;
		}

		override public function addToEngine(engine:Engine):void
		{
			super.addToEngine(engine);
			
			_heroCloneControlNodes = engine.getNodeList(HeroCloneControlNode);
			_heroCloneNodes = engine.getNodeList(HeroClonesNode);
		}
		
		override public function removeFromEngine(engine:Engine):void
		{
			super.removeFromEngine(engine);
			_heroCloneControlNodes = null;
			_heroCloneNodes = null;
		}
		
		override public function update(time:Number):void
		{
			super.update(time);
		
			var cloneControlNode:HeroCloneControlNode;
			var cloneControl:HeroCloneControl;
			for (cloneControlNode = _heroCloneControlNodes.head; cloneControlNode; cloneControlNode = cloneControlNode.next)
			{
				// detect click button
				cloneControl = cloneControlNode.heroCloneControl;
				if (cloneControl.cloneTriggered)
				{
					if (_keyPoll.isUp(cloneControl.keyAddClone))
					{
						// key clicked is detected
						cloneControl.cloneTriggered = false;
						
						doClone();
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
		protected function doClone():void
		{
			trace(DEBUG_TAG, 'cloning an item');
			
			// loop hero clones find the leader & count total clones
			var clones:HeroClonesNode;
			var leaderNode:HeroClonesNode = null;
			var numOfClones:int = 0;
			for (clones = _heroCloneNodes.head; clones; clones = clones.next)
			{
				if (clones.heroClone.isLeader)
				{
					leaderNode = clones;
				}
				numOfClones++;
			}
			
			// create clone from leader
			if ((leaderNode != null) && (numOfClones < MAX_NUM_OF_CLONES))
			{
				trace(DEBUG_TAG, 'cloning from the leader. NUm of clones before cloning=' + numOfClones);
				
				// TODO create clone behind the leader (use leader's moving direction)
				_entityCreator.createHero(leaderNode.position.position.x,
					leaderNode.position.position.y - 300, true);
			}
			else
			{
				trace(DEBUG_TAG, 'CANNOT clone anymore, too much clones=' + numOfClones);
			}
		}
	}

}
