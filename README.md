as3-libs
========

fullscreenResize.as   -----  使图片填充满整个屏幕
imgResizeInContain.as  ----  使图片在某个容器里自适应填充

@featherui
listContainer.scrollerProperties.hasElasticEdges=false;  //取消回滚
listContainer.scrollerProperties.@verticalScrollBarProperties.@thumbProperties.defaultSkin = null; //取消显示滚动条

air webview load local html:
var resultsPageUrl:String = File.applicationDirectory.resolvePath("www/index.html").nativePath;
webView.loadURL(resultsPageUrl);
