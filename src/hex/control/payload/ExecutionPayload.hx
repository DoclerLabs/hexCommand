package hex.control.payload;

import hex.di.ClassName;
import hex.di.ClassRef;
import hex.di.MappingName;

/**
 * ...
 * @author Francis Bourre
 */
typedef ExecutionPayload = Payload<Dynamic>;

abstract Payload<T>( {data: T, type: ClassRef<T>, name: MappingName, className: ClassName} ) 
{
	inline function new( data: T, type: ClassRef<T> = null, ?name: MappingName, ?className: ClassName )
		this = { data: data, type: type, name: name, className: className };
		
	inline public function getData() return this.data;
	
	@:to function toClassRef<T>() : ClassRef<T> return this.type == null ? Type.getClass( this.data ) : this.type;
	
	@:to inline function toClassName() : ClassName return this.className;
	
	@:to inline function toName() : MappingName return this.name;
	
	@:from static inline function ofDynObject<T>( o: {data: T, type: Dynamic, name: String, className: String} ) : Payload<T>
		return new Payload( o.data, o.type, o.name!=null?o.name:'', o.className );
	
	@:from static inline function ofObject<T>( o: {data: T, type: ClassRef<T>, name: MappingName, className: ClassName} ) : Payload<T>
		return new Payload( o.data, o.type, o.name, o.className );
}