package sabelas.components
{
	/**
	 * Component to item with energy/life.
	 * Entity will be removed when energy is 0
	 *
	 * @author Abiyasa
	 */
	public class Energy
	{
		public var value:int;
		
		public function Energy(value:int)
		{
			this.value = value;
		}
		
	}

}
