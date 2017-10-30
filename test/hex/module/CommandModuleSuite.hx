package hex.module;

/**
 * ...
 * @author Francis Bourre
 */
class CommandModuleSuite
{
	@Suite( "Module" )
    public var list : Array<Class<Dynamic>> = [ ContextModuleTest ];
}