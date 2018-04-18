package hex.control.trigger;

import hex.di.IAutoInject;
import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.module.IContextModule;

/**
 * @author Francis Bourre
 */
#if !macro
@:autoBuild( hex.control.trigger.CommandTriggerBuilder.build() )
#end
interface ICommandTrigger extends IAutoInject
{
	var module     : IContextModule;
    var injector   : IDependencyInjector;
}