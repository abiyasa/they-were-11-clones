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
			
			// loop hero clones find the leader
			var clones:HeroClonesNode;
			for (clones = _heroCloneNodes.head; clones; clones = clones.next)
			{
				if (clones.heroClone.isLeader)
				{
					trace(DEBUG_TAG, 'git the leader. clone 1');
					
					// create clone from leader
					
					// TODO create clone behind the leader (use leader's moving direction)
					_entityCreator.createHero(clones.position.position.x,
						clones.position.position.y - 300, true);
					break;
				}
			}
		}
	}

}