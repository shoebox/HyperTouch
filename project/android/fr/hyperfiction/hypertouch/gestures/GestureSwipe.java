package fr.hyperfiction.hypertouch.gestures;

import android.util.Log;
import android.view.GestureDetector.SimpleOnGestureListener;
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

class GestureSwipe extends GestureDetector.SimpleOnGestureListener implements View.OnTouchListener {

	private static String TAG = "trace";//HyperTouch :: GestureSwipe";

	private GestureDetector _gesture_detector;
	private MotionEvent mLastOnDownEvent = null;
	private int _fingers_count;
	private int _taps_count;

	//Perhaps not the better way to detect a Swipe in Android
		private static final int SWIPE_MIN_DISTANCE			= 150;
		private static final int SWIPE_MAX_OFF_PATH			= 250;
		private static final int SWIPE_THRESHOLD_VELOCITY	= 200;

	//Directions codes for Haxe Callback
		final static int SWIPE_DIRECTION_RIGHT = 1;
		final static int SWIPE_DIRECTION_LEFT  = 2;
		final static int SWIPE_DIRECTION_UP    = 4;
		final static int SWIPE_DIRECTION_DOWN  = 8;

	static public native void onSwipe( 
											int dir , 
											float vx , 
											float vy , 
											float dx , 
											float dy
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
		public GestureSwipe( ){
			Log.i( TAG , "constructor" );
			final GestureSwipe instance = this;
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
		@Override
        public boolean onDown(MotionEvent e) {
        	 //Android 4.0 bug means e1 in onFling may be NULL due to onLongPress eating it.
            mLastOnDownEvent = e;
            return super.onDown(e);
        }

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@Override
		public boolean onFling(MotionEvent e1, MotionEvent e2, float vx , float vy) {  
			
			 if( e1==null )
                e1 = mLastOnDownEvent;

            if( e1 == null || e2 == null )
                return false;

            float dx = e2.getX() - e1.getX();
            float dy = e1.getY() - e2.getY();

            if ( 
            		Math.abs( dy ) < SWIPE_MAX_OFF_PATH &&
                	Math.abs( vx ) >= SWIPE_THRESHOLD_VELOCITY &&
                	Math.abs( dx ) >= SWIPE_MIN_DISTANCE 
                ) {

                if ( dx > 0 ) 
                  	_swipe( SWIPE_DIRECTION_RIGHT , vx , vy , dx , dy );
                else
                  	_swipe( SWIPE_DIRECTION_LEFT , vx , vy , dx , dy );
                
                return true;

            } else if (
            			Math.abs( dx ) < SWIPE_MAX_OFF_PATH &&
                		Math.abs( vy ) >= SWIPE_THRESHOLD_VELOCITY &&
                		Math.abs( dy ) >= SWIPE_MIN_DISTANCE 
                	) {

                if ( dy > 0 ) 
                  	_swipe( SWIPE_DIRECTION_UP , vx , vy , dx , dy );
                else
                  	_swipe( SWIPE_DIRECTION_DOWN , vx , vy , dx , dy );
                
                return true;
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
		private void _swipe( final int dir , final float vx , final float vy , final float dx , final float dy ){
			
			//HyperTouch.mSurface.queueEvent(
			HyperTouch.mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
	                	trace("run");
						onSwipe( dir , vx , vy , dx , dy );
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
		public static GestureSwipe getInstance( ){	
			if( __instance == null )
				__instance = new GestureSwipe( );

			return __instance;
		}

		static private GestureSwipe __instance;
	
}