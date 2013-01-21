package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.HyperTouch;
import fr.hyperfiction.hypertouch.enums.GestureTypes;
import fr.hyperfiction.hypertouch.enums.SwipeDirections;
import fr.hyperfiction.hypertouch.gestures.AGesture;
import fr.hyperfiction.hypertouch.events.TransformGestureEvent;

/**
 * ...
 * @author shoe[box]
 */
@:build(org.shoebox.utils.NativeMirror.build( )) class GestureSwipe extends AGesture{

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
			set_callback_swipe( _onSwipe );
			#end

			#if android
			_java_instance = getInstance( );
			trace("_java_instance ;;; "+_java_instance);
			#end				

			#if ios
			HyperTouch.HyperTouch_activate( 6 , 1 );
			#end
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSwipe( a : Array<Dynamic> ) : Void{
			
			var ev : TransformGestureEvent = null;

			#if android
				ev = new TransformGestureEvent( GESTURE_SWIPE , 0 , 0 );
				ev.direction = _get_swipe_direction( a[ 1 ] );
				ev.pressure = a[5];
			#end

			#if ios
				ev = new TransformGestureEvent( GESTURE_SWIPE , a[3] , a[4] );
				ev.direction = _get_swipe_direction( a[ 0 ] );
			#end
			
			//
				ev.phase = ALL;
			
			emit( ev , 0.0 , 0.0 );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _get_swipe_direction( value : Int ) : SwipeDirections{

			var res : SwipeDirections = null;
			switch( value ){

				case 1:
					res = RIGHT;

				case 2:
					res = LEFT;

				case 4:
					res = UP;

				case 8:
					res = DOWN;

			}

			return res;

		}

	// -------o misc
		
	// -------o JNI

		#if android

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@JNI
		static public function getInstance( ) : GestureSwipe {
						
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
		public function set_callback_swipe( f : Array<Dynamic>->Void ) : Void {
						
		}

		#end

}
