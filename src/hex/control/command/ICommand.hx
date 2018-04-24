package hex.control.command;

import hex.log.ILogger;
import hex.module.IContextModule;

/**
 * ...
 * @author Francis Bourre
 */
interface ICommand
{
	function execute() : Void;

    function getLogger() : ILogger;
	
    function getOwner() : IContextModule;

    function setOwner( owner : IContextModule ) : Void;
}
