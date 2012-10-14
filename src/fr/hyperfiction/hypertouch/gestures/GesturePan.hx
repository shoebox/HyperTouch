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
class GesturePan extends AGesture{

	public var enabled( default , _set_enabled ) : Bool;

	private static inline var ANDROID_CLASS : String = 'fr.hyperfiction.hypertouch.GesturePan';

	private var _java_instance : Dynamic;

	#if mobile
	private static var eval_callback_pan = Lib.load( "hypertouch" , "set_callback_pan", 1);
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

			eval_callback_pan( _onPan );
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
			var f = JNI.createStaticMethod( ANDROID_CLASS , 'getInstance' , '()Lfr/hyperfiction/hypertouch/GesturePan;');
			_java_instance = f( );				
		}

		#end	

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onPan( a : Array<Dynamic> ) : Void{
			trace('_onPan ::: '+a.join(' || '));
		}

	// -------o misc
	
}