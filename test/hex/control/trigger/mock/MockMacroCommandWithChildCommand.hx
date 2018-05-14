package hex.control.trigger.mock;

import hex.control.async.Nothing;
import hex.control.trigger.MacroCommand;
using tink.CoreApi;

/**
 * ...
 * @author 
 */
class MockMacroCommandWithChildCommand extends MacroCommand<Nothing>
{
	public var commandSelfReturn : MockCommandSelfReturn;
	
	override function _prepare() : Void 
	{
		add( MockCommandSelfReturn ).withHandler(
		
			function( outcome )
			{
				switch( outcome )
				{
					case Success( command ): this.commandSelfReturn = command;
					case _ :
				}
			});
	}
}