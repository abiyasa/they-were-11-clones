package mobi.papatong.sabelas.nodes
{
	import mobi.papatong.sabelas.components.Display;
	import mobi.papatong.sabelas.components.Position;
	import net.richardlord.ash.core.Node;

	/**
	 * Node for renderable item, used by RenderSystem
	 */
	public class RenderNode extends Node
	{
		public var position:Position;
		public var display:Display;
	}
}
