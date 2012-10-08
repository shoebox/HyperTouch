package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.events.GestureLongPressEvent;
import fr.hyperfiction.hypertouch.gestures.AGesture;

#if android
import nme.JNI;
#end

#if cpp
import cpp.Lib;
import nme.Lib;
#end

/**
 * ...
 * @author shoe[box]
 */

class GestureLongPress extends AGesture{

	public var enabled( default , _set_enabled ) : Bool;

	#if android
	private var _java_instance : Dynamic;

	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.GestureLongPress';
	#end

	#if mobile
	private static var eval_callback_long_press = Lib.load( "hypertouch" , "set_callback_long_press", 1);
	#end

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( ) {
			super( );
			#if mobile
			eval_callback_long_press( _onLongPress );
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
		private function _set_enabled( b : Bool ) : Bool{

			//TODO : Disable gesture
			if( b )
				_activate( );

			return this.enabled = b;
		}		

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _activate( ) : Void{
			#if android
			_android( );
			#end	
		}

		#if android

		/**
		* Android activation of the gesture
		* 
		* @private
		* @return	void
		*/
		private function _android( ) : Void{

			var f = JNI.createStaticMethod( ANDROID_CLASS , 'getInstance' , '()Lfr/hyperfiction/hypertouch/GestureLongPress;');
			_java_instance = f( );				
		}

		#end

	// -------o misc
	
}