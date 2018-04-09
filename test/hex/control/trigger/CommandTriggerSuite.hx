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
		CommandTest,
		CommandTriggerAnnotationReplaceTest,
		CommandTriggerTest, 
		CommandTriggerUserCaseTest,
		MacroCommandTest
	];
}