package fr.hyperfiction.hypertouch;

import android.util.Log;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.GestureDetector;
import android.view.View;
import org.haxe.nme.GameActivity;
import fr.hyperfiction.hypertouch.HyperTouch;

/**
* @author shoe[box]
*/
class GestureRotation extends GestureDetector.SimpleOnGestureListener implements View.OnTouchListener {

	private static String TAG = "HyperTouch :: GestureRotation";

	private static final int INVALID_POINTER_ID = -1;
    private float fX, fY, sX, sY, focalX, focalY;
    private int ptrID1, ptrID2;


	static public native void onRot( 
											int phase , 
											float fx , 
											float fy , 
											float deg , 
											float pressure
										);
	static {
		System.loadLibrary( "hypertouch" ); 
	}

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public GestureRotation( ){
			Log.i( TAG , "constructor" );
			final GestureRotation instance = this;
			HyperTouch.getInstance( ).add_gesture( this );
		}
	
	// -------o public

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@Override
		public boolean onTouch( View v , MotionEvent e ) {
			
			if( e.getPointerCount( ) == 2 ){

				switch( e.getAction( ) ){

					case MotionEvent.ACTION_DOWN:

		            case MotionEvent.ACTION_MOVE:
		            	rotation( e );
		                break;

		            default:
		            	
				}

				//rotation( e );
			}
		    return false;
		}

	// -------o protected

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private void rotation( final MotionEvent ev ) { 

	        final double dx = (ev.getX(0) - ev.getX(1));
	        final double dy = (ev.getY(0) - ev.getY(1));
	        final double radians = Math.atan2(dy, dx);  
	        final float res = (float) radians;
	       	HyperTouch.mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
						onRot( 
			       			1 , 
			       			(float) dx , 
			       			(float) dy , 
			       			(float) radians , 
			       			res
			       		);
					}
				}
			);
	     
	       
	    }

	// -------o misc
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		static public void trace( String s ){
			Log.i( TAG , s );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public static GestureRotation getInstance( ){	
			return new GestureRotation( );
		}

}