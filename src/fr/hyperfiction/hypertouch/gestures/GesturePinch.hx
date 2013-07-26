package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.enums.GestureTypes;
import fr.hyperfiction.hypertouch.gestures.AGesture;
import fr.hyperfiction.hypertouch.events.TransformGestureEvent;

/**
 * ...
 * @author shoe[box]
 */
@:build( ShortCuts.mirrors( ) )
class GesturePinch extends AGesture{

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new() {
			super( );

		}

	// -------o public



	// -------o protected

		/**
		*
		*
		* @private
		* @return	void
		*/
		override private function _activate( ) : Void{

			#if cpp
			set_callback_pinch( _onPinch );
			#end

			#if android
			_java_instance = getInstance( );
			#end

			#if ios
			HyperTouch.HyperTouch_activate( 4 , 1 );
			#end

		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _onPinch( a : Array<Dynamic> ) : Void{

			var ev : TransformGestureEvent = new TransformGestureEvent( GESTURE_PINCH , a[ 1 ] , a[ 2 ] , a[ 3 ] , a[ 3 ] );
				ev.phase = _translate_phase( a[ 0 ] );
			stage_emit( ev );

		}

	// -------o misc

	// -------o Android

		#if android

		/**
		*
		*
		* @public
		* @return	void
		*/
		@JNI
		static public function getInstance( ) : GesturePinch {

		}

		#end

	// -------o CPP

		#if cpp

		/**
		*
		*
		* @public
		* @return	void
		*/
		@CPP("hypertouch")
		public function set_callback_pinch( f : Array<Dynamic>->Void ) : Void {

		}

		#end
}