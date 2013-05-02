package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.enums.GesturePhases;

import nme.Lib;
import nme.display.InteractiveObject;
import nme.events.Event;
import nme.geom.Point;

#if noevents
import fr.hyperfiction.hypertouch.HyperTouch;
import fr.hyperfiction.hypertouch.gestures.GestureSwipe;
#end

/**
 * ...
 * @author shoe[box]
 */

class AGesture{

	public var prio	: Float;
	public var phase	: GesturePhases;
	public var enabled	( default , _set_enabled ) : Bool;

	private var _pt : Point;

	#if android
	private var _java_instance : Dynamic;
	#end

	// -------o constructor

		/**
		* constructor
		*
		* @param
		* @return	void
		*/
		public function new() {
			_pt = new Point( );
			prio = 0.0;
		}

	// -------o public

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function emit( gesture : Event , fx : Float , fy : Float ) : Void {
			stage_emit( gesture );
		}

		/**
		*
		*
		* @public
		* @return	void
		*/
		public function stage_emit( event : Event ) : Void {

			#if android
			//nme.Lib.postUICallback( function( ){
			//trace("postUICallback");
			#end

			//emit( event );

			#if android
			//});
			#end

			nme.Lib.current.stage.dispatchEvent( event );
		}

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
			else
				_deactivate( );

			return this.enabled = b;
		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _activate( ) : Void{

		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		private function _deactivate( ) : Void{

		}

		/**
		*
		*
		* @private
		* @return	void
		*/
		inline private function _translate_phase( id : Int ) : GesturePhases{
			var res : GesturePhases = ALL;

			switch( id ){

				case 0:
					res = START;

				case 1:
					res = UPDATE;

				case 2:
					res = END;

			}
			return res;
		}




	// -------o misc

}