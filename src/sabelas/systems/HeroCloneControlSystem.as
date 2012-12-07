package sabelas.systems
{
	import ash.core.Engine;
	import ash.tools.ListIteratingSystem;
	import sabelas.components.HeroCloneControl;
	import sabelas.core.EntityCreator;
	import sabelas.input.KeyPoll;
	import sabelas.nodes.HeroCloneControlNode;
	
	/**
	 * System for controlling hero clone (adding or removing clones)
	 * @author Abiyasa
	 */
	public class HeroCloneControlSystem extends ListIteratingSystem
	{
		protected var _keyPoll:KeyPoll;
		protected var _entityCreator:EntityCreator;
		
		public function HeroCloneControlSystem(creator:EntityCreator, keypoll:KeyPoll)
		{
			super(HeroCloneControlNode, updateNode);
			_keyPoll = keypoll;
			_entityCreator = creator;
		}

		private function updateNode(node:HeroCloneControl, time:Number):void
		{
			if (_keyPoll.isDown(node.keyAddClone))
			{
				// TODO call entity creator to add clone
			}
		}
	}

}