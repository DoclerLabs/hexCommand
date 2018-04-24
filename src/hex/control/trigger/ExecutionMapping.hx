package hex.control.trigger;

import hex.control.guard.IGuard;
import hex.control.payload.ExecutionPayload;
import hex.di.ClassName;
import hex.di.ClassRef;
import hex.di.MappingName;
using tink.CoreApi;

/**
 * ...
 * @author Francis Bourre
 */
class ExecutionMapping<ResultType> 
{
	var _commandClass 		: Class<Command<ResultType>>;
	var _guards 			: Array<Class<IGuard>>;
	var _payloads 			: Array<ExecutionPayload>;
	var _handlers 			: Array<Callback<Outcome<ResultType, Error>>>;


	public function new( commandClass : Class<Command<ResultType>> ) 
	{
		this._commandClass = commandClass;
	}
	
	public function getCommandClass() : Class<Command<ResultType>>
	{
		return this._commandClass;
	}
	
	@:isVar public var hasGuard( get, null ) : Bool;
	function get_hasGuard() : Bool
	{
		return this._guards != null;
	}
	
    public function getGuards() : Array<Class<IGuard>>
    {
        return this._guards;
    }
	
	public function withGuard( guard : Class<IGuard> ) : ExecutionMapping<ResultType> 
    {
        if ( this._guards == null )
        {
            this._guards = new Array<Class<IGuard>>();
        }

        this._guards.push( guard );
        return this;
    }
	
	@:isVar public var hasPayload( get, null ) : Bool;
	function get_hasPayload() : Bool
	{
		return this._payloads != null;
	}

    public function getPayloads() : Array<ExecutionPayload>
    {
        return this._payloads;
    }
	
	public function asPayload<T>( data : T, type : ClassRef<T>, ?name : MappingName, ?className : ClassName ) : ExecutionMapping<ResultType> 
    {
		return this.withPayload( { data: data, type: type, name: name, className: className } );
	}

    public function withPayload<T>( payload : Payload<T> ) : ExecutionMapping<ResultType> 
    {
        if ( this._payloads == null )
        {
            this._payloads = new Array<ExecutionPayload>();
        }

        this._payloads.push( payload );
        return this;
    }
	
	public function getHandlers() : Array<Callback<Outcome<ResultType, Error>>>
    {
        return this._handlers;
    }
	
	@:isVar public var hasHandler( get, null ) : Bool;
	function get_hasHandler() : Bool return this._handlers != null;
	
	public function withHandler( handler : Callback<Outcome<ResultType, Error>> ) : ExecutionMapping<ResultType> 
    {
        if ( this._handlers == null ) this._handlers = [];
        this._handlers.push( handler );
        return this;
    }
}