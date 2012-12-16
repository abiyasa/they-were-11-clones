package sabelas.components
{
	import ash.core.Entity;
	
	/**
	 * Component for entity which chase an entity
	 *
	 * @author Abiyasa
	 */
	public class Chaser
	{
		public var preyPosition:Position;
		
		public function Chaser(preyPosition:Position)
		{
			this.preyPosition = preyPosition;
		}
		
	}

}
