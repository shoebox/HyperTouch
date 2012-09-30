package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.events.GestureTapEvent;
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

class GestureTap extends AGesture{

	public var enabled( default , _set_enabled ) : Bool;

	private var _fingers_count : Int;
	private var _taps_count : Int;

	#if android
	private var _java_instance : Dynamic;

	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.GestureTap';
	#end

	#if mobile
	private static var eval_callback_tap = Lib.load( "hypertouch" , "set_callback_tap", 1);
	#end

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new( iFingers : Int , iTaps : Int ) {
			super( );
			_fingers_count = iFingers;
			_taps_count = iTaps;
			#if mobile
			eval_callback_tap( _on_tap_callback );
			#end
		}
	
	// -------o public
				
				

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _on_tap_callback( a : Array<Dynamic> ) : Void{
			var fingers = a[ 0 ];
			var taps = a[ 1 ];


			switch( fingers ){

				case 1:
					if( taps == 1 )
						Reflect.callMethod( this , _on_single_tap , a ); 
					else
						Reflect.callMethod( this , _on_double_tap , a ); 

				case 2:
					if( taps == 1 )
						Reflect.callMethod( this , _on_two_fingers_tap , a );

			}
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _on_single_tap(
									iFingers  : Int,
									iTaps     : Int,
									iPhase    : Int , 
									iPointerId: Int , 
									fx        : Float , 
									fy        : Float , 
									fPressure : Float , 
									fSizeX    : Float , 
									fSizeY    : Float   
								) : Void{
			var ev = new GestureTapEvent( GestureTapEvent.TAP , iPhase , iPointerId , fx , fy , fPressure , fSizeX , fSizeY );
			emit( ev , fx , fy );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _on_double_tap( 
											iFingers  : Int,
											iTaps     : Int,
											iPhase    : Int , 
											iPointerId: Int , 
											fx        : Float , fy : Float , 
											fPressure : Float , 
											fSizeX    : Float , fSizeY : Float   
										) : Void{
			var ev = new GestureTapEvent( GestureTapEvent.DOUBLE_TAP , iPhase , iPointerId , fx , fy , fPressure , fSizeX , fSizeY );
			emit( ev , fx , fy );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _on_two_fingers_tap( 
											iFingers  : Int,
											iTaps     : Int,
											iPhase    : Int , 
											iPointerId: Int , 
											fx        : Float , fy : Float , 
											fPressure : Float , 
											fSizeX    : Float , fSizeY : Float   
										) : Void{
			var ev = new GestureTapEvent( GestureTapEvent.TWO_FINGERS , iPhase , iPointerId , fx , fy , fPressure , fSizeX , fSizeY );
			emit( ev , fx , fy );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _set_enabled( b : Bool ) : Bool{

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
		* 
		* 
		* @private
		* @return	void
		*/
		private function _android( ) : Void{

			var f = JNI.createStaticMethod( ANDROID_CLASS , 'getInstance' , '(II)Lfr/hyperfiction/hypertouch/GestureTap;');
			_java_instance = f( _fingers_count , _taps_count );
				
		}

		#end

	// -------o misc
	
}