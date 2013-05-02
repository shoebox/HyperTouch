package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.HyperTouch;
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

@:build(org.shoebox.utils.NativeMirror.build( )) class GestureTap extends AGesture{

	private var _fingers_count : Int;
	private var _taps_count : Int;

	#if android
	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.GestureTap';
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
			trace('constructor');			
		}
	
	// -------o public
		
		#if cpp

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@CPP("hypertouch")
		public function set_callback_tap( f : Array<Dynamic>->Void ) : Void {
						
		}		

		#end

	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _on_tap_callback( a : Array<Dynamic> ) : Void{
			trace("_on_tap_callback ::: "+a);
			

			var sType : String = switch( a[ 0 ] ){

									case 1:
										switch( a[ 1 ] ){

											case 1:
												GestureTapEvent.TAP;
											
											case 2:
												GestureTapEvent.DOUBLE_TAP;
										}

									case 2:
										GestureTapEvent.TWO_FINGERS;
								}
			var ev : GestureTapEvent = null;

			var fx : Float;
			var fy : Float;

			#if android
			ev = new GestureTapEvent( sType , a[ 2 ] , a[ 3 ] , a[ 4 ] , a[ 5 ] , a[ 6 ] , a[ 7 ] , a[ 8 ] );
			#end

			#if ios
			ev = new GestureTapEvent( sType , a[ 2 ] , 0 , a[ 3 ] , a[ 4 ] );
			#end
			stage_emit( ev );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		override private function _activate( ) : Void{
			trace("_activate");

			#if cpp
			set_callback_tap( _on_tap_callback );
			#end
			
			#if android
			_java_instance = getInstance( _fingers_count , _taps_count );
			#end	

			#if ios
			HyperTouch.HyperTouch_activate( 0 , 1 );
			#end
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
		public function HyperTouch_activate( iCode : Int , iFingers : Int = 0  ) : Void {						
		}

		#end

	// -------o JNI

		#if android

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@JNI
		static public function getInstance( iFingers : Int , iTaps : Int ) : GestureTap {						
		}

		#end

	// -------o misc
	
}