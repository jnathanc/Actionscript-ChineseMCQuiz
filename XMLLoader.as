﻿package
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	
	/**
	 * ...
	 * @author Nate Jensen ...
	 */
	public class XMLLoader extends URLLoader 
	{
		public function XMLLoader() {
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		public function loadXML(path:String):void {
			try {
				this.load(new URLRequest(path));
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}			
			
		}
		
		private function securityErrorHandler(e:Event){
			trace("Security Error has occured. Please ensure these files are not read only.");
		}
			
		private function ioErrorHandler(e:Event){
			trace("An io error occur when loading the xml.");
		}
	}
}