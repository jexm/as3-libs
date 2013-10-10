package{
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.events.*;
	
	public class imgResizeInContain extends Sprite{
		// loader vaiable to hold the image
		protected var loader:Loader;
		// set the image resize max width and max height.
		protected var maxW:Number = 400, maxH:Number = 425;
		
		public function imgResizeInContain():void {
			loadImage();
		}
		
		public function loadImage():void {
			// create the loader instance from Loader class.
			loader =  new Loader();
			// create the url request vaiable to load the image.
			var urlRequest:URLRequest = new URLRequest("http://image.zcool.com.cn/bigPic/1381313143675.jpg");
			// add the event listener to the onComplete event.
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			// event listener for the IO error
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			// load the image to the loader component
			loader.load(urlRequest);
			
			// create a new sprite to hold the loader.
			var container:Sprite = new Sprite();
			container.graphics.beginFill(0x000000);
			container.graphics.drawRect(0, 0, maxW, maxH);
			// set x and y to the center align.
			container.x = (stage.stageWidth - container.width) / 2;
			container.y = (stage.stageHeight - container.height) / 2;
			// add the loader to the sprite.
			container.addChild(loader);
			// add the container to the stage.
			addChild(container)
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function onComplete(event:Event):void {
			// remove the complete listener from the loader component.
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var dispObj:DisplayObject = loaderInfo.content;
			
			// get the current image size
			var thisWidth = dispObj.width;
			var thisHeight = dispObj.height;
			
			var _ratio = thisHeight / thisWidth;
			// calculate the new width and height for the image.
			if (thisWidth > maxW) {
				thisWidth = maxW;
				thisHeight = Math.round(thisWidth * _ratio);
			}
			if (thisHeight > maxH) {
				thisHeight = maxH;
				thisWidth = Math.round(thisHeight / _ratio);
			}
			
			dispObj.width = thisWidth;
			dispObj.height = thisHeight;
			dispObj.x = (maxW - dispObj.width) / 2;
			dispObj.y = (maxH - dispObj.height) / 2;
		}
	}
}
