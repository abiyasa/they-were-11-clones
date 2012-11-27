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
		
		public function HeroClone(isLeader:Boolean = false)
		{
			this.isLeader = isLeader;
		}
	}

}
