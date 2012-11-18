package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.enums.GesturePhases;
import fr.hyperfiction.hypertouch.HyperTouch;
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
class GestureRotate extends AGesture{	

	#if android
	private static inline var ANDROID_CLASS : String = 'fr/hyperfiction/hypertouch/GestureRotation';
	#end

	#if mobile
	private static var eval_callback_rot = Lib.load( "hypertouch" , "set_callback_rot", 1);
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
			eval_callback_rot( _onRot );
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
			var f = JNI.createStaticMethod( ANDROID_CLASS , 'getInstance' , '()Lfr/hyperfiction/hypertouch/GestureRotation;');
			_java_instance = f( );				
		}

		#end	

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onRot( a : Array<Dynamic> ) : Void{

			var ev = new TransformGestureEvent( GESTURE_ROTATE , a[1] , a[2] , 1.0 , 1.0 , a[3] * 180 / Math.PI );
			
			var id_phase = a[ 0 ];
			var phase = START;
			if( id_phase == 1 )
				phase = UPDATE;
			else if( id_phase == 2 )
				phase = END;

			//
				ev.phase = phase;
			
			#if android
				ev.pressure = a[4];
			#end

			stage_emit( ev );
			
		}

	// -------o misc
	
}