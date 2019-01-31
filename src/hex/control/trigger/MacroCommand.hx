package hex.control.trigger;

import hex.control.guard.GuardUtil;
import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.di.IDependencyInjector;

using tink.CoreApi;
using hex.error.Error;

/**
 * ...
 * @author Francis Bourre
 */
class MacroCommand<ResultType> extends Command<ResultType>
{
	var _injector 			: IDependencyInjector;
	var _payloads 			: Array<ExecutionPayload>;
	var _mappings 			: Array<ExecutionMapping<Dynamic>> = [];
	var _parallelExecution	: Int;
	
	var _result				: ResultType;
	
	public function new() 
	{
		super();
		
		this.isAtomic 			= true;
		this.isInSequenceMode 	= true;
	}
	
	function _setResult( result : ResultType ) : Void
	{
		this._result = result;
	}
	
	@Inject
	public function preExecute( injector : IDependencyInjector, payloads : Array<ExecutionPayload> ) : Void
	{
		this._injector = injector;
		this._payloads = payloads;
		this._prepare();
	}
	
	function _prepare() : Void
	{
		throw new VirtualMethodException();
	}

	@:final 
	override public function execute() : Void
	{
		this._parallelExecution = this._mappings.length;
		this._executeNextCommand();
	}

	public function add<ResultType>( commandClass : Class<Command<ResultType>> ) : ExecutionMapping<ResultType>
	{
		if ( this.isWaiting )
		{
			var mapping = new ExecutionMapping( commandClass );
			this._mappings.push( mapping );
			return mapping;
		}
		else
		{
			throw new IllegalStateException( 'Macro has already ended' );
		}
	}
	
	function _executeNextCommand() : Void
	{
		if ( this._mappings.length > 0 )
		{
			var command = MacroCommand.getCommand( this._injector, this._mappings.shift(), this._payloads );
			
			if ( command != null )
			{
				command.setOwner( _owner );
				command.execute();
				
				if ( this.isInSequenceMode )
				{
					command.handle( this._whenDone );
				}
				else
				{
					command.handle( this._whenParallelDone );		
					this._executeNextCommand();
				}
			}
			else
			{
				//command failure
				if ( this.isAtomic ) this._fail( new Error( 'MacroCommand fails' ) );
					else this._executeNextCommand();
			}
			
		}
		else if ( this.isInSequenceMode )
		{
			this._complete( this._result );
		}
	}
	
	function _whenDone( outcome ) : Void
	{
		switch( outcome : Outcome<ResultType, Error> )
		{
			case Success( result ): 
				this._executeNextCommand();
		
			case Failure( error ): 
				var callback = switch( error.code )
				{
					case Command.OperationCancelled: 	this._cancel.bind();
					default: 							this._fail.bind( error );
				}
				
				if ( this.isAtomic ) callback();
					else this._executeNextCommand();
		}
	}
	
	function _whenParallelDone( outcome )
	{
		switch( outcome : Outcome<ResultType, Error> )
		{
			case Success( result ): 
				this._parallelExecution--;
				if ( this._parallelExecution == 0 )
				{
					this._parallelExecution = -1;
					this._complete( this._result );
				}
		
			case Failure( error ): 
				var callback = switch( error.code )
				{
					case Command.OperationCancelled: 	this._cancel.bind();
					default: 							this._fail.bind( error );
				}
				
				this._parallelExecution--;
		
				if ( this.isAtomic && this._parallelExecution > -1 )
				{
					this._parallelExecution = -1;
					callback();
				}
				else if( this._parallelExecution == 0 )
				{
					this._complete( null );
				}
		}
	}
	
	@:isVar public var isAtomic( get, set ) : Bool;
	function get_isAtomic() return this.isAtomic;
	
	function set_isAtomic( value : Bool ) : Bool
	{
		this.isAtomic = value;
		return value;
	}
	
	@:isVar public var isInSequenceMode( get, set ) : Bool;
	function get_isInSequenceMode() return this.isInSequenceMode;
	
	function set_isInSequenceMode( value : Bool ) : Bool
	{
		this.isInSequenceMode = value;
		return value;
	}
	
	@:isVar
	public var isInParallelMode( get, set ) : Bool;
	function get_isInParallelMode() return !this.isInSequenceMode;
	
	function set_isInParallelMode( value : Bool ) : Bool
	{
		this.isInSequenceMode = !value;
		return this.isInSequenceMode;
	}
	
	static public function getCommand<ResultType>( injector : IDependencyInjector, mapping : ExecutionMapping<ResultType>, payloads : Array<ExecutionPayload> ) : Command<ResultType>
    {
		// Build payloads collection
		var mappedPayloads : Array<ExecutionPayload> = mapping.getPayloads();
		if ( mappedPayloads != null ) payloads = payloads.concat( mappedPayloads );
		
		// Map payloads
        if ( payloads != null ) PayloadUtil.mapPayload( payloads, injector );
		
		// Instantiate command
		var command : Command<ResultType> = null;
		if ( !mapping.hasGuard || GuardUtil.guardsApprove( mapping.getGuards(), injector ) )
        {
			command = injector.getOrCreateNewInstance( mapping.getCommandClass() );
		}

		// Unmap payloads
        if ( payloads != null ) PayloadUtil.unmapPayload( payloads, injector );

		//Set Promise handlers
		if ( mapping.hasHandler ) for ( handler in mapping.getHandlers() ) command.handle( handler );

		return command;
    }
}

