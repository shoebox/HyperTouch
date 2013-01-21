package fr.hyperfiction.hypertouch;

import fr.hyperfiction.hypertouch.enums.GestureTypes;
import fr.hyperfiction.hypertouch.enums.SwipeDirections;
import fr.hyperfiction.hypertouch.gestures.AGesture;
import fr.hyperfiction.hypertouch.gestures.GestureLongPress;
import fr.hyperfiction.hypertouch.gestures.GesturePan;
import fr.hyperfiction.hypertouch.gestures.GesturePinch;
import fr.hyperfiction.hypertouch.gestures.GestureRotation;
import fr.hyperfiction.hypertouch.gestures.GestureSwipe;
import fr.hyperfiction.hypertouch.gestures.GestureTap;

#if android
import haxe.Timer;
import nme.events.Event;
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

@:build(org.shoebox.utils.NativeMirror.build( )) class HyperTouch{

	private var _hGestures : IntHash<AGesture>;

	#if android
	private var _java_instance	: Dynamic;
	private var _timer			: Timer;
	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.HyperTouch';
	#end

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		private function new() {
			trace('constructor');
			_init( );
		}
	
	// -------o public
			
		/**
		* Adding a new listener for the <code>GestureType</code> gesture
		* 
		* @public
		* @param 	gesture : Gesture to listen for ( GestureType )
		* @return	void
		*/
		public function add( type : GestureTypes ) : AGesture {
			
			var gesture : AGesture = null;	

			//
				var value : Int;
				switch( type ){

					case TAP( fingers_count , taps_count ):
						value = _get_tap_code( fingers_count , taps_count );

					default:
						value = Type.enumIndex( type ) * 100;

				}

			//
				if( !_hGestures.exists( value ) ){
					
					switch( type ){

						case TAP( fingers_count , taps_count ):
							gesture = _add_tap_with( fingers_count , taps_count );

						case LONGPRESS:
							gesture = new GestureLongPress( );

						case GESTURE_PAN:
							gesture = new GesturePan( );

						case GESTURE_ROTATE:
							gesture = new GestureRotation( );

						case GESTURE_SWIPE:
							gesture = new GestureSwipe( );

						case GESTURE_PINCH:
							gesture = new GesturePinch( );

					}

					gesture.enabled = true;
					_hGestures.set( value , gesture );
				}

			return gesture;
		}

	// -------o protected
		
		/**
		* Initialization
		* 
		* @private
		* @return	void
		*/
		private function _init( ) : Void{
			_hGestures = new IntHash<AGesture>( );

			#if android
			nme.Lib.current.stage.addEventListener( Event.DEACTIVATE , _onDeactivate , false );
			#end

			#if ios
			HyperTouch_init( );
			#end
		}

		#if android

		/**
		* When the stage is deactivate == Activity deactived
		* 
		* @private
		* @return	void
		*/
		private function _onDeactivate( _ ) : Void{
			trace('_onDeactivate');
			
			//
				if( _timer != null )
					_timer.stop( );

			//Instance of the HyperTouch java class
				if( _java_instance == null )
					_java_instance = getJNIInstance( );				

			//Calling the disable function
				disable( _java_instance );
				nme.Lib.current.stage.addEventListener( Event.ACTIVATE , _onActivate , false );
		}

		/**
		* Reactivation of the stage == Android listener reactivation
		* A timer is used to give some time to the activity to reenable everything
		* 
		* @private
		* @return	void
		*/
		private function _onActivate( _ ) : Void{
			trace('_onActivate');
			
			//Waiting for the GLSurfaceView reinitialization
			//TODO : Temporary work around
				_timer = Timer.delay( function( ){
												enable( _java_instance );
											} , 10 );

		}

		#end

		/**
		* Add a tap listener with the specified fingers count & taps count
		* 
		* @private
		* @param 	fingers_count: Finger count ( Int )
		* @param 	taps_count   : Taps count ( Int )
		* @return	void
		*/
		private function _add_tap_with( fingers_count : Int , taps_count : Int = 1 ) : AGesture{
			
			var value = _get_tap_code( fingers_count , taps_count );
			var res : GestureTap = null;
			if( !_hGestures.exists( value ) ){
				res = new GestureTap( fingers_count , taps_count );
				res.enabled = true;
				_hGestures.set( value , res );
			}			
			return res;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _get_tap_code( fingers_count : Int , taps_count : Int ) : Int{
			return fingers_count * 5 + taps_count;
		}


	// -------o iOS

		#if ios

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@CPP("hypertouch")
		public function HyperTouch_init( ) : Void {
						
		}
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@CPP("hypertouch")
		static public function HyperTouch_activate( iCode : Int , iFingers : Int = 0 ) : Void {
						
		}

		#end

	// -------o android

		#if android

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@JNI
		public function enable( java_instance : Dynamic ) : Void {

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@JNI
		public function disable( java_instance : Dynamic ) : Void {
						
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@JNI("fr.hyperfiction.hypertouch.HyperTouch","getInstance")
		static public function getJNIInstance( ) : HyperTouch {
						
		}

		#end

	// -------o misc
		
		/**
		* Static method to listen a new <code>GestureType</code>
		* 
		* @public
		* @param 	gesture : Gesture to listen for ( GestureType )
		* @return	void
		*/
		static public function add_listener_for( gesture : GestureTypes ) : Void {
			getInstance( ).add( gesture );
		}

		/**
		* Singleton of the class
		* 
		* @public
		* @return	singleton instance of the class
		*/
		static public function getInstance( ) : HyperTouch {
			
			if( __instance == null )
				__instance = new HyperTouch( );

			return __instance;

		}	

		private static var __instance : HyperTouch = null;
}



