package fr.hyperfiction.hypertouch.gestures;

import fr.hyperfiction.hypertouch.enums.GesturePhases;

import nme.Lib;
import nme.display.InteractiveObject;
import nme.events.Event;
import nme.geom.Point;

/**
 * ...
 * @author shoe[box]
 */

class AGesture{
	
	public var phase : GesturePhases;
	public var enabled( default , _set_enabled ) : Bool;
	public var prio : Float;

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
			
			_pt.x = fx;
			_pt.y = fy;
			var under = Lib.current.stage.getObjectsUnderPoint( _pt );
			for( child in under ){

				if( child.hasEventListener( gesture.type ) && child.hitTestPoint( fx , fy ) ){
					child.dispatchEvent( gesture );
					return;
				}
			}

			stage_emit( gesture );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function stage_emit( gesture : Event ) : Void {
			Lib.current.stage.dispatchEvent( gesture );						
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