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
package com.soenkerohde.ga.event {
	import flash.events.Event;
	
	public class TrackActionEvent extends Event {
		
		public static const ACTION:String = "TrackActionEvent.ACTION";
		
		/**
		 * @private
		 */
		private var _category:String;
		/**
		 * @private
		 */
		private var _action:String;
		/**
		 * @private
		 */
		private var _label:String;
		/**
		 * @private
		 */
		private var _value:Number;
		
		public function get category() : String {
			return _category;
		}
		
		public function get action() : String {
			return _action;
		}
		
		public function get label() : String {
			return _label;
		}
		
		public function get value() : Number {
			return _value;
		}
		
		public function TrackActionEvent( type : String, category : String, action : String, label : String = null, value : Number = NaN, bubbles : Boolean = false, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
			_category = category;
			_action = action;
			_label = label;
			_value = value;
		}
		
		override public function clone() : Event {
			return new TrackActionEvent( type, category, action, label, value, bubbles, cancelable );
		}
	}
}