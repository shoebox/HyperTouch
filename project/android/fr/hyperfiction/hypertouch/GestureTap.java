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

class GestureTap extends GestureDetector.SimpleOnGestureListener implements View.OnTouchListener {

	private static String TAG = "HyperTouch :: GestureTap";

	private GestureDetector _gesture_detector;
	private int _fingers_count;
	private int _taps_count;

	static public native void onTap( 
										int iFingers,
										int iTaps,
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
		public GestureTap( ){
			final GestureTap instance = this;
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
		public void set_fingers_count( int fingers , int taps ){
			trace("set_fingers_count ::: "+fingers+" || "+taps);
			_fingers_count = fingers;
			_taps_count    = taps;
		}

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

			//Two fingers taps detector
				if( _taps_count == 1 && _fingers_count == 2 ){
					switch ( e.getAction( ) & MotionEvent.ACTION_MASK) {
						case MotionEvent.ACTION_POINTER_DOWN:
							if( e.getPointerCount( ) == 2 )
								_emit( 2 , 1 , e );
							break;
					}
				}

			return false;
		}

		/**
		* 
		* 	
		* @public
		* @return	void
		*/
		public boolean onDoubleTap( MotionEvent e ){

			if( _taps_count == 2 && _fingers_count == 1 )
				_emit( 1 , 2 , e );

			return false;

		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public boolean onSingleTapUp( MotionEvent e ) {

			if( _taps_count == 1 && _fingers_count == 1 ){
				_emit( 1 , 1 , e );
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
		private void _emit( final int iFingers , final int iTaps , final MotionEvent e ){
			HyperTouch.mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
						onTap(
								iFingers,
								iTaps,
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
		public static GestureTap getInstance( int fingers , int taps ){	
			GestureTap 	res = new GestureTap( );
						res.set_fingers_count( fingers , taps );
			return res;
		}

}