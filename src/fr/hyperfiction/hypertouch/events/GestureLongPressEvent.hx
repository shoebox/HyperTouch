package fr.hyperfiction.hypertouch.events;

import fr.hyperfiction.hypertouch.events.GesturePhases;
import nme.events.Event;

/**
 * ...
 * @author shoe[box]
 */

class GestureLongPressEvent extends Event{
	
	public var iPhase      : Int;
	public var iPointerId  : Int;	
	public var sizeX       : Float;
	public var sizeY       : Float;
	public var stageX      : Float;
	public var stageY      : Float;
	public var fPressure   : Float;

	public static inline var LONG_PRESS : String = 'GestureLongPressEvent_LONG_PRESS';
	
	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( 
								type      : String,
								iPhase    : Int , 
								iPointerId: Int , 
								stageX    : Float , 
								stageY    : Float , 
								fPressure : Float , 
								sizeX     : Float , 
								sizeY     : Float   
							 ) {
			super( type );
			this.iPhase     = iPhase;
			this.iPointerId = iPointerId;
			this.sizeX      = sizeX;
			this.sizeY      = sizeY;
			this.stageX     = stageX;
			this.stageY     = stageY;
			this.fPressure  = fPressure;
		}
	
	// -------o public
				
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function clone( ) : Event {
			return new GestureLongPressEvent( type , iPhase , iPointerId , sizeX , sizeY , stageX , stageY , fPressure );
						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function toString( ) : String {
			return '[GestureLongPressEvent ::: '+type+']';
		}

	// -------o protected
	
		

	// -------o misc
	
}