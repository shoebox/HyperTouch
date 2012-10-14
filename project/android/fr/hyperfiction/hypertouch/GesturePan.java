package fr.hyperfiction.hypertouch;

import android.util.Log;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.GestureDetector;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import fr.hyperfiction.hypertouch.HyperTouch;
import org.haxe.nme.GameActivity;

/**
 * ...
 * @author shoe[box]
 */

class GesturePan extends GestureDetector.SimpleOnGestureListener implements View.OnTouchListener {

	private static String TAG = "HyperTouch :: GesturePan";
	
	private Boolean _bScrolling;
	private Boolean _recycleVelocityTracker;
	private GestureDetector _gesture_detector;
	private VelocityTracker mVelocityTracker;
	private int _fingers_count;
	private int _taps_count;

	static public native void onPan( 
										int iPhase,
										float fx,
										float fy,
										float vx,
										float vy,
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
		public GesturePan( ){
			trace("constructor");
			final GesturePan instance = this;
			HyperTouch.getInstance( ).add_gesture( this );
			_bScrolling = false;
			_recycleVelocityTracker = false;
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
		public boolean onTouch( View v , MotionEvent ev ) {
			_gesture_detector.onTouchEvent( ev );
		
			int i = 0;			
			int action = ev.getAction();
			 switch(action) {
	            case MotionEvent.ACTION_DOWN:
	            	if(mVelocityTracker == null)
	                    mVelocityTracker = VelocityTracker.obtain();
	                else
	                    mVelocityTracker.clear();
	             	   	mVelocityTracker.addMovement( ev );

	             	 if( !_bScrolling )
	             	 	_startScroll( ev );

	                break;

	            case MotionEvent.ACTION_MOVE:
	            	if(mVelocityTracker == null)
	                    mVelocityTracker = VelocityTracker.obtain();
	               		mVelocityTracker.addMovement( ev );
	                	mVelocityTracker.computeCurrentVelocity( 1000 );	               
	                break;

	            case MotionEvent.ACTION_UP:
	            case MotionEvent.ACTION_CANCEL:
	            	mVelocityTracker.recycle();
	                if( _bScrolling && ev.getPointerCount( ) == 1 ){
	                	_endScroll( ev );
	                }
	                _recycleVelocityTracker = true;
					//Nothing can use mVelocityTracker after it gets recycled
					// mVelocityTracker.recycle();
	                break;
	        }

	        if (_recycleVelocityTracker){
				_recycleVelocityTracker = false;
				mVelocityTracker.recycle();
			}

			return _gesture_detector.onTouchEvent( ev );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		@Override
		public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {  
			_emitScroll( 
							1,
							e2.getX( ),
							e2.getY( ),
							mVelocityTracker.getXVelocity( ),
							mVelocityTracker.getYVelocity( ),
							e2.getPressure( )
						);	
			return false;
		}

	// -------o protected

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private void _startScroll( MotionEvent ev ){
			_bScrolling = true;
			_emitScroll( 
							0,
							ev.getX( ),
							ev.getY( ),
							mVelocityTracker.getXVelocity( ),
							mVelocityTracker.getYVelocity( ),
							ev.getPressure( )
						);
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private void _endScroll( MotionEvent ev ){
			_bScrolling = false;
			_emitScroll( 
							2,
							ev.getX( ),
							ev.getY( ),
							mVelocityTracker.getXVelocity( ),
							mVelocityTracker.getYVelocity( ),
							ev.getPressure( )
						);
			//_emitScroll( 2 , 0 , 0 , mVelocityTracker.getXVelocity( ) , mVelocityTracker.getYVelocity( ) , ev.getX() , ev.getY( ) , ev.getPressure( 0 ) );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private void _emitScroll( 
									final int iPhase,
									final float fx,
									final float fy,
									final float vx,
									final float vy,
									final float pressure
								){
			
			HyperTouch.mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
	                	trace("emit::: "+fx+" === "+fy+" == "+vx+" === "+vy);
						onPan( iPhase , fx , fy , vx , vy , pressure );
					}
				});
			
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
		public static GesturePan getInstance( ){	
			GesturePan 	res = new GesturePan( );
			return res;
		}

}