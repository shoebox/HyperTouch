h1. HyperTouch: 

HyperTouch is a native extension for Haxe / NME to handle native gestures on your Android & iOS devices.
In a performance perspective only the listened Gestures are activated.

h2. Getting started

First include the path to the HyperTouch folder in your NMML project file.

<pre><code>
<include path="extensions/hypertouch" if="mobile"/>
</code></pre>

Adding listener :

<pre><code>
<include path="extensions/hypertouch" if="mobile"/>
var hyp = HyperTouch.getInstance( );
	hyp.addEventListener( GestureTapEvent.TAP , _onTap , false );
	hyp.addEventListener( GesturePinchEvent.PINCH , _onPinch , false );
	hyp.addEventListener( GestureTapEvent.TWO_FINGERS_TAP , _onTwoFingers , false );
	hyp.addEventListener( GestureTapEvent.DOUBLE_TAP , _onDoubleTap , false );
	hyp.addEventListener( GestureSwipeEvent.SWIPE , _onSwipe , false );
	hyp.addEventListener( GesturePanEvent.PAN , _onPan , false );
	hyp.addEventListener( GestureSwipeEvent.SWIPE , _onSwipe , false );
</code></pre>

h2. TODO:
I'm not an Objective-C / Java pro-coder, so any suggestion / optimization is welcome.

- Long Press
- TwoFingers Tap on Android
- Velocity on some Gestures
- Maybe pressures... support on Android
( ... )

h3. Misc

* Twitter http://twitter.com/shoe_box
* Made at Hyperfiction ( www.hyperfiction.fr )

h2. License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.