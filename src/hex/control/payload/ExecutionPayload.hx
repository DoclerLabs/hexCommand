package hex.control.payload;

import hex.di.ClassName;
import hex.di.ClassRef;
import hex.di.MappingName;
import hex.error.NullPointerException;

/**
 * ...
 * @author Francis Bourre
 */
typedef ExecutionPayload = Payload<Dynamic>;

abstract Payload<T>( {data: T, type: ClassRef<T>, name: MappingName, className: ClassName} ) 
{
	inline public function new( data: T, type: ClassRef<T> = null, ?name: MappingName )
		this = { data: data, type: type, name: '' + name, className: null };
		
	inline public function getData() return this.data;
	
	@:to function toClassRef<T>() : ClassRef<T> return this.type == null ? Type.getClass( this.data ) : this.type;
	
	@:to inline function toClassName() : ClassName return this.className;
	
	@:to inline function toName() : MappingName return this.name;
	
	
	@:from static inline function ofObject<T>( o: {data: T, type: ClassRef<T>, name: MappingName, className: ClassName} ) : Payload<T>
		return new Payload( o.data, o.type, o.name ).withClassName( o.className );

    inline public function withName( name : MappingName ) : Payload<T>
    {
        this.name = name;
        return cast this;
    }
	
	inline public function withClassName( className : ClassName ) : Payload<T>
    {
        this.className = ('' + className).split( " " ).join( '' );
        return cast this;
    }
}