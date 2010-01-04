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
	import com.soenkerohde.ga.event.TrackActionEvent;
	import com.soenkerohde.ga.event.TrackPageEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Application;
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
		 * @private
		 */
		protected var _unTracked:Array;
		
		/**
		 * Google Analytics account ID
		 * @param account
		 *
		 */
		public function set account( account : String ) : void {
			_account = account;
		}
		
		public function FGATracker() {
			if ( CONFIG::flex4 ) {
				FlexGlobals.topLevelApplication.addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
			} else {
				Application.application.addEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
			}
		}
		
		/**
		 * @private
		 */
		protected function creationCompleteHandler( event : FlexEvent ) : void {
			if ( _account == null ) {
				throw new Error( "Google Analytics account not set." );
			} else {
				
				var display:DisplayObject;
				
				if ( CONFIG::flex4 ) {
					FlexGlobals.topLevelApplication.removeEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
					display = FlexGlobals.topLevelApplication as DisplayObject;
				} else {
					Application.application.removeEventListener( FlexEvent.CREATION_COMPLETE, creationCompleteHandler );
					display = Application.application as DisplayObject;
				}
				tracker = new GATracker( display, _account );
				
				if ( _unTracked != null ) {
					for each ( var e : Event in _unTracked ) {
						if ( e is TrackPageEvent ) {
							trackPage( e as TrackPageEvent );
						} else if ( e is TrackActionEvent ) {
							trackAction( e as TrackActionEvent );
						} else {
							throw new Error( "Unknown event type " + e.type );
						}
					}
					
					_unTracked = null;
				}
			}
		}
		
		/**
		 * Tracks a page view.<br/>
		 * Can be called manually.
		 * Mediates @see com.soenkerohde.ga.event.TrackPageEvent TrackPageEvent
		 * @param page Page tracking id
		 */
		[Mediate(event="com.soenkerohde.ga.event.TrackPageEvent.PAGE")]
		public function trackPage( event : TrackPageEvent ) : void {
			
			if ( tracker != null ) {
				LOG.info( "trackPage " + event.page );
				tracker.trackPageview( event.page );
			} else {
				_unTracked ||= [];
				_unTracked.push( event );
			}
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
		[Mediate(event="com.soenkerohde.ga.event.TrackActionEvent.ACTION")]
		public function trackAction( event : TrackActionEvent ) : void {
			if ( tracker != null ) {
				LOG.info( "trackAction " + event.category + ", " + event.action + ", " + event.label + ", " + event.value );
				tracker.trackEvent( event.category, event.action, event.label, event.value );
			} else {
				_unTracked ||= [];
				_unTracked.push( event );
			}
		}
	
	
	
	}
}