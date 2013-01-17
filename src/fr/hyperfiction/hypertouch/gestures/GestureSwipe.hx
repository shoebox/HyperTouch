package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.HyperTouch;
import fr.hyperfiction.hypertouch.enums.GestureTypes;
import fr.hyperfiction.hypertouch.enums.SwipeDirections;
import fr.hyperfiction.hypertouch.gestures.AGesture;
import fr.hyperfiction.hypertouch.events.TransformGestureEvent;

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
@:build(org.shoebox.utils.NativeMirror.build( )) class GestureSwipe extends AGesture{

	#if android
	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.GestureSwipe';
	#end

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

			#if android
			_android( );
			#end	

			#if cpp
			set_callback_swipe( _onSwipe );
			#end

			#if ios
			HyperTouch.HyperTouch_activate( 6 , 1 );
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
			trace('_android');
			var f = JNI.createStaticMethod( ANDROID_CLASS , 'getInstance' , '()Lfr/hyperfiction/hypertouch/GestureSwipe;');
			_java_instance = f( );
				
		}

		#end	

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSwipe( a : Array<Dynamic> ) : Void{
			trace('onSwipe ::: '+a);

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
		public function set_callback_swipe( f : Array<Dynamic>->Void ) : Void {
						
		}

		#end

}
