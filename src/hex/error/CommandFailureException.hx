package hex.error;

import haxe.PosInfos;
using tink.CoreApi;

/**
 * ...
 * @author Francis Bourre
 */
class CommandFailureException extends Error
{
    public function new ( message : String, ?posInfos : PosInfos ) super( code, message, pos );
}