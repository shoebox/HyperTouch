package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.enums.GestureTypes;
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
class GesturePinch extends AGesture{

	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.GesturePinch';

	#if mobile
	private static var eval_callback_pinch = Lib.load( "hypertouch" , "set_callback_pinch", 1);
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

			#if mobile
			eval_callback_pinch( _onPinch );
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
			var f = JNI.createStaticMethod( ANDROID_CLASS , 'getInstance' , '()Lfr/hyperfiction/hypertouch/GesturePinch;');
			_java_instance = f( );				
		}

		#end	

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onPinch( a : Array<Dynamic> ) : Void{
			//trace('onPinch ::: '+a);

			var ev = new TransformGestureEvent( GESTURE_PINCH , a[0] , a[1] , a[2] , a[3] );
				ev.phase = ALL;
			
			#if android
				//ev.pressure = a[5];
			#end

			stage_emit( ev );

		}

	// -------o misc
	
}