package fr.hyperfiction.hypertouch.events;

import fr.hyperfiction.hypertouch.events.GesturePhases;
import nme.events.Event;

/**
 * ...
 * @author shoe[box]
 */

class GestureTapEvent extends Event{
	
	public var fingersCount: Int;
	public var iPhase      : Int;
	public var iPointerId  : Int;	
	public var sizeX       : Float;
	public var sizeY       : Float;
	public var stageX      : Float;
	public var stageY      : Float;
	public var fPressure   : Float;

	public static inline var TAP : String = 'GestureTapEvent_TAP';
	public static inline var DOUBLE_TAP : String = 'GestureTapEvent_DOUBLE_TAP';
	public static inline var TWO_FINGERS : String = 'GestureTapEvent_TWO_FINGERS';

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
			return new GestureTapEvent( type , iPhase , iPointerId , sizeX , sizeY , stageX , stageY , fPressure );
						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		override public function toString( ) : String {
			return '[GestureTapEvent ::: '+type+']';
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function updateAfterEvent(){
						
		}

	// -------o protected
	
		

	// -------o misc
	
}