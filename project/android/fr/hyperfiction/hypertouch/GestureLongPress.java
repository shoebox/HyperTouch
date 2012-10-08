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
 * ...
 * @author shoe[box]
 */

class GestureLongPress extends GestureDetector.SimpleOnGestureListener implements View.OnTouchListener {

	private static String TAG = "HyperTouch :: LongPress";

	private GestureDetector _gesture_detector;
	private int _fingers_count;
	private int _taps_count;

	static public native void onLongPress( 
											int iPhase , 
											int iPointerId , 
											float fx , 
											float fy , 
											float fPressure , 
											float fSizeX , 
											float fSizeY 
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
		public GestureLongPress( ){
			final GestureLongPress instance = this;
			HyperTouch.getInstance( ).add_gesture( this );
			GameActivity.getInstance( ).mHandler.post(
						new Runnable(){
							@Override public void run(){
								_gesture_detector = new GestureDetector( GameActivity.getInstance( ) , instance );
							}
						});

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

			//
				if( _gesture_detector != null )
					_gesture_detector.onTouchEvent( e );

			return false;
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public void onLongPress( MotionEvent e ){
			_emit( e );
		}		
		
	// -------o protected

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private void _emit( final MotionEvent e ){
			
			HyperTouch.mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
						onLongPress(
								e.getAction( ),
								e.getPointerId( 0 ),
								e.getX( ),
								e.getY( ),
								e.getPressure( 0 ),
								e.getSize( 0 ),
								e.getSize( 0 )
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
		public static GestureLongPress getInstance( ){	
			return new GestureLongPress( );
		}

}