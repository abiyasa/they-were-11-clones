package mobi.papatong.sabelas.components
{
	/**
	 * Component for marking that an entity belongs to hero clones group
	 *
	 * @author Abiyasa
	 */
	public class HeroClone
	{
		public var isLeader:Boolean = false;
		
		// Total repulsive & attraction force, calculated by HeroClonePositioningSystem
		// TODO should separate to a component
		public var cloneForceX:Number;
		public var cloneForceY:Number;
		
		public function HeroClone(isLeader:Boolean = false)
		{
			this.isLeader = isLeader;
			
			cloneForceX = 0;
			cloneForceY = 0;
		}
	}

}
