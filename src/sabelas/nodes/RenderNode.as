package sabelas.nodes
{
	import sabelas.components.Display;
	import sabelas.components.Position;
	import ash.core.Node;

	/**
	 * Node for renderable item, used by RenderSystem
	 */
	public class RenderNode extends Node
	{
		public var position:Position;
		public var display:Display;
	}
}
