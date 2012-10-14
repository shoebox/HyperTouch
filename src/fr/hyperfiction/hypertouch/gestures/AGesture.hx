package fr.hyperfiction.hypertouch.gestures;

import nme.display.InteractiveObject;
import nme.events.Event;
import nme.geom.Point;
import nme.Lib;

/**
 * ...
 * @author shoe[box]
 */

class AGesture{
	
	private var _pt : Point;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			_pt = new Point( );
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

			Lib.current.stage.dispatchEvent( gesture );
		}

	// -------o protected
	
		

	// -------o misc
	
}