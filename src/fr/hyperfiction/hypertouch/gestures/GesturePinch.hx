package fr.hyperfiction.hypertouch.gestures;

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
class GesturePinch extends AGesture{

	public var enabled( default , _set_enabled ) : Bool;

	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.GesturePinch';

	private var _java_instance : Dynamic;

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
			trace('onPinch ::: '+a);
		}

	// -------o misc
	
}