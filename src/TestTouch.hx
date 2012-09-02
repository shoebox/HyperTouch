package ;

import haxe.Timer;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.MouseEvent;
import nme.events.Event;
import nme.installer.Assets;
import nme.Lib;
#if mobile
import fr.hyperfiction.HyperTouch;
import fr.hyperfiction.events.GesturePanEvent;
import fr.hyperfiction.events.GesturePinchEvent;
import fr.hyperfiction.events.GestureRotationEvent;
import fr.hyperfiction.events.GestureSwipeEvent;
import fr.hyperfiction.events.GestureTapEvent;
#end

/**
 * ...
 * @author shoe[box]
 */

class TestTouch extends Sprite{

	private var _spDemo	: Sprite;
	private var _spTap	: Sprite;
	private var _bTapGesture : Bool;
	
	private var _spSwipeL : Sprite;
	private var _spSwipeR : Sprite;
	private var _spSwipeT : Sprite;
	private var _spSwipeB : Sprite;

	// -------o constructor
		
		/**
		* constructor
		*
		* @param	
		* @return	void
		*/
		public function new() {
			trace('constructor');	
			super( );		

			Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
			Lib.current.stage.align = StageAlign.TOP_LEFT;
			#if iphone
			Lib.current.stage.addEventListener( Event.RESIZE , _onResize , false );
			#else
			_onResize( );
			#end
		}
	
	// -------o public
		
	// -------o protected
		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onResize( e : Event = null ) : Void{
			trace('_onResize');
			
			#if mobile
			Stage.shouldRotateInterface = function( inOrientation : Int ) : Bool{
				return ( inOrientation == Stage.OrientationLandscapeRight || inOrientation == Stage.OrientationLandscapeLeft );
			};
			#end

			Lib.current.stage.removeEventListener( Event.RESIZE , _onResize , false );
			haxe.Timer.delay( _run , 1000 );

			var size = Math.min( Lib.current.stage.stageWidth , Lib.current.stage.stageHeight );
				size *= 0.3;

			var blocSize = 40;
			_spSwipeL = new Sprite( );
			_spSwipeL.alpha = 0;
			_spSwipeL.graphics.beginFill( 0x00FF00 );
			_spSwipeL.graphics.drawRect( 0 , 0 , blocSize , Lib.current.stage.stageHeight );
			_spSwipeL.graphics.endFill( );
			addChild( _spSwipeL );

			_spSwipeR = new Sprite( );
			_spSwipeR.alpha = 0;
			_spSwipeR.x = Lib.current.stage.stageWidth - blocSize;
			_spSwipeR.graphics.beginFill( 0x00FF00 );
			_spSwipeR.graphics.drawRect( 0 , 0 , blocSize , Lib.current.stage.stageHeight );
			_spSwipeR.graphics.endFill( );
			addChild( _spSwipeR );

			_spSwipeT = new Sprite( );
			_spSwipeT.alpha = 0;
			_spSwipeT.graphics.beginFill( 0x00FF00 );
			_spSwipeT.graphics.drawRect( 0 , 0 , Lib.current.stage.stageWidth , blocSize );
			_spSwipeT.graphics.endFill( );
			addChild( _spSwipeT );

			_spSwipeB = new Sprite( );
			_spSwipeB.alpha = 0;
			_spSwipeB.graphics.beginFill( 0x00FF00 );
			_spSwipeB.y = Lib.current.stage.stageHeight - blocSize;
			_spSwipeB.graphics.drawRect( 0 , 0 , Lib.current.stage.stageWidth , blocSize );
			_spSwipeB.graphics.endFill( );
			addChild( _spSwipeB );

			_spDemo = new Sprite( );
			_spDemo.graphics.beginFill( 0xFF6600 );
			_spDemo.graphics.drawRect( -size , -size , size * 2 , size * 2 );
			_spDemo.graphics.endFill( );
			_spDemo.x = Lib.current.stage.stageWidth / 2;
			_spDemo.y = Lib.current.stage.stageHeight / 2;
			addChild( _spDemo );

			_spTap = new Sprite( );
			addChild( _spTap );

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _run( ) : Void{
			
			Lib.current.stage.addEventListener( MouseEvent.CLICK , function( _ ) {trace('NME Click');} , false );

			#if mobile
			var hyp = HyperTouch.getInstance( );
				hyp.addEventListener( GestureSwipeEvent.SWIPE , _onSwipe , false );
				hyp.addEventListener( GesturePanEvent.PAN , _onPan , false );
				hyp.addEventListener( GestureTapEvent.TAP , _onTap , false );
				hyp.addEventListener( GestureTapEvent.DOUBLE_TAP , _onDoubleTap , false );
				hyp.addEventListener( GestureTapEvent.TWO_FINGERS_TAP , _onTwoFingers , false );
				hyp.addEventListener( GesturePinchEvent.PINCH , _onPinch , false );
				hyp.addEventListener( GestureRotationEvent.ROTATE , _onRotation , false );
				_bTapGesture = true;
			#end

		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onFrame( _ ) : Void{
			trace( Lib.current.stage.width +' - '+Lib.current.stage.height);
		}

		
		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _resetTimer( t : Timer ) : Void{
			if( t == null )
				return;
			t.stop( );
		}

		#if mobile

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onPan( e : GesturePanEvent ) : Void{
			_spDemo.x += e.offsetX;
			_spDemo.y += e.offsetY;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onPinch( e : GesturePinchEvent ) : Void{
			trace('_onPinch ::: '+e.scale);
			_spDemo.scaleX = e.scale;
			_spDemo.scaleY = e.scale;
			
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onRotation( e : GestureRotationEvent ) : Void{
			_spDemo.rotation = e.rotation * 180 / Math.PI;
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onSwipe( e : GestureSwipeEvent ) : Void{
			trace('onSwipe ::: '+e);
			var sp = null;
			switch( e.direction ){

				case GestureSwipeEvent.DIRECTION_LEFT:
					sp = _spSwipeL;

				case GestureSwipeEvent.DIRECTION_RIGHT:
					sp = _spSwipeR;

				case GestureSwipeEvent.DIRECTION_UP:
					sp = _spSwipeT;

				case GestureSwipeEvent.DIRECTION_DOWN:
					sp = _spSwipeB;

			}

			sp.alpha = 1;
			haxe.Timer.delay( function( ){
				sp.alpha = 0;
				} , 1000 );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTap( e : GestureTapEvent ) : Void{
			trace('onTap ::: '+e);
			_spTap.graphics.clear( );
			_spTap.graphics.lineStyle( 4 , 0xFF0000 );
			_spTap.graphics.drawCircle( e.stageX , e.stageY , 30 );
			//_spTap.graphics.drawCircle( e.stageX , e.stageY , 45 );
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onTwoFingers( e : GestureTapEvent ) : Void{
			trace('_onTwoFingers');
		}

		/**
		* 
		* 
		* @private
		* @return	void
		*/
		private function _onDoubleTap( e : GestureTapEvent ) : Void{
			trace('onDoubleTap ::: '+e);
			_spTap.graphics.clear( );
			_spTap.graphics.lineStyle( 4 , 0xFF0000 );
			_spTap.graphics.drawCircle( e.stageX , e.stageY , 30 );
			_spTap.graphics.drawCircle( e.stageX , e.stageY , 45 );
		}

		#end

	// -------o misc
		
		public static function main () {
			Lib.current.addChild ( new TestTouch() );		
		}
}