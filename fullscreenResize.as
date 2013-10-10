// 视图片充满整个屏幕
		private function fullscreenResize(pic:Bitmap):void
		{
			//set the movieclip "pic" to 0,0 and scales X and Y to 1;
			pic.x = 0;
			pic.y = 0;
			pic.scaleX = pic.scaleY = 1;
			if ((stage.stageHeight / stage.stageWidth) < pic.height / pic.width) {
				pic.width = stage.stageWidth; //if so the width of "pic" movieclip will take the value of stageWidth;
				pic.scaleY = pic.scaleX;
			} else {
				pic.height = stage.stageHeight;//if not will take the value of stageHeight
				pic.scaleX = pic.scaleY;
			};
			
			//pic position (we can set this to 0,0 too)  水平居中
			pic.x = stage.stageWidth / 2 - pic.width / 2;
			pic.y = stage.stageHeight / 2 - pic.height / 2;
		}
