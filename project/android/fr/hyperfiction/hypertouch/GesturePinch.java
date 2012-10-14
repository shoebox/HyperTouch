package fr.hyperfiction.hypertouch;

import android.util.Log;
import android.view.ScaleGestureDetector;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.GestureDetector;
import android.view.View;
import org.haxe.nme.GameActivity;
import fr.hyperfiction.hypertouch.HyperTouch;

/**
 * Thanks to http://www.blackmoonit.com/2010/07/gesture-swipe-detection/
 * @author shoe[box]
 */

class GesturePinch extends ScaleGestureDetector.SimpleOnScaleGestureListener implements View.OnTouchListener {

	private static String TAG = "HyperTouch :: GesturePinch";

	final private ScaleGestureDetector oPinchGesture;
	private Float _fX1;
	private Float _fX2;
	private Float _fY1;
	private Float _fY2;

	static public native void onPinch( 
											float dx , 
											float dy , 
											float scaleX,
											float scaleY
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
		public GesturePinch( ){
			super( );
			Log.i( TAG , "constructor" );
			oPinchGesture = new ScaleGestureDetector( GameActivity.getInstance( ) , this );
			HyperTouch.getInstance( ).add_gesture( this );
		}
	
	// -------o public

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public boolean onScale( ScaleGestureDetector d ) {
			try {
				HyperTouch.mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
						onPinch( 
								oPinchGesture.getCurrentSpan( ) - oPinchGesture.getPreviousSpan( ),
								oPinchGesture.getCurrentSpan( ) - oPinchGesture.getPreviousSpan( ),
								oPinchGesture.getScaleFactor( ),
								oPinchGesture.getScaleFactor( )
							);
					}
				});
			} catch (Exception e) {
				Log.i( TAG , "onScale error : "+e );
			}
			return false;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@Override
		public boolean onTouch( View v , MotionEvent e ) {
			return oPinchGesture.onTouchEvent( e );
		}
		
	// -------o protected

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
		public static GesturePinch getInstance( ){	
			return new GesturePinch( );
		}

}