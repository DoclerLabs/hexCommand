package hex.control.trigger;

import hex.control.async.AsyncResult;
import hex.control.command.ICommand;
import hex.di.IDependencyInjector;
import hex.di.IInjectorContainer;
import hex.error.VirtualMethodException;
import hex.log.ILogger;
import hex.module.IContextModule;

using tink.CoreApi;
/**
 * ...
 * @author Francis Bourre
 */
class Command<ResultType>
	implements ICommand 
	implements IInjectorContainer
{
	#if macro
	@:deprecated('if you see this, something is wrong')
	public function acceptInjector(i:IDependencyInjector) {}
	#end
	public static inline var OperationCancelled = 20000;
	
	var _promise 			: Promise<ResultType>;
	var _owner 				: IContextModule;
	var _complete 			: ResultType -> Void;
	var _fail 				: Error -> Void;
	var _cancel 			: Void -> Void;
	var __result 			: AsyncResult<ResultType, Error>;
	
	@Inject
	@Optional(true)
	public var logger		: ILogger;
	
	public function new() 
	{
		this.__result = Result.WAITING;
		
		this._promise = Future.async
		(
			function( handler : Outcome<ResultType, Error>->Void ) : Void
			{
				this._complete = function ( result : ResultType ) 
				{
					this.__result = result;
					handler( Success( result ) );
				}
				
				this._fail = function ( error: Error ) 
				{
					this.__result = error;
					handler( Failure( error ) );
				}
				
				this._cancel = function () 
				{
					this.__result = Result.CANCELLED;
					handler( Failure( new Error( OperationCancelled, 'Execution was already cancelled' ) ) );//TODO add cancel exception
				}
			}
		);
	}
	
	public function execute() : Void throw new VirtualMethodException();

	public var promise( get, null ) : Promise<ResultType>;
	@:final 
    function get_promise() : Promise<ResultType> return this._promise;
	
	public var isWaiting( get, null ) : Bool;
	@:final 
    function get_isWaiting() : Bool
	{
		switch( this.__result )
		{
			case Result.WAITING:
				return true;
				
			case _:
				return false;
		}
	}
	
	public var isCompleted( get, null ) : Bool;
	@:final 
    function get_isCompleted() : Bool
	{
		switch( this.__result )
		{
			case Result.DONE( result ):
				return true;
				
			case _:
				return false;
		}
	}
	
	public var isFailed( get, null ) : Bool;
	@:final 
    function get_isFailed() : Bool
	{
		switch( this.__result )
		{
			case Result.FAILED( error ):
				return true;
				
			case _:
				return false;
		}
	}
	
	public var isCancelled( get, null ) : Bool;
	@:final 
    function get_isCancelled() : Bool
	{
		switch( this.__result )
		{
			case Result.CANCELLED:
				return true;
				
			case _:
				return false;
		}
	}
	
	public function handle( callback : Callback<Outcome<ResultType, Error>> )
	{
		return this._promise.handle( callback );
	}

	public function getLogger() : ILogger 
	{
		return logger == null ? this._owner.getLogger() : logger;
	}
	
	public function getOwner() : IContextModule 
	{
		return this._owner;
	}
	
	public function setOwner( owner : IContextModule ) : Void 
	{
		this._owner = owner;
	}
	
	public function getResult() : Array<Dynamic>
	{
		return null;
	}
}