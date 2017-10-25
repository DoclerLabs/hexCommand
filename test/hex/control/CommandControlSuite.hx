package hex.control;

import hex.control.trigger.CommandTriggerSuite;

/**
 * ...
 * @author Francis Bourre
 */
class CommandControlSuite
{
	@Suite( "Control" )
    public var list : Array<Class<Dynamic>> = 
	[ 
		CommandTriggerSuite
	];
}