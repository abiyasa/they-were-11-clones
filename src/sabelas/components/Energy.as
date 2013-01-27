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
		private var _value:int;
		public function get value():int { return _value; }
		
		public function Energy(value:int)
		{
			this._value = value;
		}
		
		/**
		 * Increase energy 1 level
		 */
		public function increaseEnergy():void
		{
			_value++;
		}
		
		/**
		 * decrease energy 1 level for damage.
		 */
		public function decreaseEnergy():void
		{
			_value--;
		}
		
		/**
		 * Checks if energy level is 0 or less
		 * @return
		 */
		public function isEmpty():Boolean
		{
			return (_value <= 0);
		}
	}

}
