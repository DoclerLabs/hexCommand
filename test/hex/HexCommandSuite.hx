package hex;

import hex.control.CommandControlSuite;
import hex.log.MVCLogSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexCommandSuite
{
	@Suite( "HexCommand" )
    public var list : Array<Class<Dynamic>> = [
		CommandControlSuite,
		MVCLogSuite
	];
}
