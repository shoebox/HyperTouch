package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.HyperTouch;
import fr.hyperfiction.hypertouch.enums.GesturePhases;
import fr.hyperfiction.hypertouch.events.GestureLongPressEvent;
import fr.hyperfiction.hypertouch.gestures.AGesture;

/**
 * ...
 * @author shoe[box]
 */

@:build(org.shoebox.utils.NativeMirror.build( )) class GestureLongPress extends AGesture{

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			super( );
			#if cpp
			set_callback_long_press( _onLongPress );
			#end
		}
	
	// -------o public
				
				

	// -------o protected
		
		/**
		* Long press callback method ( cf ExternalInteface.cpp )
		* 
		* @private
		* @return	void
		*/
		private function _onLongPress( a : Array<Dynamic> ) : Void{
			trace("_onLongPress :::: "+a);
			Reflect.callMethod( this , _emit , a ); 
		}

		/**
		* Emit the longpress
		* 
		* @private
		* @return	void
		*/
		private function _emit(
								iPhase    : Int , 
								iPointerId: Int , 
								fx        : Float , 
								fy        : Float , 
								fPressure : Float , 
								fSizeX    : Float , 
								fSizeY    : Float   
								) : Void{
			var ev = new GestureLongPressEvent( GestureLongPressEvent.LONG_PRESS , iPhase , iPointerId , fx , fy , fPressure , fSizeX , fSizeY );
			emit( ev , fx , fy );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		override private function _activate( ) : Void{

			#if android
			_java_instance = getInstance( );
			#end	

			#if ios
			HyperTouch.HyperTouch_activate( 7 , 1 );
			#end

		}


	// -------o Android
		
		#if android

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@JNI
		static public function getInstance( ) : GestureLongPress {
						
		}

		#end

	// -------o iOS



	// -------o CPP

		#if cpp

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@CPP("hypertouch")
		public function set_callback_long_press( f : Array<Dynamic>->Void ) : Void {
						
		}

		#end

	// -------o misc
	
}