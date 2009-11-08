/*
   Copyright (c) 2009 Sönke Rohde

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
 */
package com.soenkerohde.ga {
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	/**
	 * Add FGATracker to your Swiz BeanLoader:
	 *
	 * &lt;ga:FGATracker id="fgaTracker" account="[GOOGLE ANALYTICS ID]" xmlns:ga="com.soenkerohde.ga.*" /&gt;
	 */
	
	public class FGATracker {
		
		private static const LOG:ILogger = Log.getLogger( "FGATracker" );
		
		protected var tracker:GATracker;
		
		/**
		 * @private
		 */
		protected var _account:String;
		
		/**
		 * Google Analytics account ID
		 * @param account
		 *
		 */
		public function set account( account : String ) : void {
			_account = account;
		}
		
		public function FGATracker() {
			FlexGlobals.topLevelApplication.addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
		}
		
		/**
		 * @private
		 */
		protected function creationCompleteHandler( event : FlexEvent ) : void {
			FlexGlobals.topLevelApplication.removeEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
			if ( _account != null ) {
				var display:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
				tracker = new GATracker( display, _account );
			} else {
				throw new Error( "Google Analytics account not set." );
			}
		}
		
		/**
		 * Tracks a page view.<br/>
		 * Can be called manually.
		 * Mediates @see com.soenkerohde.ga.event.TrackPageEvent TrackPageEvent
		 * @param page Page tracking id
		 */
		[Mediate(event="com.soenkerohde.ga.event.TrackPageEvent.PAGE", properties="page")]
		public function trackPage( page : String ) : void {
			LOG.info( "trackPage " + page );
			tracker.trackPageview( page );
		}
		
		/**
		 * Tracks an action.<br/>
		 * Can be called manually.
		 * Mediates @see com.soenkerohde.ga.event.TrackActionEvent TrackActionEvent
		 * @param category
		 * @param action
		 * @param label
		 * @param value
		 */
		[Mediate(event="com.soenkerohde.ga.event.TrackActionEvent.ACTION", properties="category,action,label,value")]
		public function trackAction( category : String, action : String, label : String, value : Number ) : void {
			LOG.info( "trackAction " + category + ", " + action + ", " + label + ", " + value );
			tracker.trackEvent( category, action, label, value );
		}
	
	
	
	}
}