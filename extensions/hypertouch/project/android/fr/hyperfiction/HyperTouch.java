package fr.hyperfiction;

import android.opengl.GLSurfaceView;
import android.util.Log;
import android.view.GestureDetector.OnDoubleTapListener;
import android.view.GestureDetector.OnGestureListener;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector.SimpleOnScaleGestureListener;
import android.view.ScaleGestureDetector;
import android.view.VelocityTracker;
import android.view.View;
import org.haxe.nme.GameActivity;
import org.haxe.nme.HaxeObject;

public class HyperTouch extends GestureDetector.SimpleOnGestureListener implements View.OnTouchListener{

	private View mViewNME;
	private GLSurfaceView mSurface;
	private VelocityTracker mVelocityTracker;
	private Boolean _bScrolling;

	public static GestureDetector mGestureDetector;
	public static ScaleGestureDetector mScaleDetector;
	public static String TAG = "HyperTouch";

	//Swipe 

		//Directions codes for Haxe Callback
			final static int SWIPE_DIRECTION_RIGHT = 1;
			final static int SWIPE_DIRECTION_LEFT  = 2;
			final static int SWIPE_DIRECTION_UP    = 4;
			final static int SWIPE_DIRECTION_DOWN  = 8;

		//Perhaps not the better way to detect a Swipe in Android
			private static final int SWIPE_MIN_DISTANCE = 120;
		    private static final int SWIPE_MAX_OFF_PATH = 250;
		    private static final int SWIPE_THRESHOLD_VELOCITY = 200;

	//Gestures Codes
	    private boolean [ ] aGesturesStatus = new boolean [ 10 ];
		final static int GESTURE_TAP		= 0;
		final static int GESTURE_TAP2		= 1;
		final static int GESTURE_TWIX		= 2;
		final static int GESTURE_PAN		= 3;
		final static int GESTURE_PINCH		= 4;
		final static int GESTURE_ROT		= 5;
		final static int GESTURE_SWIPE		= 6;
		final static int GESTURE_LONG_PRESS	= 7;

	//JNI
		static public native void onTap( float fx , float fy );
		static public native void onDoubleTap( float fx , float fy );
		static public native void onPan( int phase , float fx , float fy , float vx , float vy , float cx , float cy , float pressure );
		static public native void onPinch( float scale );
		static public native void onSwipe( int dir );
		
		static {
			System.loadLibrary( "hypertouch" ); 
		}

	//
		public SimpleOnScaleGestureListener mListener = new ScaleGestureDetector.SimpleOnScaleGestureListener( ) {
			
			@Override
			public boolean onScale( ScaleGestureDetector detector) {
				
				final float scaleFactor = detector.getScaleFactor( );
				HyperTouch.getInstance( ).onScaleListener( scaleFactor );
				
				return false;
			};
		};

	// -------o constructor
		
		/**
		* Constructor
		*
		* @return	void
		*/
		public void HyperTouch( ){
			Log.i( TAG , "constructor" );	
			java.util.Arrays.fill( aGesturesStatus , false );
		}
	
	// -------o public
				
		/**
		* HyperTouch Initialization
		* Adding Listeners on the GLSurfaceView 
		*
		* @public
		* @return	void
		*/
		public void init(  ) {
			Log.i( TAG , "init ::: " );
			
			_bScrolling = false;

			mViewNME  = GameActivity.getInstance( ).getCurrentFocus( );
			mViewNME.setOnTouchListener( this );

			mSurface = ( GLSurfaceView ) mViewNME;
			Log.i( TAG , "mSurface ::: "+mSurface );

			GameActivity.getInstance( ).mHandler.post(
					new Runnable(){
						@Override public void run(){
							HyperTouch.mGestureDetector = new GestureDetector( GameActivity.getInstance( ) , HyperTouch.getInstance( ) );		
							HyperTouch.mGestureDetector.setOnDoubleTapListener( HyperTouch.getInstance( ) );
						}
					});

			GameActivity.getInstance( ).mHandler.post(
				new Runnable(){
						@Override public void run(){
							HyperTouch.mScaleDetector = new ScaleGestureDetector( GameActivity.getInstance( ) , HyperTouch.getInstance( ).mListener );		
						}
					});

		}

		/**
		* Toggle Disable gesture By Code
		* 
		* @public
		* @param 	Gesture Code ( int )
		* @param 	Gesture ON / OFF ( boolean )
		* @return	void
		*/
		public void toggleGesture( int code , final boolean b ){
			Log.i( TAG , "toggleGesture ::: "+code+" = "+b );
			aGesturesStatus[ code ] = b;
		}

		/**
		* <code>SimpleOnGestureListener</code> onTouch Generic Method
		* 
		* @public
		* @return	void
		*/
		public boolean onTouch( View v , final MotionEvent ev) {
			int i = 0;			
			int action = ev.getAction();
	        switch(action) {
	            case MotionEvent.ACTION_DOWN:
	            	if(mVelocityTracker == null)
	                    mVelocityTracker = VelocityTracker.obtain();
	                else
	                    mVelocityTracker.clear();
	                mVelocityTracker.addMovement( ev );
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
	                break;
	        }

			if( mGestureDetector != null )
				if( !mGestureDetector.onTouchEvent( ev ) )
					if( mScaleDetector != null && aGesturesStatus[ GESTURE_PINCH ] )
						mScaleDetector.onTouchEvent( ev );
			
			if( mViewNME != null )
				mViewNME.onTouchEvent( ev );

			return true;
		}

		/**
		* Listener of the Scale Gesture
		* 
		* @public
		* @param	scl : Pinch value ( Float )
		* @return	void
		*/
		public void onScaleListener( final Float scl ) {
			HyperTouch.getInstance( ).mSurface.queueEvent(
					new Runnable(){
		                public void run() { 
		                	HyperTouch.onPinch( scl );
		                }
		            }
				);
						
		}

		/**
		* Listener of the DoubleTap Gesture
		* 
		* @public
		* @param	e : Gesture ( MotionEvent )
		* @return	false
		*/
		public boolean onDoubleTapEvent( final MotionEvent e){

			if( !aGesturesStatus[ GESTURE_TAP2 ] )
				return false;

			if( e.getAction( ) != MotionEvent.ACTION_UP )
				return false;

			Log.i( TAG , "onDoubleTapEvent : "+e.toString()+" - "+e.getPointerCount( ) );

			HyperTouch.getInstance( ).mSurface.queueEvent(
					new Runnable(){
		                public void run() { 
		                	HyperTouch.onDoubleTap( e.getX( ) , e.getY( ) );
		                }
		            }
				);
			
  			return false;
 		} 

 		/**
		* Listener of the Tap Gesture
		* 
		* @public
		* @param	e : Gesture ( MotionEvent )
		* @return	false
		*/
		public boolean onSingleTapUp ( MotionEvent ev ) {
			//Log.i( TAG , "onSingleTapUp : "+ev.toString() + " - "+ ev.getPointerCount( ) );
			return false;
		}

		/**
		* Listener of the Tap Gesture
		* 
		* @public
		* @param	e : Gesture ( MotionEvent )
		* @return	false
		*/
		public boolean onSingleTapConfirmed ( MotionEvent ev ) {
			
			if( !aGesturesStatus[ GESTURE_TAP] )
				return false;

			Log.i( TAG , "onSingleTapConfirmed : "+ev.toString() + " - "+ ev.getPointerCount( ) );

			final float x = ev.getX( );
           	final float y = ev.getY( );
			mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
						HyperTouch.onTap( x , y );
	                }
	            }
			);

			return false;
		}

		/* 
		* 
		* @public
		* @return	void
		*/
		public void onShowPress(MotionEvent ev) {  
			//Log.i( TAG , "onShowPress : "+ev.toString());  
		}  
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public void onLongPress(MotionEvent ev) {  
			//Log.i( TAG , "onLongPress : "+ev.toString());  
		}  
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public boolean onScroll( final MotionEvent e1 , final MotionEvent e2 , final float distanceX, final float distanceY) {  
			
			if( !aGesturesStatus[ GESTURE_PAN ] || e2.getPointerCount( ) != 1 )
				return false;

			int iPhase = 1;
			if( !_bScrolling ){
				_bScrolling = true;
				iPhase = 0;
			}
			
			_emitScroll( iPhase , distanceX , distanceY , mVelocityTracker.getXVelocity( ) , mVelocityTracker.getYVelocity( ) , e2.getX() , e2.getY( ) , e2.getPressure( 0 ) );
			
			return false;
			
		}  
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public boolean onDown(MotionEvent ev) {  
			return false;  
		}  
		
		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {  
			Log.i( TAG , "onFling ::: "+e2.getAction( ) );	
			if( !aGesturesStatus[ GESTURE_SWIPE ] )
				return false;

			if( e2.getAction( ) != MotionEvent.ACTION_UP )
				return false;

			//Strange sometimes the MotionEvent are null
				if( e1 == null || e2 == null )
					return false;

			//
				Float fx = e1.getX() - e2.getX();
				Float fy = e1.getY() - e2.getY() ;
			
			//
				if( Math.abs( fy ) < SWIPE_MAX_OFF_PATH && Math.abs( fx ) > SWIPE_MIN_DISTANCE && Math.abs( velocityX ) > SWIPE_THRESHOLD_VELOCITY ){
						
					if( velocityX < 0 )
						_swipe( SWIPE_DIRECTION_LEFT );
					else
						_swipe( SWIPE_DIRECTION_RIGHT );

				}else if( Math.abs( fx ) < SWIPE_MAX_OFF_PATH && Math.abs( fy ) > SWIPE_MIN_DISTANCE && Math.abs( velocityY ) > SWIPE_THRESHOLD_VELOCITY ){

					if( velocityY > 0 )
						_swipe( SWIPE_DIRECTION_DOWN );
					else
						_swipe( SWIPE_DIRECTION_UP );
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
		private void _swipe( final int dir ){
			Log.i( TAG , "onSwipe ::: "+dir);
			mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
						HyperTouch.onSwipe( dir );
	                }
	            }
			);
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private int _getPhaseCode( int action ){
			
			int phase = 0;
	        switch(action) {
	            case MotionEvent.ACTION_DOWN:
	            	phase = 0;
	                break;

	            case MotionEvent.ACTION_MOVE:
	            	phase = 1;
	                break;

	            case MotionEvent.ACTION_UP:
	            case MotionEvent.ACTION_CANCEL:
	               	phase = 2;
	                break;
	        }
	        return phase;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private void _endScroll( MotionEvent ev ){
			Log.i( TAG , "_endScroll ::: ");
			_bScrolling = false;
			_emitScroll( 2 , 0 , 0 , mVelocityTracker.getXVelocity( ) , mVelocityTracker.getYVelocity( ) , ev.getX() , ev.getY( ) , ev.getPressure( 0 ) );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private void _emitScroll( 
									final int phase , 
									final float dx , final float dy , 
									final float vx , final float vy , 
									final float cx , final float cy , 
									final float pressure 
								){
			
			mSurface.queueEvent(
				new Runnable(){
	                public void run() { 
						HyperTouch.onPan( 
											phase,
											dx , dy,
											vx , vy,
											cx , cy,
											pressure
										);
	                }
	            }
			);
			
		}

	// -------o misc

		public static void HyperTouch_init( ){
			Log.i( TAG , "HyperTouch_init ::: ");
			__instance = new HyperTouch( );
			__instance.init( );	
		}

		public static void HyperTouch_toggle( int code , boolean b ){
			getInstance( ).toggleGesture( code , b );
		}

		public static HyperTouch getInstance( ){

			if( __instance == null )
				__instance = new HyperTouch( );

			return __instance;
		}
		static private HyperTouch __instance = null;

}
