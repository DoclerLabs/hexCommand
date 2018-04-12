package hex.control.trigger.mock;

import hex.collection.Locator;
import hex.control.async.Nothing;
import hex.control.trigger.CommandTriggerTest;

using tink.CoreApi;

/**
 * @author Francis Bourre
 */
interface IMockController
{
	function print() : Promise<Nothing>;
	function say( text : String, sender : CommandTriggerTest, anotherText : String, locator : Locator<String, Bool> ) : Promise<String>;
	function sum( a : Int, b : Int ) : Int ;
}