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



AIR-----------------------------

2008年06月02日    |        还没有评论!
AIR文件操作(二):使用文件对象操作文件和目录
文件对象是啥？
文件对象(File对象)是在文件系统中指向文件或目录的指针。由于安全原因，只在AIR中可用。

文件对象能做啥？

获取特定目录，包括用户目录、用户文档目录、该应用程序启动的目录和程序目录
拷贝文件和目录
移动文件和目录
删除文件和目录（或移至回收站）
列出某目录中的文件和目录
创建临时文件和文件夹
创建目录
读取文件信息
获取文件系统信息
在AIR中，我们用FileStream读写文件的前提就是用File对象来指向文件。

那么文件对象具体怎么玩呢？

功能1、指向目录和文件
File对象有两个属性都能定义文件路径，它们是nativePath和url。nativePath是在特定平台使用的文件路径（主要就是Windows和MacOs上的路径表示不同），url则是统一的”file:///c:/Sample%20directory/test.txt”这样的表示方法。

我们来看几个指向目录的实例，其中1－7演示了如何获取特殊目录：

var file:File = File.userDirectory; //指向用户文件夹
var file:File = File.documentsDirectory; //指向用户文档文件夹
var file:File = File.desktopDirectory; //指向桌面
var file:File = File.applicationStorageDirectory; //指向应用程序存储目录
（参见AIR的URL方案）

var dir:File = File.applicationDirectory; //应用程序安装目录
var dir:File = File.getRootDirectories(); //文件系统根目录
还有一招，指向请求启动该应用程序的目录，先空着，以后补上。参考资料见《Capturing command
line arguments》
var file:File = new File();
file.nativePath = "C:Mousebomb";
//(windows平台)指向一个具体的目录，这里使用了nativePath属性，”C:Mousebomb”只适用windows中。

var file:File = File.userDirectory;
file = file.resolvePath(“Mousebomb”);
//跳转到用户目录下的Mousebomb目录
var urlStr:String = "file:///C:/Mousebomb/";
var file:File = new File()
file.url = urlStr;
//指向c盘下的Mousebomb目录，这里使用了url属性
/*让用户选择目录*/
var file:File = new File();
file.addEventListener(Event.SELECT, dirSelected);
file.browseForDirectory("Select a directory");
function dirSelected(e:Event):void {
trace(file.nativePath);
}
下面看看指向文件的实例：

指向明确的文件地址：
var file:File = File.applicationStorageDirectory;
file = file.resolvePath("Flashj.txt");
使用url属性的例子：
var urlStr:String = "file:///C:/Mousebomb/Flashj.txt";
var file:File = new File()
file.url = urlStr;
当然你也可以直接这样写
var urlStr:String = "file:///C: /Mousebomb/Flashj.txt";
var file:File = new File(urlStr);
//url中的空格会被%20替换
使用nativePath属性：
var file:File = new File();
file.nativePath = "C:/ Mousebomb/Flashj.txt";
或者
var file:File = new File("C:/ Mousebomb/Flashj.txt");
//(Windows下)
通过对话框让用户选择文件
实现这个功能需要认识三个方法：
browseForOpen()
browseForSave()
browseForOpenMultiple()
三个方法都是异步的，browseForOpen() 和 browseForSave()方法在用户选择文件时会触发select事件，在选择了某文件时，File指向选择的文件。 而browseForOpenMultiple()方法会触发selectMultiple事件，该事件属于FileListEvent型，它的属性中具有指向所选文件的File对象数组。
例子：
var fileToOpen:File = File.documentsDirectory;
selectTextFile(fileToOpen);
function selectTextFile(root:File):void
{
var txtFilter:FileFilter = new FileFilter("Text", "*.as;*.css;*.html;*.txt;*.xml");
root.browseForOpen("Open", [txtFilter]);
root.addEventListener(Event.SELECT, fileSelected);
}
function fileSelected(event:Event):void
{
trace(fileToOpen.nativePath);
}
功能2、拷贝文件和目录
拷贝文件使用到的方法有copyTo()和copyToAsync()，详见AIR文件基础，前者为同步方法，后者为异步方法。
要拷贝文件，需要创建2个File对象，一个指向原文件，一个指向目标文件。像下面两例：
1.同步拷贝例：

var original:File = File.documentsDirectory.resolvePath("Mousebomb/FlashJ.txt");
var newFile:File = File.resolvePath("Mousebomb/FlashJcn.txt");
original.copyTo(newFile, true);
第二个参数true表示覆盖存在的文件，默认值是false，若设置为false，而拷贝的目标文件已经存在，则AIR会发出IOErrorEvent事件。
2.异步拷贝例：

var original = File.documentsDirectory;
original = original.resolvePath("Mousebomb/FlashJ.txt");
var destination:File = File.documentsDirectory;
destination = destination.resolvePath("FlashJ/FlashJcn.txt");
original.addEventListener(Event.COMPLETE, fileCopyCompleteHandler);
original.addEventListener(IOErrorEvent.IO_ERROR, fileCopyIOErrorEventHandler);
 
 
original.CopyToAsync(destination);
function fileCopyCompleteHandler(event:Event):void {
trace(event.target); // [object File]
}
function fileCopyIOErrorEventHandler(event:IOErrorEvent):void {
trace("I/O Error.");
}
功能3、移动文件和目录
移动文件使用的方法有moveTo()和MoveToAsync()，不仅长相类似，连使用方法都与拷贝文件一样，可以直接参考上文。

功能4、删除文件和目录（或移至回收站）
deleteFile()和deleteFileAsync()负责删除功能，而moveToTrash()和moveToTrashAsync()功能是移至回收站。先创建一个File对象指向某个文件或目录，然后执行四个方法之一，处理异步方法要加事件监听。

var file:File = File.documentsDirectory.resolvePath("DeleteMe.txt");
file.moveToTrash();
功能5、列出某目录中的文件和目录
可以使用getDirectoryListing()方法和getDirectoryListingAsync()方法获取某个目录下文件与子目录的File指针数组。
例如：

var directory:File = File.documentsDirectory;
var contents:Array = directory.getDirectoryListing();
for (var i:uint = 0; i < contents.length; i++)
{
trace(contents[i].name, contents[i].size);
}
本例输出了用户文档目录中的文件名和大小。
若使用异步方法，例如：

var directory:File = File.documentsDirectory;
directory.getDirectoryListingAsync();
directory.addEventListener(FileListEvent.DIRECTORY_LISTING, dirListHandler);
function dirListHandler(event:FileListEvent):void
{
var contents:Array = event.files;
for (var i:uint = 0; i < contents.length; i++)
{
trace(contents[i].name, contents[i].size);
}
}
其中directoryListing事件对象中有个files属性，为目录下内容的File指针数组。

功能6、创建临时文件和文件夹
使用createTempFile()和createTempDirectory()方法可以创建临时文件和文件夹。
var temp:File = File.createTempFile(); //在系统临时文件夹下创建临时文件
createTempFile()方法会自动创建一个唯一的临时文件。
createTempDirectory ()方法会自动创建一个唯一的临时文件夹。
你可以用临时文件来临时存储应用程序回话中的信息。
由于临时文件不会自动删除，所以你可能得让应用程序在关闭前删除它。

功能7、创建目录
使用createDirectory()方法可以创建目录，例如：

var dir:File = File.userDirectory.resolvePath("Mousebomb");
dir.createDirectory();
这个例子在用户文件夹下创建了Mousebomb目录，如果Mousebomb目录存在，则不会作出操作。

功能8、读取文件信息
File类中包含以下属性，提供File对象所指向文件或目录的信息。

属性

描述

creationDate

创建日期

exists

是否存在

extension

扩展名，若无则为null

icon

该文件的图标对象

isDirectory

是否目录

modificationDate

修改日期

name

文件名（包括扩展名）

nativePath

特定平台使用的文件路径

parent

父级目录,若该File对象就是顶级则此属性为null

size

字节大小

url

统一资源定位符

详细参见AIR ActionScript 3.0 Language Reference for Adobe AIR.

功能9、获取文件系统信息
File类包含一下静态属性，提供有用的文件系统信息（主要是跨平台使用）：

属性

描述

File.lineEnding

系统的行结束符

File.separator

系统的分隔符(Windows下为 Mac Os为/)

File.systemCharset

系统的默认文件编码，属于系统所使用的字符集

顺便插进Capabilities类包含的静态属性：

属性

描述

Capabilities.hasIME

当前运行的系统是否安装了输入法编辑器

Capabilities.language

当前运行的系统的语言编码

Capabilities.os

当前运行的操作系统

参考文献：http://livedocs.adobe.com/air/1/devappsflash/help.html?content=dg_part_6_1.html(文件与数据)
（本文若有不当之处,敬请指出。）
