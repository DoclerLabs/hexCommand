package hex.control.trigger;

/**
 * ...
 * @author Francis Bourre
 */
class CommandTriggerSuite
{
	@Suite( "Trigger" )
    public var list : Array<Class<Dynamic>> = 
	[
		CommandTriggerAnnotationReplaceTest,
		CommandTriggerTest, 
		CommandTriggerUserCaseTest,
		MacroCommandTest
	];
}