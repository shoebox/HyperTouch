package fr.hyperfiction.hypertouch.gestures;

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
class GestureSwipe extends AGesture{

	#if android
	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.GestureSwipe';
	#end

	#if mobile
	private static var eval_callback_tap = Lib.load( "hypertouch" , "set_callback_swipe", 1);
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
			eval_callback_tap( _onSwipe );
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
			//SWIPE_DIRECTION_UP , vx , vy , dx , dy

			var ev = new TransformGestureEvent( GESTURE_SWIPE , a[3] , a[4] , 0.0 , 0.0 );
				ev.phase = ALL;
				ev.direction = _get_swipe_direction( a[ 0 ] );
			
			#if android
				ev.pressure = a[5];
			#end

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
	
}
