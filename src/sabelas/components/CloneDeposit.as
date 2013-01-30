package sabelas.components
{
	/**
	 * Component for entity to deposit clones
	 *
	 * @author Abiyasa
	 */
	public class CloneDeposit
	{
		public var clonesRequired:int;
		
		public function CloneDeposit(clonesRequired:int)
		{
			this.clonesRequired = clonesRequired;
		}
		
		// TODO below might be on different component?
		/** For generating entity states */
		public static var STATES_INFO:Array = [
			'00', '01', '02', '03', '04', '05', '06', '07',
			'08', '09', '10', '11' ];
		
		/**
		 * Generate entity state string based on remaining clones require
		 * @return
		 */
		public function getStateString():String
		{
			var initState:String = 'require';
			if ((clonesRequired > 0) && (clonesRequired < STATES_INFO.length))
			{
				initState += STATES_INFO[clonesRequired];
			}
			else
			{
				initState += '01';
			}
			
			return initState;
		}
	}

}
