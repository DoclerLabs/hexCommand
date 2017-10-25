package hex;

import hex.control.CommandControlSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexCommandSuite
{
	@Suite( "HexCommand" )
    public var list : Array<Class<Dynamic>> = [
		CommandControlSuite
	];
}
