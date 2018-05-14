package hex.control;

/**
 * ...
 * @author Francis Bourre
 */
class CommandControlSuite
{
	@Suite( "Control" )
    public var list : Array<Class<Dynamic>> = 
	[ 
		hex.control.guard.CoreGuardSuite,
		hex.control.payload.CorePayloadSuite,
		hex.control.trigger.CommandTriggerSuite
	];
}