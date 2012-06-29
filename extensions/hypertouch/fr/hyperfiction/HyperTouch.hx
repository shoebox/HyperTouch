package fr.hyperfiction;

#if code_completion

@final extern class HyperTouch{
	static var SWIPE_DIRECTION_RIGHT : Int;
	static var SWIPE_DIRECTION_LEFT  : Int;
	static var SWIPE_DIRECTION_UP    : Int;
	static var SWIPE_DIRECTION_DOWN  : Int;
	function getInstance( ) : HyperTouch;
	function addEventListener(type : String, listener : Dynamic -> Void, useCapture : Bool = false, priority : Int = 0, useWeakReference : Bool = false) : Void;
	function removeEventListener(type : String, listener : Dynamic -> Void, useCapture : Bool = false ) : Void;
}

#else

#if android
import nme.JNI;
#end

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

import fr.hyperfiction.events.GesturePanEvent;
import fr.hyperfiction.events.GesturePinchEvent;
import fr.hyperfiction.events.GestureRotationEvent;
import fr.hyperfiction.events.GestureSwipeEvent;
import fr.hyperfiction.events.GestureTapEvent;
import nme.Lib;
import nme.display.Stage;
import nme.errors.Error;
import nme.events.Event;
import nme.events.EventDispatcher;


/**
 * ...
 * @author shoe[box]
 */

class HyperTouch extends EventDispatcher{
	
	public static inline var SWIPE_DIRECTION_RIGHT : Int = 1;
	public static inline var SWIPE_DIRECTION_LEFT  : Int = 2;
	public static inline var SWIPE_DIRECTION_UP    : Int = 4;
	public static inline var SWIPE_DIRECTION_DOWN  : Int = 8;

	private static var hyp_touch_callback_pan      = Lib.load( "hypertouch" , "hyp_touch_callback_pan", 1);
	private static var hyp_touch_callback_pinch    = Lib.load( "hypertouch" , "hyp_touch_callback_pinch", 1);
	private static var hyp_touch_callback_rotation = Lib.load( "hypertouch" , "hyp_touch_callback_rotation", 1);
	private static var hyp_touch_callback_swipe    = Lib.load( "hypertouch" , "hyp_touch_callback_swipe", 1);
	private static var hyp_touch_callback_tap      = Lib.load( "hypertouch" , "hyp_touch_callback_tap", 1);
	private static var hyp_touch_callback_tap2     = Lib.load( "hypertouch" , "hyp_touch_callback_tap2", 1);
	private static var hyp_touch_callback_twix     = Lib.load( "hypertouch" , "hyp_touch_callback_twix", 1);
	
	#if iphone
	private static var hyp_touch_activate          = Lib.load( "HyperTouch" , "hyp_touch_activate" , 1 );
	private static var hyp_touch_deactivate        = Lib.load( "HyperTouch" , "hyp_touch_deactivate" , 1 );
	private static var hyp_touch_get_orientation   = Lib.load( "HyperTouch" , "hyp_touch_get_orientation" , 0 );
	private static var hypTouch_init             = nme.Loader.load( "hyp_touch_init" , 0 );
	private var _fTmp : FPoint;
	#end

	#if android	
	public static inline var ANDROID_CLASS : String = 'fr.hyperfiction.HyperTouch';

	static private var hyp_touch_init	: Dynamic;
	static private var hyp_touch_toggle	: Dynamic;
	#end

	public static inline var GestureCode_TAP : Int = 0;


	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		private function new( ) {
			trace('constructor');
			super( );

			#if iphone
				hypTouch_init( );
				_fTmp = { x : 0.0 , y : 0.0 };
				
			#end

			#if mobile
				hyp_touch_callback_pan( _onPanCallback );
				hyp_touch_callback_pinch( _onPinchCallback );
				hyp_touch_callback_rotation( _onRotCallback );
				hyp_touch_callback_swipe( _onSwipeCallback );
				hyp_touch_callback_tap2( _onTap2Callback );
				hyp_touch_callback_twix( _onTwixCallback );
				hyp_touch_callback_tap( _onTapCallback );
			#end

			#if android

			//Initialize
					
				if( hyp_touch_init == null )
					hyp_touch_init = JNI.createStaticMethod( ANDROID_CLASS , 'HyperTouch_init' , "()V" );
					hyp_touch_init( );

				if( hyp_touch_toggle == null )
					hyp_touch_toggle = JNI.createStaticMethod( ANDROID_CLASS , 'HyperTouch_toggle' , "(IZ)V" );
					
			#end

			//
				
			

			
		}
	
	// -------o public

		/**
		* Overriding the <code>EventDispatcher.addEventListener</code>
		* To activate only the gesture who are listened
		* 
		* @public
		* @return	void
		*/
		override public function addEventListener(
													type : String, 
													listener : Dynamic -> Void, 
													useCapture : Bool = false, 
													priority : Int = 0, 
													useWeakReference : Bool = false
													) : Void{

			
			super.addEventListener( type , listener , useCapture , priority , useWeakReference );
			
			#if iphone
			hyp_touch_activate( getCode( type ) );
			#end

			#if android
			hyp_touch_toggle( getCode( type ) , true );
			#end
		}

		/**
		* Overriding the <code>EventDispatcher.addEventListener</code>
		* To deactivate only the gesture who are no more listened
		* 
		* @public
		* @return	void
		*/
		override public function removeEventListener(
														type : String, 
														listener : Dynamic -> Void, 
														useCapture : Bool = false
													) : Void{
			super.removeEventListener( type , listener , useCapture );
			_disable( type );
		}

		/**
		* 
		* 
		* @public
		* @return	void
		*/
		public function getCode( type : String ) : Int {

			var e = Type.createEnum( Gestures , type );
			return Type.enumIndex( e );			
		}

	// -------o protected
		
		#if mobile

		/**
		* Callback of the Pan
		* 
		* @private
		* @param 	args : Callback arguments coordinates ( Array<Float> )
		* @return	void
		*/
		#if iphone
		private function _onPanCallback( args : Array<Float> ) : Void{
			_onDispatchPan( args[ 2 ] , args[ 3 ] , args[ 0 ] , args[ 1 ] );
		}
		#end

		#if android
		private function _onPanCallback( fx : Float , fy : Float ) : Void{
			_onDispatchPan( -fx , -fy , 0 , 0 );
		}
		#end

		/**
		* Callback of the Pinch Listener
		* 
		* @private
		* @param 	fScale    : Pinch Scale Value ( Float )
		* @param 	fVelocity : Velocity of the pinch ( Float )
		* @return	void
		*/
		#if android
		private function _onPinchCallback( fScale : Float ) : Void{
			trace('_onPinchCallback ::: '+fScale);

			try{
				_onDispatchPinch( fScale , 0.0 );	
			}catch( e : nme.errors.Error ){
				trace('error :: '+e);
			}
			
		}
		#else
		private function _onPinchCallback( fScale : Float , fVelocity : Float ) : Void{
			_onDispatchPinch( fScale , fVelocity );
		}
		#end

		/**
		* Callback of the rotation listener
		* 
		* @private
		* @param	fRotation : Rotation value ( Float )
		* @param	fVelocity : Velocity of the rotation gesture ( Float )
		* @return	void
		*/
		private function _onRotCallback( fRotation : Float , fVelocity : Float ) : Void{
			_onDispatchRotation( fRotation , fVelocity );
		}

		/**
		* Callback of the swipe gesture
		* 
		* @private
		* @param	direction : Direction of gesture ( Int )
		* @return	void
		*/
		private function _onSwipeCallback( direction : Int ) : Void{
			trace('_onSwipeCallback');
			_onDispatchSwipe( direction );
		}		

		/**
		* Callback of the Tap gesture
		* 
		* @private
		* @param 	args : Callback arguments coordinates ( Array<Float> )
		* @return	void
		*/
		private function _onTapCallback( fx : Float , fy : Float ) : Void{
			#if iphone
			var res = _convertToGl( fx , fy );
			_onDispatchTap( res.x , res.y , 1 , 1 );
			#else
			_onDispatchTap( fx , fy , 1 , 1 );
			#end
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTap2Callback( fx : Float , fy : Float ) : Void{
			trace('_onTap2Callback ::: '+fx+' || '+fy);
			#if iphone
			var res = _convertToGl( fx , fy );
			_onDispatchTap( res.x , res.y , 1 , 2 );
			#else
			_onDispatchTap( fx , fy , 1 , 2 );
			#end
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTwixCallback( fx : Float , fy : Float ) : Void{
			trace('_onTwixCallback ::: '+fx+' || '+fy);
			#if iphone
			var res = _convertToGl( fx , fy );
			_onDispatchTap( res.x , res.y , 2 , 1 );
			#else
			_onDispatchTap( fx , fy , 2 , 1 );
			#end
		}

		#end

		#if iphone

		/**
		* Convert the coordinates for openGL stage coordinates
		* Warning : Seems buggy
		*
		* @private
		* @param 	f : Position to convert ( float )
		* @return	res ( FPoint )
		*/
		private function _convertToGl( fx : Float , fy : Float ) : FPoint{
			
			_fTmp.x = fx;
			_fTmp.y = fy;
			var ori : Int = hyp_touch_get_orientation( );
			
			switch ( ori ) {
				
				case Stage.OrientationPortrait:
					_fTmp.x = nme.Lib.current.stage.stageWidth - fy;
					_fTmp.y = fx;

				case Stage.OrientationPortraitUpsideDown:
					_fTmp.x = fy;
					_fTmp.y = nme.Lib.current.stage.stageHeight - fx;

				case Stage.OrientationLandscapeLeft:
					_fTmp.x = nme.Lib.current.stage.stageWidth - fy;
					_fTmp.y = fx;

				case Stage.OrientationLandscapeRight:
					_fTmp.x = fy;
					_fTmp.y = nme.Lib.current.stage.stageHeight - fx;
				
				case Stage.OrientationFaceDown:
					_fTmp.x = nme.Lib.current.stage.stageWidth - fy;
					_fTmp.y = fx;

				case Stage.OrientationFaceUp:
					_fTmp.x = nme.Lib.current.stage.stageWidth - fy;
					_fTmp.y = fx;
					
			}
			return _fTmp;
		}

		#end

		/**
		* Dispatch an Tap Event at the specified position, fingers and taps count
		* 
		* @private
		* @param	fx      : Position X of the Tap Event ( Float )
		* @param	fy      : Position Y of the Tap Event ( Float )
		* @param	fingers : Tap fingers count ( Int )
		* @param	taps    : Taps count ( Int )
		* @return	void
		*/
		private function _onDispatchTap( fx : Float , fy : Float , fingers : Int , taps : Int = 1 ) : Void{
			
			if( fingers == 1 ){

				if( taps == 2 )
					_dispatch( new GestureTapEvent( GestureTapEvent.DOUBLE_TAP , fx , fy ) );
				else if( taps == 1 )
					_dispatch( new GestureTapEvent( GestureTapEvent.TAP , fx , fy ) );				

			}else if( taps == 1 && fingers == 2 )
				_dispatch( new GestureTapEvent( GestureTapEvent.TWO_FINGERS_TAP , fx , fy ) );
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _dispatch( e : Event ) : Void{
			
			_disable( e.type );
			if( hasEventListener( e.type ) )
				dispatchEvent( e );
						
		}



		/**
		* Dispatch an Swipe Event for the specified direction
		* 
		* @private
		* @param	direction : Direction of the swipe ( Int )
		* @return	void
		*/
		private function _onDispatchSwipe( direction : Int ) : Void{
			trace('_onDispatchSwipe ::: '+direction);
			_disable( GestureSwipeEvent.SWIPE );
			dispatchEvent( new GestureSwipeEvent( direction ) );
		}

		/**
		* Dispatch an Rotation Event
		* 
		* @private
		* @param	fRotation : Rotation gesture ( Float )
		* @param	fVelocity : Rotation velocity ( Float )
		* @return	void
		*/
		private function _onDispatchRotation( fRotation : Float , fVelocity : Float ) : Void{
			_disable( GestureRotationEvent.ROTATE );
			dispatchEvent( new GestureRotationEvent( fRotation , fVelocity ) );
		}

		/**
		* Dispatch an Pan Event
		* 
		* @private
		* @param	fx : X offset 	( Float )
		* @param	fy : Y offset 	( Float )
		* @param	vx : X velocity ( Float )
		* @param	vy : Y velocity ( Float )
		* @return	void
		*/
		private function _onDispatchPan( fx : Float , fy : Float , vx : Float , vy : Float ) : Void{
			_disable( GesturePanEvent.PAN );
			dispatchEvent( new GesturePanEvent( fx , fy , vx , vy ) );
		}

		/**
		* Dispatch an Pinch Event
		* 
		* @private
		* @param 	fScale    : Pinch Scale Value ( Float )
		* @param 	fVelocity : Velocity of the pinch ( Float )
		* @return	void
		*/
		private function _onDispatchPinch( fScale : Float , fVelocity : Float ) : Void{
			
			try{ 
				_disable( GesturePinchEvent.PINCH );
				dispatchEvent( new GesturePinchEvent( fScale , fVelocity ) );
			}catch( e : Error ){
			
			}
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _disable( type : String ) : Void{
			if( !hasEventListener( type ) ){
				#if iphone
				hyp_touch_deactivate( getCode( type ) );
				#end

				#if android
				hyp_touch_toggle( getCode( type ) , false );
				#end
			}
		}

	// -------o misc
		
		/**
		* Singleton instance of the HyperTouch 
		* 
		* @public
		* @return	singleton instance of the Class
		*/
		static public function getInstance( ) : HyperTouch {
			if( __instance == null )
				__instance = new HyperTouch( );

			return __instance;
		}

		private static var __instance : HyperTouch = null;
}


#end

///!\ DO NOT CHANGE THE ORDER /!\
enum Gestures{
	TAP;
	DOUBLE_TAP;
	TWO_FINGERS_TAP;
	PAN;
	PINCH;
	ROTATE;
	SWIPE;
	LONG_PRESS;
}

typedef FPoint={
	public var x : Float;
	public var y : Float;
}