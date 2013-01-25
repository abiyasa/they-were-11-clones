package sabelas.components
{
	import ash.fsm.EntityStateMachine;
	
	/**
	 * General component to hold & give access to entity state machine
	 *
	 * @author Abiyasa
	 */
	public class StateMachine
	{
		public var stateMachine:EntityStateMachine;
		
		public function StateMachine(stateMachine:EntityStateMachine)
		{
			this.stateMachine = stateMachine;
		}
		
	}

}
